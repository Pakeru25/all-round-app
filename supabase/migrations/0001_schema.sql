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
  created_at      timestamptz not null default now()
);
create index inventory_categories_org_idx on inventory_categories (organization_id);

create table inventory_items (
  id                uuid primary key default gen_random_uuid(),
  organization_id   uuid not null references organizations (id) on delete cascade,
  category_id       uuid references inventory_categories (id) on delete set null,
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
