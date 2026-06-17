-- =============================================================================
-- 0002_functions_triggers.sql — helpers, numbering, stock, accountability
-- These run as SECURITY DEFINER so they can write the audit trail / adjust stock
-- regardless of the caller's RLS permissions (and so RLS helpers don't recurse).
-- =============================================================================

-- ---- RLS helpers ------------------------------------------------------------
-- SECURITY DEFINER + reading profiles here is what prevents the classic
-- "policy on profiles references profiles" infinite-recursion problem.
create or replace function public.current_org_id()
  returns uuid language sql stable security definer set search_path = public as $$
  select organization_id from public.profiles where id = auth.uid();
$$;

create or replace function public.current_user_role()
  returns user_role language sql stable security definer set search_path = public as $$
  select role from public.profiles where id = auth.uid();
$$;

-- ---- updated_at maintenance -------------------------------------------------
create or replace function public.set_updated_at()
  returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

create trigger trg_items_updated     before update on inventory_items for each row execute function public.set_updated_at();
create trigger trg_customers_updated before update on customers       for each row execute function public.set_updated_at();
create trigger trg_employees_updated before update on employees       for each row execute function public.set_updated_at();

-- ---- Document numbering (SAL-000001, PUR-000001, EXP-000001) -----------------
-- Atomic per-org counter: the upsert locks the counter row, so concurrent
-- inserts can never produce duplicate numbers.
create or replace function public.next_doc_number(p_org uuid, p_type text, p_prefix text)
  returns text language plpgsql security definer set search_path = public as $$
declare n bigint;
begin
  insert into doc_counters (organization_id, doc_type, last_value)
  values (p_org, p_type, 1)
  on conflict (organization_id, doc_type)
  do update set last_value = doc_counters.last_value + 1
  returning last_value into n;
  return p_prefix || lpad(n::text, 6, '0');
end $$;

create or replace function public.set_sale_number()
  returns trigger language plpgsql security definer set search_path = public as $$
begin
  if new.sale_number is null then
    new.sale_number := public.next_doc_number(new.organization_id, 'sale', 'SAL-');
  end if;
  return new;
end $$;
create trigger trg_sale_number before insert on sales for each row execute function public.set_sale_number();

create or replace function public.set_purchase_number()
  returns trigger language plpgsql security definer set search_path = public as $$
begin
  if new.purchase_number is null then
    new.purchase_number := public.next_doc_number(new.organization_id, 'purchase', 'PUR-');
  end if;
  return new;
end $$;
create trigger trg_purchase_number before insert on purchases for each row execute function public.set_purchase_number();

create or replace function public.set_expense_number()
  returns trigger language plpgsql security definer set search_path = public as $$
begin
  if new.expense_number is null then
    new.expense_number := public.next_doc_number(new.organization_id, 'expense', 'EXP-');
  end if;
  return new;
end $$;
create trigger trg_expense_number before insert on expenses for each row execute function public.set_expense_number();

-- ---- Low-stock notifications ------------------------------------------------
create or replace function public.maybe_notify_low_stock(p_item uuid)
  returns void language plpgsql security definer set search_path = public as $$
declare it inventory_items%rowtype; rec record;
begin
  select * into it from inventory_items where id = p_item;
  if not found then return; end if;
  if it.reorder_level > 0 and it.quantity_in_stock <= it.reorder_level then
    for rec in
      select id from profiles
      where organization_id = it.organization_id and role in ('owner', 'manager') and is_active
    loop
      insert into notifications (organization_id, recipient_id, triggered_by, type, title, message, entity_type, entity_id)
      values (it.organization_id, rec.id, null, 'inventory_low', 'Low stock alert',
              it.name || ' is low (' || it.quantity_in_stock || ' ' || it.unit || ' left)', 'inventory_item', it.id);
    end loop;
  end if;
end $$;

-- ---- Stock movement on sale / purchase line items ---------------------------
create or replace function public.handle_sale_item()
  returns trigger language plpgsql security definer set search_path = public as $$
declare v_org uuid; v_user uuid;
begin
  select organization_id, recorded_by into v_org, v_user from sales where id = new.sale_id;
  update inventory_items
     set quantity_in_stock = quantity_in_stock - new.quantity
   where id = new.inventory_item_id;
  insert into inventory_movements (organization_id, inventory_item_id, movement_type, quantity, reason, reference_type, reference_id, recorded_by)
  values (v_org, new.inventory_item_id, 'out', new.quantity, 'sale', 'sale', new.sale_id, v_user);
  perform public.maybe_notify_low_stock(new.inventory_item_id);
  return new;
end $$;
create trigger trg_sale_item after insert on sale_items for each row execute function public.handle_sale_item();

create or replace function public.handle_purchase_item()
  returns trigger language plpgsql security definer set search_path = public as $$
