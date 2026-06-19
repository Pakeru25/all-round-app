-- =============================================================================
-- All Round App (Pakeru) — full database schema (combined)
--
-- This file is generated from migrations/0001..0005. To set up a fresh Supabase
-- project the easy way: open the Supabase SQL Editor, paste this whole file, Run.
-- (Advanced: use the individual files in ./migrations with the Supabase CLI.)
-- =============================================================================


-- >>> migrations/0001_schema.sql

-- =============================================================================
-- 0001_schema.sql — extensions, enums, tables, indexes
-- All Round App (Pakeru). Every business table carries organization_id so that
-- Row-Level Security (see 0003) can isolate each organization's data.
-- =============================================================================

create extension if not exists pgcrypto; -- gen_random_uuid()

-- ---- Enums ------------------------------------------------------------------
create type user_role         as enum ('owner', 'manager', 'staff', 'accountant');
create type movement_type     as enum ('in', 'out', 'adjustment');
create type movement_reason   as enum ('sale', 'purchase', 'return', 'damage', 'manual_adjustment');
create type payment_method    as enum ('cash', 'transfer', 'card', 'credit');
create type payment_status    as enum ('paid', 'partial', 'unpaid');
create type employee_status   as enum ('active', 'inactive');
create type activity_action   as enum ('created', 'updated', 'deleted');
create type notification_type as enum ('sale_created', 'expense_logged', 'purchase_created', 'inventory_low', 'inventory_adjusted');
create type inventory_type    as enum ('raw_material', 'packaging_material', 'finished_product');

-- ---- Organizations ----------------------------------------------------------
create table organizations (
  id         uuid primary key default gen_random_uuid(),
  name       text not null,
  currency   text not null default 'GHS',
  created_at timestamptz not null default now()
);

-- ---- Profiles (extends Supabase auth.users) ---------------------------------
create table profiles (
  id              uuid primary key references auth.users (id) on delete cascade,
  organization_id uuid not null references organizations (id) on delete restrict,
  full_name       text,
  email           text,
  role            user_role not null default 'staff',
  avatar_url      text,
  is_active       boolean not null default true,
  created_at      timestamptz not null default now()
);
create index profiles_org_idx on profiles (organization_id);

-- ---- Inventory --------------------------------------------------------------
create table inventory_categories (
  id              uuid primary key default gen_random_uuid(),
  organization_id uuid not null references organizations (id) on delete cascade,
  name            text not null,
  description     text,
  type            inventory_type not null default 'finished_product',
  created_at      timestamptz not null default now()
);
create index inventory_categories_org_idx on inventory_categories (organization_id);

create table inventory_items (
  id                uuid primary key default gen_random_uuid(),
  organization_id   uuid not null references organizations (id) on delete cascade,
  category_id       uuid references inventory_categories (id) on delete set null,
  inventory_type    inventory_type,
  name              text not null,
  sku               text,
  description       text,
  unit              text not null default 'pieces',
  quantity_in_stock numeric not null default 0,
  cost_price        numeric not null default 0,
  selling_price     numeric not null default 0,
  reorder_level     integer not null default 0,
  image_url         text,
  is_active         boolean not null default true,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now(),
  unique (organization_id, sku)
);
create index inventory_items_org_idx on inventory_items (organization_id);
create index inventory_items_category_idx on inventory_items (category_id);

-- Audit trail of every stock change (written by triggers + manual adjustments).
create table inventory_movements (
  id                uuid primary key default gen_random_uuid(),
  organization_id   uuid not null references organizations (id) on delete cascade,
  inventory_item_id uuid not null references inventory_items (id) on delete cascade,
  movement_type     movement_type not null,
  quantity          numeric not null,
  reason            movement_reason not null,
  reference_type    text,
  reference_id      uuid,
  notes             text,
  recorded_by       uuid references profiles (id) on delete set null,
  created_at        timestamptz not null default now()
);
create index inventory_movements_org_idx on inventory_movements (organization_id);
create index inventory_movements_item_idx on inventory_movements (inventory_item_id);

