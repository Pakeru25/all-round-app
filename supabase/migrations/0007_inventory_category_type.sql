-- =============================================================================
-- 0007_inventory_category_type.sql — group inventory categories into the three
-- top-level types (Raw Material / Packaging Material / Finished Product).
--
-- The source sheet carries an "Inventory Type" per item; that value already
-- lives on inventory_items.inventory_type. We surface it on the category too,
-- since each category belongs to exactly one type. Each category's type is
-- derived from the items already tagged under it. Safe to re-run.
-- =============================================================================

do $$
begin
  if not exists (select 1 from pg_type where typname = 'inventory_type') then
    create type inventory_type as enum ('raw_material', 'packaging_material', 'finished_product');
  end if;
end$$;

-- inventory_items.inventory_type already exists in deployed databases; guard it
-- for fresh installs so the backfill below has a source column to read.
alter table inventory_items
  add column if not exists inventory_type inventory_type;

alter table inventory_categories
  add column if not exists type inventory_type not null default 'finished_product';

-- Derive each category's type from the items already tagged under it (the most
-- common value wins). Categories with no tagged items keep the default.
update inventory_categories c
   set type = sub.t
  from (
    select category_id, mode() within group (order by inventory_type) as t
      from inventory_items
     where category_id is not null
       and inventory_type is not null
     group by category_id
  ) sub
 where c.id = sub.category_id;
