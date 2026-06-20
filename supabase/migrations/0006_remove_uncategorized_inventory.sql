-- =============================================================================
-- 0006_remove_uncategorized_inventory.sql
-- One-time cleanup: hard-delete inventory items that have no category
-- (category_id IS NULL). Items still referenced by a sale or purchase are
-- left untouched because sale_items/purchase_items use ON DELETE RESTRICT and
-- removing them would corrupt financial records. Associated inventory_movements
-- are removed automatically via ON DELETE CASCADE. Safe to re-run (idempotent).
-- =============================================================================

delete from inventory_items i
where i.category_id is null
  and not exists (select 1 from sale_items s where s.inventory_item_id = i.id)
  and not exists (select 1 from purchase_items p where p.inventory_item_id = i.id);