-- ---- Contacts ---------------------------------------------------------------
create table customers (
  id              uuid primary key default gen_random_uuid(),
  organization_id uuid not null references organizations (id) on delete cascade,
  name            text not null,
  email           text,
  phone           text,
  address         text,
  notes           text,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);
create index customers_org_idx on customers (organization_id);

create table suppliers (
  id              uuid primary key default gen_random_uuid(),
  organization_id uuid not null references organizations (id) on delete cascade,
  name            text not null,
  contact_person  text,
  email           text,
  phone           text,
  address         text,
  notes           text,
  created_at      timestamptz not null default now()
);
create index suppliers_org_idx on suppliers (organization_id);

-- ---- Sales ------------------------------------------------------------------
create table sales (
  id              uuid primary key default gen_random_uuid(),
  organization_id uuid not null references organizations (id) on delete cascade,
  customer_id     uuid references customers (id) on delete set null,
  recorded_by     uuid references profiles (id) on delete set null,
  sale_number     text,
  sale_date       date not null default current_date,
  subtotal        numeric not null default 0,
  discount        numeric not null default 0,
  total_amount    numeric not null default 0,
  payment_method  payment_method not null default 'cash',
  payment_status  payment_status not null default 'paid',
  notes           text,
  created_at      timestamptz not null default now(),
  unique (organization_id, sale_number)
);
create index sales_org_idx on sales (organization_id);
create index sales_customer_idx on sales (customer_id);

create table sale_items (
  id                uuid primary key default gen_random_uuid(),
  sale_id           uuid not null references sales (id) on delete cascade,
  inventory_item_id uuid not null references inventory_items (id) on delete restrict,
  quantity          numeric not null,
  unit_price        numeric not null default 0,
  total_price       numeric not null default 0
);
create index sale_items_sale_idx on sale_items (sale_id);

-- ---- Purchases --------------------------------------------------------------
create table purchases (
  id              uuid primary key default gen_random_uuid(),
  organization_id uuid not null references organizations (id) on delete cascade,
  supplier_id     uuid references suppliers (id) on delete set null,
  recorded_by     uuid references profiles (id) on delete set null,
  purchase_number text,
  purchase_date   date not null default current_date,
  total_amount    numeric not null default 0,
  payment_method  payment_method not null default 'cash',
  payment_status  payment_status not null default 'paid',
  notes           text,
  created_at      timestamptz not null default now(),
  unique (organization_id, purchase_number)
);
create index purchases_org_idx on purchases (organization_id);

create table purchase_items (
  id                uuid primary key default gen_random_uuid(),
  purchase_id       uuid not null references purchases (id) on delete cascade,
  inventory_item_id uuid not null references inventory_items (id) on delete restrict,
  quantity          numeric not null,
  unit_cost         numeric not null default 0,
  total_cost        numeric not null default 0
);
create index purchase_items_purchase_idx on purchase_items (purchase_id);

-- ---- Expenses ---------------------------------------------------------------
create table expense_categories (
  id              uuid primary key default gen_random_uuid(),
  organization_id uuid not null references organizations (id) on delete cascade,
  name            text not null,
  created_at      timestamptz not null default now()
);
create index expense_categories_org_idx on expense_categories (organization_id);

create table expenses (
  id              uuid primary key default gen_random_uuid(),
  organization_id uuid not null references organizations (id) on delete cascade,
  category_id     uuid references expense_categories (id) on delete set null,
  recorded_by     uuid references profiles (id) on delete set null,
  expense_number  text,
  amount          numeric not null default 0,
  description     text,
  expense_date    date not null default current_date,
  receipt_url     text,
  created_at      timestamptz not null default now(),
  unique (organization_id, expense_number)
);
create index expenses_org_idx on expenses (organization_id);

