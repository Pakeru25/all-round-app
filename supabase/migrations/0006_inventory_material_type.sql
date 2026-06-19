-- Add material_type to inventory_categories so categories can be classified
-- as Raw Materials, Packaging Material, or Finished Products.

create type material_type as enum ('raw_material', 'packaging_material', 'finished_product');

alter table inventory_categories
  add column material_type material_type;
