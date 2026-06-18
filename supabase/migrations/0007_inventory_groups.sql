-- =============================================================================
-- 0007_inventory_groups.sql — two-level inventory categories (groups → types)
--
-- Adds a self-referential parent to inventory_categories so stock is organized
-- as: GROUP (e.g. "Packaging materials") → CATEGORY/type (e.g. "Boxes") → items.
-- A category is a GROUP when parent_id is null, and a type when it has a parent.
-- Items continue to attach to a type-level category via inventory_items.category_id.
--
-- Incremental — run once in the Supabase SQL Editor. Safe to re-run.
-- =============================================================================

alter table inventory_categories
  add column if not exists parent_id uuid references inventory_categories (id) on delete set null;
create index if not exists inventory_categories_parent_idx on inventory_categories (parent_id);

-- Seed the three top-level groups for every organization that lacks them.
insert into inventory_categories (organization_id, name, description, parent_id)
select o.id, g.name, g.descr, null
from organizations o
cross join (values
  ('Packaging materials', 'Boxes, bags, cards and other packaging'),
  ('Raw materials',       'Inputs used to produce finished goods'),
  ('Finished Products',   'Completed goods ready for sale')
) as g(name, descr)
where not exists (
  select 1 from inventory_categories c
  where c.organization_id = o.id and c.parent_id is null and c.name = g.name
);

-- Re-parent the original starter categories under the right group (best-effort).
update inventory_categories child
set parent_id = grp.id
from inventory_categories grp
where grp.organization_id = child.organization_id
  and grp.parent_id is null
  and child.parent_id is null
  and child.name not in ('Packaging materials', 'Raw materials', 'Finished Products')
  and (
    (grp.name = 'Packaging materials' and child.name in ('Boxes', 'Poly Bags')) or
    (grp.name = 'Raw materials'       and child.name in ('Fabrics'))
  );