declare v_org uuid; v_user uuid;
begin
  select organization_id, recorded_by into v_org, v_user from purchases where id = new.purchase_id;
  update inventory_items
     set quantity_in_stock = quantity_in_stock + new.quantity
   where id = new.inventory_item_id;
  insert into inventory_movements (organization_id, inventory_item_id, movement_type, quantity, reason, reference_type, reference_id, recorded_by)
  values (v_org, new.inventory_item_id, 'in', new.quantity, 'purchase', 'purchase', new.purchase_id, v_user);
  return new;
end $$;
create trigger trg_purchase_item after insert on purchase_items for each row execute function public.handle_purchase_item();

-- ---- Activity trail + owner notifications -----------------------------------
create or replace function public.handle_new_sale()
  returns trigger language plpgsql security definer set search_path = public as $$
declare v_actor text; rec record;
begin
  select full_name into v_actor from profiles where id = new.recorded_by;
  insert into activity_log (organization_id, user_id, action, entity_type, entity_id, description, metadata)
  values (new.organization_id, new.recorded_by, 'created', 'sale', new.id,
          coalesce(v_actor, 'Someone') || ' recorded sale ' || coalesce(new.sale_number, '') ||
          ' for GH₵' || new.total_amount,
          jsonb_build_object('total_amount', new.total_amount, 'sale_number', new.sale_number));
  for rec in
    select id from profiles where organization_id = new.organization_id and role = 'owner' and is_active
  loop
    insert into notifications (organization_id, recipient_id, triggered_by, type, title, message, entity_type, entity_id)
    values (new.organization_id, rec.id, new.recorded_by, 'sale_created', 'New sale recorded',
            coalesce(v_actor, 'Someone') || ' recorded a sale of GH₵' || new.total_amount, 'sale', new.id);
  end loop;
  return new;
end $$;
create trigger trg_new_sale after insert on sales for each row execute function public.handle_new_sale();

create or replace function public.handle_new_purchase()
  returns trigger language plpgsql security definer set search_path = public as $$
declare v_actor text; rec record;
begin
  select full_name into v_actor from profiles where id = new.recorded_by;
  insert into activity_log (organization_id, user_id, action, entity_type, entity_id, description, metadata)
  values (new.organization_id, new.recorded_by, 'created', 'purchase', new.id,
          coalesce(v_actor, 'Someone') || ' recorded purchase ' || coalesce(new.purchase_number, '') ||
          ' for GH₵' || new.total_amount,
          jsonb_build_object('total_amount', new.total_amount, 'purchase_number', new.purchase_number));
  for rec in
    select id from profiles where organization_id = new.organization_id and role = 'owner' and is_active
  loop
    insert into notifications (organization_id, recipient_id, triggered_by, type, title, message, entity_type, entity_id)
    values (new.organization_id, rec.id, new.recorded_by, 'purchase_created', 'New purchase recorded',
            coalesce(v_actor, 'Someone') || ' recorded a purchase of GH₵' || new.total_amount, 'purchase', new.id);
  end loop;
  return new;
end $$;
create trigger trg_new_purchase after insert on purchases for each row execute function public.handle_new_purchase();

create or replace function public.handle_new_expense()
  returns trigger language plpgsql security definer set search_path = public as $$
declare v_actor text; rec record;
begin
  select full_name into v_actor from profiles where id = new.recorded_by;
  insert into activity_log (organization_id, user_id, action, entity_type, entity_id, description, metadata)
  values (new.organization_id, new.recorded_by, 'created', 'expense', new.id,
          coalesce(v_actor, 'Someone') || ' logged expense ' || coalesce(new.expense_number, '') ||
          ' for GH₵' || new.amount,
          jsonb_build_object('amount', new.amount, 'expense_number', new.expense_number));
  for rec in
    select id from profiles where organization_id = new.organization_id and role = 'owner' and is_active
  loop
    insert into notifications (organization_id, recipient_id, triggered_by, type, title, message, entity_type, entity_id)
    values (new.organization_id, rec.id, new.recorded_by, 'expense_logged', 'New expense logged',
            coalesce(v_actor, 'Someone') || ' logged an expense of GH₵' || new.amount, 'expense', new.id);
  end loop;
  return new;
end $$;
create trigger trg_new_expense after insert on expenses for each row execute function public.handle_new_expense();

-- ---- Auto-create a profile when a user signs up -----------------------------
-- New users join the (single) seeded organization as 'staff'. Promote the two
-- owners to 'owner' once after they sign up (see README / 0004 notes).
create or replace function public.handle_new_user()
  returns trigger language plpgsql security definer set search_path = public as $$
declare v_org uuid;
begin
  select id into v_org from organizations order by created_at asc limit 1;
  if v_org is not null then
    insert into public.profiles (id, organization_id, full_name, email, role)
    values (new.id, v_org, coalesce(new.raw_user_meta_data ->> 'full_name', new.email), new.email, 'staff')
    on conflict (id) do nothing;
  end if;
  return new;
end $$;
create trigger on_auth_user_created after insert on auth.users for each row execute function public.handle_new_user();