-- ---- Employees --------------------------------------------------------------
create table employees (
  id              uuid primary key default gen_random_uuid(),
  organization_id uuid not null references organizations (id) on delete cascade,
  full_name       text not null,
  position        text,
  phone           text,
  email           text,
  salary          numeric,
  hire_date       date,
  status          employee_status not null default 'active',
  linked_user_id  uuid references profiles (id) on delete set null,
  notes           text,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);
create index employees_org_idx on employees (organization_id);

-- ---- Accountability ---------------------------------------------------------
-- Append-only trail. No UPDATE/DELETE policies are ever created (see 0003).
create table activity_log (
  id              uuid primary key default gen_random_uuid(),
  organization_id uuid not null references organizations (id) on delete cascade,
  user_id         uuid references profiles (id) on delete set null,
  action          activity_action not null,
  entity_type     text not null,
  entity_id       uuid,
  description     text not null,
  metadata        jsonb not null default '{}'::jsonb,
  created_at      timestamptz not null default now()
);
create index activity_log_org_idx on activity_log (organization_id);
create index activity_log_created_idx on activity_log (created_at desc);

create table notifications (
  id              uuid primary key default gen_random_uuid(),
  organization_id uuid not null references organizations (id) on delete cascade,
  recipient_id    uuid not null references profiles (id) on delete cascade,
  triggered_by    uuid references profiles (id) on delete set null,
  type            notification_type not null,
  title           text not null,
  message         text not null,
  entity_type     text,
  entity_id       uuid,
  is_read         boolean not null default false,
  created_at      timestamptz not null default now()
);
create index notifications_recipient_idx on notifications (recipient_id, is_read);

-- Per-organization counters that back the SAL-/PUR-/EXP- numbering (see 0002).
create table doc_counters (
  organization_id uuid not null references organizations (id) on delete cascade,
  doc_type        text not null,
  last_value      bigint not null default 0,
  primary key (organization_id, doc_type)
);

-- >>> migrations/0002_functions_triggers.sql

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

-- >>> migrations/0003_security.sql

-- =============================================================================
-- 0003_security.sql — enable Row-Level Security and encode the role matrix
-- Every row is scoped to the caller's organization; writes are gated by role.
-- Roles: owner (everything), manager, staff, accountant. See README for the
-- full matrix. Uses the helpers from 0002 (current_org_id / current_user_role).
-- =============================================================================

alter table organizations        enable row level security;
alter table profiles             enable row level security;
alter table inventory_categories enable row level security;
alter table inventory_items      enable row level security;
alter table inventory_movements  enable row level security;
alter table customers            enable row level security;
alter table suppliers            enable row level security;
alter table sales                enable row level security;
alter table sale_items           enable row level security;
alter table purchases            enable row level security;
alter table purchase_items       enable row level security;
alter table expense_categories   enable row level security;
alter table expenses             enable row level security;
alter table employees            enable row level security;
alter table activity_log         enable row level security;
alter table notifications        enable row level security;
alter table doc_counters         enable row level security; -- no policies: only definer functions touch it

-- ---- organizations ----------------------------------------------------------
create policy org_select on organizations for select to authenticated
  using (id = public.current_org_id());
create policy org_update on organizations for update to authenticated
  using (id = public.current_org_id() and public.current_user_role()::text = 'owner')
  with check (id = public.current_org_id());

-- ---- profiles ---------------------------------------------------------------
create policy profiles_select on profiles for select to authenticated
  using (organization_id = public.current_org_id());
create policy profiles_insert on profiles for insert to authenticated
  with check (organization_id = public.current_org_id() and public.current_user_role()::text = 'owner');
create policy profiles_update on profiles for update to authenticated
  using (organization_id = public.current_org_id()
         and (public.current_user_role()::text = 'owner' or id = auth.uid()))
  with check (organization_id = public.current_org_id());
create policy profiles_delete on profiles for delete to authenticated
  using (organization_id = public.current_org_id()
         and public.current_user_role()::text = 'owner' and id <> auth.uid());

-- ---- inventory_categories (staff: view only) --------------------------------
create policy invcat_select on inventory_categories for select to authenticated
  using (organization_id = public.current_org_id());
