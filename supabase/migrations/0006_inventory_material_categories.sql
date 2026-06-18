-- =============================================================================
-- 0006_inventory_material_categories.sql
-- Restructure inventory categories to the three fixed material types:
--   1. Packaging materials   2. Raw materials   3. Finished products
-- Individual stock (boxes, paper bags, cards, fabrics, …) are now plain
-- inventory_items added under one of these three categories.
-- Safe to re-run.
-- =============================================================================

-- Drop the old starter categories. inventory_items.category_id is
-- "on delete set null", so any items that referenced them are simply unlinked
-- (re-assign them to one of the three types via the item editor).
delete from inventory_categories
where name in ('Boxes', 'Poly Bags', 'Fabrics');

-- Collapse any duplicate categories (same name within an org, case-insensitive),
-- keeping the oldest row. Items on the duplicates are repointed to the kept row
-- first so none lose their type, then the extra rows are removed.
update inventory_items i
set category_id = r.keep_id
from (
  select id,
         row_number() over (partition by organization_id, lower(trim(name)) order by created_at) as rn,
         first_value(id) over (partition by organization_id, lower(trim(name)) order by created_at) as keep_id
  from inventory_categories
) r
where i.category_id = r.id and r.rn > 1;

delete from inventory_categories c
using (
  select id,
         row_number() over (partition by organization_id, lower(trim(name)) order by created_at) as rn
  from inventory_categories
) r
where c.id = r.id and r.rn > 1;

-- Ensure every organization has exactly the three material-type categories.
-- The existence check is case-insensitive so a differently-cased row (e.g.
-- "Finished Products") is treated as already present and not duplicated.
insert into inventory_categories (organization_id, name, description)
select o.id, c.name, c.descr
from organizations o
cross join (values
  ('Packaging materials', 'Boxes, paper bags, poly bags, cards, etc.'),
  ('Raw materials', 'Inputs consumed to produce finished goods.'),
  ('Finished products', 'Completed goods ready for sale.')
) as c(name, descr)
where not exists (
  select 1 from inventory_categories i
  where i.organization_id = o.id
    and lower(trim(i.name)) = lower(trim(c.name))
);
