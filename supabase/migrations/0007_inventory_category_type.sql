-- =============================================================================
-- 0007_inventory_category_type.sql — group inventory categories into the three
-- top-level types (Raw Material / Packaging / Finished Product).
--
-- The source sheet (scripts/migrate/data/inventory.csv) carries an "Inventory
-- Type" per row, nested above its Category. We store that type on the category
-- itself, since each category belongs to exactly one type. Safe to re-run.
-- =============================================================================

do $$
begin
  if not exists (select 1 from pg_type where typname = 'inventory_type') then
    create type inventory_type as enum ('raw_material', 'packaging', 'finished_product');
  end if;
end$$;

alter table inventory_categories
  add column if not exists type inventory_type not null default 'finished_product';

-- Backfill the categories that already exist from the historical import. Anything
-- not listed here keeps the 'finished_product' default.
update inventory_categories
   set type = 'packaging'
 where type = 'finished_product'
   and name in ('Box', 'Card', 'Envelope', 'Paper bag', 'Poly Mailer bag', 'Tag', 'Wrapper', 'Boxes', 'Poly Bags');

update inventory_categories
   set type = 'raw_material'
 where type = 'finished_product'
   and name in ('Plain T-shirt', 'Fabrics');
