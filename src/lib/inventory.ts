/**
 * Inventory type metadata + roll-up math shared across the inventory pages and
 * the sidebar. Items are organised as Type → Category → Item; categories show
 * aggregated totals (total quantity per unit, total value at cost, total value
 * at selling price). Cost/sell totals are always in GHS; quantity is grouped by
 * each item's own `unit` because a category may mix units (e.g. yards + meters).
 */
import { formatCurrency } from "@/lib/format";
import type { InventoryType } from "@/types/database";

export const INVENTORY_TYPES: { value: InventoryType; slug: string; label: string }[] = [
  { value: "raw_material", slug: "raw_material", label: "Raw materials" },
  { value: "packaging_material", slug: "packaging_material", label: "Packaging materials" },
  { value: "finished_product", slug: "finished_product", label: "Finished products" },
];

export const INVENTORY_TYPE_LABELS: Record<InventoryType, string> = {
  raw_material: "Raw materials",
  finished_product: "Finished products",
  packaging_material: "Packaging materials",
};

export function isInventoryType(value: unknown): value is InventoryType {
  return value === "raw_material" || value === "finished_product" || value === "packaging_material";
}

/** The fields the aggregation cares about — a subset of InventoryItem. */
export type AggregatableItem = {
  unit: string;
  quantity_in_stock: number;
  cost_price: number;
  selling_price: number;
};

export interface Aggregate {
  itemCount: number;
  costValue: number;
  sellValue: number;
  /** true when any item carries a selling price (otherwise selling totals are "N/A"). */
  hasSelling: boolean;
  /** total quantity keyed by unit, e.g. { yards: 70, meters: 20 } */
  qtyByUnit: Map<string, number>;
}

export function aggregate(items: AggregatableItem[]): Aggregate {
  const qtyByUnit = new Map<string, number>();
  let costValue = 0;
  let sellValue = 0;
  let hasSelling = false;

  for (const it of items) {
    const qty = Number(it.quantity_in_stock) || 0;
    const cost = Number(it.cost_price) || 0;
    const sell = Number(it.selling_price) || 0;
    costValue += qty * cost;
    sellValue += qty * sell;
    if (sell > 0) hasSelling = true;
    const unit = it.unit || "pieces";
    qtyByUnit.set(unit, (qtyByUnit.get(unit) ?? 0) + qty);
  }

  return { itemCount: items.length, costValue, sellValue, hasSelling, qtyByUnit };
}

/** Render a quantity map as "70 yards" or "50 yards + 20 meters". */
export function formatQtyByUnit(qtyByUnit: Map<string, number>): string {
  const parts = [...qtyByUnit.entries()]
    .filter(([, qty]) => qty !== 0)
    .map(([unit, qty]) => `${formatQty(qty)} ${unit}`);
  return parts.length > 0 ? parts.join(" + ") : "0";
}

/** Total value at selling price, or "N/A" when nothing is priced for sale. */
export function formatSell(agg: Aggregate): string {
  return agg.hasSelling ? formatCurrency(agg.sellValue) : "N/A";
}

/** Trim trailing zeros so 70.00 → "70" but 12.5 stays "12.5". */
function formatQty(n: number): string {
  return Number.isInteger(n) ? String(n) : String(Number(n.toFixed(2)));
}