create policy invcat_insert on inventory_categories for insert to authenticated
  with check (organization_id = public.current_org_id() and public.current_user_role()::text in ('owner', 'manager'));
create policy invcat_update on inventory_categories for update to authenticated
  using (organization_id = public.current_org_id() and public.current_user_role()::text in ('owner', 'manager'));
create policy invcat_delete on inventory_categories for delete to authenticated
  using (organization_id = public.current_org_id() and public.current_user_role()::text = 'owner');

-- ---- inventory_items (staff: view only) -------------------------------------
create policy invitem_select on inventory_items for select to authenticated
  using (organization_id = public.current_org_id());
create policy invitem_insert on inventory_items for insert to authenticated
  with check (organization_id = public.current_org_id() and public.current_user_role()::text in ('owner', 'manager'));
create policy invitem_update on inventory_items for update to authenticated
  using (organization_id = public.current_org_id() and public.current_user_role()::text in ('owner', 'manager'));
create policy invitem_delete on inventory_items for delete to authenticated
  using (organization_id = public.current_org_id() and public.current_user_role()::text = 'owner');

-- ---- inventory_movements (owner/manager only; triggers write via definer) ---
create policy invmov_select on inventory_movements for select to authenticated
  using (organization_id = public.current_org_id() and public.current_user_role()::text in ('owner', 'manager'));
create policy invmov_insert on inventory_movements for insert to authenticated
  with check (organization_id = public.current_org_id() and public.current_user_role()::text in ('owner', 'manager'));
create policy invmov_delete on inventory_movements for delete to authenticated
  using (organization_id = public.current_org_id() and public.current_user_role()::text = 'owner');

-- ---- customers (staff: view only) -------------------------------------------
create policy cust_select on customers for select to authenticated
  using (organization_id = public.current_org_id() and public.current_user_role()::text in ('owner', 'manager', 'staff'));
create policy cust_insert on customers for insert to authenticated
  with check (organization_id = public.current_org_id() and public.current_user_role()::text in ('owner', 'manager'));
create policy cust_update on customers for update to authenticated
  using (organization_id = public.current_org_id() and public.current_user_role()::text in ('owner', 'manager'));
create policy cust_delete on customers for delete to authenticated
  using (organization_id = public.current_org_id() and public.current_user_role()::text = 'owner');

-- ---- suppliers (owner/manager) ----------------------------------------------
create policy supp_select on suppliers for select to authenticated
  using (organization_id = public.current_org_id() and public.current_user_role()::text in ('owner', 'manager'));
create policy supp_insert on suppliers for insert to authenticated
  with check (organization_id = public.current_org_id() and public.current_user_role()::text in ('owner', 'manager'));
create policy supp_update on suppliers for update to authenticated
  using (organization_id = public.current_org_id() and public.current_user_role()::text in ('owner', 'manager'));
create policy supp_delete on suppliers for delete to authenticated
  using (organization_id = public.current_org_id() and public.current_user_role()::text = 'owner');

-- ---- sales (staff can create/edit; accountant can view) ---------------------
create policy sales_select on sales for select to authenticated
  using (organization_id = public.current_org_id()
         and public.current_user_role()::text in ('owner', 'manager', 'staff', 'accountant'));
create policy sales_insert on sales for insert to authenticated
  with check (organization_id = public.current_org_id() and public.current_user_role()::text in ('owner', 'manager', 'staff'));
create policy sales_update on sales for update to authenticated
  using (organization_id = public.current_org_id() and public.current_user_role()::text in ('owner', 'manager', 'staff'));
create policy sales_delete on sales for delete to authenticated
  using (organization_id = public.current_org_id() and public.current_user_role()::text = 'owner');

