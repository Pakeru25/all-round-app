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
