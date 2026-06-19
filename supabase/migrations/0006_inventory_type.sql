-- =============================================================================
-- 0004_inventory_type.sql — classify every inventory item by its stock type
-- Inventory is now organised as Type → Category → Item. The type lives on the
-- item (a category can surface under more than one type). RLS already covers
-- inventory_items, so no policy changes are needed.
-- =============================================================================

create type inventory_type as enum ('raw_material', 'finished_product', 'packaging_material');

alter table inventory_items
  add column inventory_type inventory_type not null default 'finished_product';

create index inventory_items_type_idx on inventory_items (inventory_type);