-- ---- sale_items (gated through the parent sale's organization) ---------------
create policy saleitems_select on sale_items for select to authenticated
  using (exists (select 1 from sales s where s.id = sale_items.sale_id and s.organization_id = public.current_org_id())
         and public.current_user_role()::text in ('owner', 'manager', 'staff', 'accountant'));
create policy saleitems_insert on sale_items for insert to authenticated
  with check (exists (select 1 from sales s where s.id = sale_items.sale_id and s.organization_id = public.current_org_id())
              and public.current_user_role()::text in ('owner', 'manager', 'staff'));
create policy saleitems_update on sale_items for update to authenticated
  using (exists (select 1 from sales s where s.id = sale_items.sale_id and s.organization_id = public.current_org_id())
         and public.current_user_role()::text in ('owner', 'manager', 'staff'));
create policy saleitems_delete on sale_items for delete to authenticated
  using (exists (select 1 from sales s where s.id = sale_items.sale_id and s.organization_id = public.current_org_id())
         and public.current_user_role()::text = 'owner');

-- ---- purchases (owner/manager; accountant can view) -------------------------
create policy purch_select on purchases for select to authenticated
  using (organization_id = public.current_org_id()
         and public.current_user_role()::text in ('owner', 'manager', 'accountant'));
create policy purch_insert on purchases for insert to authenticated
  with check (organization_id = public.current_org_id() and public.current_user_role()::text in ('owner', 'manager'));
create policy purch_update on purchases for update to authenticated
  using (organization_id = public.current_org_id() and public.current_user_role()::text in ('owner', 'manager'));
create policy purch_delete on purchases for delete to authenticated
  using (organization_id = public.current_org_id() and public.current_user_role()::text = 'owner');

-- ---- purchase_items (gated through the parent purchase) ----------------------
create policy purchitems_select on purchase_items for select to authenticated
  using (exists (select 1 from purchases p where p.id = purchase_items.purchase_id and p.organization_id = public.current_org_id())
         and public.current_user_role()::text in ('owner', 'manager', 'accountant'));
create policy purchitems_insert on purchase_items for insert to authenticated
  with check (exists (select 1 from purchases p where p.id = purchase_items.purchase_id and p.organization_id = public.current_org_id())
              and public.current_user_role()::text in ('owner', 'manager'));
create policy purchitems_update on purchase_items for update to authenticated
  using (exists (select 1 from purchases p where p.id = purchase_items.purchase_id and p.organization_id = public.current_org_id())
         and public.current_user_role()::text in ('owner', 'manager'));
create policy purchitems_delete on purchase_items for delete to authenticated
  using (exists (select 1 from purchases p where p.id = purchase_items.purchase_id and p.organization_id = public.current_org_id())
         and public.current_user_role()::text = 'owner');

-- ---- expense_categories (owner/manager write, accountant view) --------------
create policy expcat_select on expense_categories for select to authenticated
  using (organization_id = public.current_org_id()
         and public.current_user_role()::text in ('owner', 'manager', 'accountant'));
create policy expcat_insert on expense_categories for insert to authenticated
  with check (organization_id = public.current_org_id() and public.current_user_role()::text in ('owner', 'manager'));
create policy expcat_update on expense_categories for update to authenticated
  using (organization_id = public.current_org_id() and public.current_user_role()::text in ('owner', 'manager'));
create policy expcat_delete on expense_categories for delete to authenticated
  using (organization_id = public.current_org_id() and public.current_user_role()::text = 'owner');

-- ---- expenses (owner/manager log; accountant view) --------------------------
create policy exp_select on expenses for select to authenticated
  using (organization_id = public.current_org_id()
         and public.current_user_role()::text in ('owner', 'manager', 'accountant'));
create policy exp_insert on expenses for insert to authenticated
  with check (organization_id = public.current_org_id() and public.current_user_role()::text in ('owner', 'manager'));
create policy exp_update on expenses for update to authenticated
  using (organization_id = public.current_org_id() and public.current_user_role()::text in ('owner', 'manager'));
create policy exp_delete on expenses for delete to authenticated
  using (organization_id = public.current_org_id() and public.current_user_role()::text = 'owner');

-- ---- employees (owner only — salaries are sensitive) ------------------------
create policy emp_select on employees for select to authenticated
  using (organization_id = public.current_org_id() and public.current_user_role()::text = 'owner');
create policy emp_insert on employees for insert to authenticated
  with check (organization_id = public.current_org_id() and public.current_user_role()::text = 'owner');
create policy emp_update on employees for update to authenticated
  using (organization_id = public.current_org_id() and public.current_user_role()::text = 'owner');
create policy emp_delete on employees for delete to authenticated
  using (organization_id = public.current_org_id() and public.current_user_role()::text = 'owner');

-- ---- activity_log (owner/manager read; INSERT-only; never update/delete) -----
create policy act_select on activity_log for select to authenticated
  using (organization_id = public.current_org_id() and public.current_user_role()::text in ('owner', 'manager'));
create policy act_insert on activity_log for insert to authenticated
  with check (organization_id = public.current_org_id());
-- Intentionally NO update or delete policy -> append-only / tamper-proof.

-- ---- notifications (each user sees only their own) --------------------------
create policy notif_select on notifications for select to authenticated
  using (recipient_id = auth.uid());
create policy notif_update on notifications for update to authenticated
  using (recipient_id = auth.uid())
  with check (recipient_id = auth.uid());
create policy notif_delete on notifications for delete to authenticated
  using (recipient_id = auth.uid());
-- INSERT happens via SECURITY DEFINER triggers only.

-- >>> migrations/0004_seed.sql

-- =============================================================================
-- 0004_seed.sql — bootstrap the single organization and starter categories
-- Safe to re-run: each insert is guarded so it only seeds once.
-- =============================================================================

insert into organizations (name, currency)
select 'Pakeru', 'GHS'
where not exists (select 1 from organizations);

-- Starter expense categories for the seeded org.
insert into expense_categories (organization_id, name)
select o.id, c.name
from organizations o
cross join (values ('Rent'), ('Transport'), ('Utilities'), ('Salaries'), ('Supplies'), ('Miscellaneous')) as c(name)
where o.name = 'Pakeru'
  and not exists (select 1 from expense_categories e where e.organization_id = o.id);

-- Starter inventory categories for the seeded org.
insert into inventory_categories (organization_id, name, description)
select o.id, c.name, c.descr
from organizations o
cross join (values
  ('Boxes', 'Packaging boxes'),
  ('Poly Bags', 'Polythene bags'),
  ('Fabrics', 'Fabric materials')
) as c(name, descr)
where o.name = 'Pakeru'
  and not exists (select 1 from inventory_categories i where i.organization_id = o.id);

-- -----------------------------------------------------------------------------
-- After your two owners have signed up, promote them to the 'owner' role, e.g.:
--
--   update profiles set role = 'owner'
--   where email in ('owner1@example.com', 'owner2@example.com');
--
-- Everyone else stays 'staff' until an owner changes their role.
-- -----------------------------------------------------------------------------

-- >>> migrations/0005_views_and_segments.sql

-- =============================================================================
-- 0005_views_and_segments.sql — customer 360 stats (derived live from sales)
-- Run this ONCE in the Supabase SQL Editor (it is incremental — do NOT re-run
-- the whole schema). Safe to re-run on its own.
--
-- customer_stats is the single source of truth for lifetime value, order count
-- and last/first purchase. Because it is derived from `sales`, the moment a sale
-- is recorded every customer page, tier and total updates automatically.
-- security_invoker = true keeps each organization's row-level isolation intact.
-- =============================================================================

alter table customers add column if not exists preferences text;

drop view if exists customer_stats;
create view customer_stats with (security_invoker = true) as
select
  c.*,
  coalesce(sum(s.total_amount), 0)::numeric as total_spent,
  count(s.id)                                as order_count,
  max(s.sale_date)                           as last_purchase,
  min(s.sale_date)                           as first_purchase
from customers c
left join sales s on s.customer_id = c.id
group by c.id;

grant select on customer_stats to authenticated;
