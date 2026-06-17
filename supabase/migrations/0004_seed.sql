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

-- The three fixed inventory categories every org starts with. Individual stock
-- items (boxes, paper bags, cards, fabrics, …) are added under one of these.
insert into inventory_categories (organization_id, name, description)
select o.id, c.name, c.descr
from organizations o
cross join (values
  ('Packaging materials', 'Boxes, paper bags, poly bags, cards, etc.'),
  ('Raw materials', 'Inputs consumed to produce finished goods.'),
  ('Finished products', 'Completed goods ready for sale.')
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
