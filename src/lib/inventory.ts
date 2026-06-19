/**
 * Shared inventory grouping metadata. Every inventory category belongs to one of
 * three top-level types; these helpers give the canonical display order and
 * labels used by the Inventory browser and the category form.
 */
import type { InventoryType } from "@/types/database";

/** Fixed left-to-right order the three groups are shown in. */
export const INVENTORY_TYPE_ORDER: InventoryType[] = [
  "raw_material",
  "packaging_material",
  "finished_product",
];

/** Human-facing labels for each group. */
export const INVENTORY_TYPE_LABELS: Record<InventoryType, string> = {
  raw_material: "Raw Materials",
  packaging_material: "Packaging Material",
  finished_product: "Finished Products",
};
