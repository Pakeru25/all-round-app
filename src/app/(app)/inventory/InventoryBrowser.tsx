"use client";

import { useMemo, useState, type ReactNode } from "react";
import Link from "next/link";
import { ChevronDown } from "lucide-react";
import { formatCurrency } from "@/lib/format";
import { INVENTORY_TYPE_LABELS, INVENTORY_TYPE_ORDER } from "@/lib/inventory";
import type { InventoryItem, InventoryType } from "@/types/database";

type Category = { id: string; name: string; type: InventoryType };

function isLow(item: InventoryItem): boolean {
  return item.reorder_level > 0 && item.quantity_in_stock <= item.reorder_level;
}

export function InventoryBrowser({
  categories,
  items,
  canWrite,
}: {
  categories: Category[];
  items: InventoryItem[];
  canWrite: boolean;
}) {
  // Group items by category once.
  const itemsByCategory = useMemo(() => {
    const map = new Map<string, InventoryItem[]>();
    for (const item of items) {
      if (!item.category_id) continue;
      const bucket = map.get(item.category_id);
      if (bucket) bucket.push(item);
      else map.set(item.category_id, [item]);
    }
    return map;
  }, [items]);

  const categoriesByType = useMemo(() => {
    const map = new Map<InventoryType, Category[]>();
    for (const t of INVENTORY_TYPE_ORDER) map.set(t, []);
    for (const cat of categories) map.get(cat.type)?.push(cat);
    return map;
  }, [categories]);

  // Item count per type (across that type's categories).
  const countByType = useMemo(() => {
    const map = new Map<InventoryType, number>();
    for (const t of INVENTORY_TYPE_ORDER) {
      const cats = categoriesByType.get(t) ?? [];
      map.set(t, cats.reduce((sum, c) => sum + (itemsByCategory.get(c.id)?.length ?? 0), 0));
    }
    return map;
  }, [categoriesByType, itemsByCategory]);

  const uncategorized = useMemo(() => items.filter((it) => !it.category_id), [items]);

  // Default to the first group that actually has categories.
  const defaultType =
    INVENTORY_TYPE_ORDER.find((t) => (categoriesByType.get(t)?.length ?? 0) > 0) ??
    INVENTORY_TYPE_ORDER[0];
  const [activeType, setActiveType] = useState<InventoryType>(defaultType);
  const [expandedId, setExpandedId] = useState<string | null>(null);

  const activeCategories = categoriesByType.get(activeType) ?? [];

  return (
    <div>
      {/* Tabs: the three inventory groups */}
      <div role="tablist" className="mb-4 flex flex-wrap gap-2">
        {INVENTORY_TYPE_ORDER.map((type) => {
          const active = type === activeType;
          return (
            <button
              key={type}
              role="tab"
              aria-selected={active}
              onClick={() => {
                setActiveType(type);
                setExpandedId(null);
              }}
              className={[
                "flex items-center gap-2 rounded-lg px-4 py-2 text-sm font-medium transition",
                active
                  ? "bg-zinc-900 text-white dark:bg-zinc-50 dark:text-zinc-900"
                  : "bg-white text-zinc-600 ring-1 ring-inset ring-zinc-200 hover:bg-zinc-50 dark:bg-zinc-900 dark:text-zinc-400 dark:ring-zinc-800 dark:hover:bg-zinc-800",
              ].join(" ")}
            >
              <span>{INVENTORY_TYPE_LABELS[type]}</span>
              <span
                className={[
                  "rounded-full px-1.5 text-xs",
                  active ? "bg-white/20 text-white dark:bg-zinc-900/10 dark:text-zinc-900" : "text-zinc-400",
                ].join(" ")}
              >
                {countByType.get(type) ?? 0}
              </span>
            </button>
          );
        })}
      </div>

      {/* Categories for the active group */}
      {activeCategories.length === 0 ? (
        <EmptyState>
          No categories in {INVENTORY_TYPE_LABELS[activeType]} yet.
          {canWrite ? " Add one from “Manage categories”." : ""}
        </EmptyState>
      ) : (
        <ul className="space-y-2">
          {activeCategories.map((cat) => {
            const catItems = itemsByCategory.get(cat.id) ?? [];
            const lowCount = catItems.filter(isLow).length;
            const expanded = expandedId === cat.id;
            return (
              <li
                key={cat.id}
                className="overflow-hidden rounded-xl border border-zinc-200 bg-white dark:border-zinc-800 dark:bg-zinc-900"
              >
                <button
                  onClick={() => setExpandedId(expanded ? null : cat.id)}
                  aria-expanded={expanded}
                  className="flex w-full items-center gap-3 px-4 py-3 text-left hover:bg-zinc-50 dark:hover:bg-zinc-800/50"
                >
                  <ChevronDown
                    className={`h-4 w-4 shrink-0 text-zinc-400 transition-transform ${expanded ? "rotate-180" : ""}`}
                  />
                  {lowCount > 0 ? <span className="h-1.5 w-1.5 shrink-0 rounded-full bg-red-500" /> : null}
                  <span className="flex-1 font-medium text-zinc-900 dark:text-zinc-50">{cat.name}</span>
                  <span className="text-xs text-zinc-400">
                    {catItems.length} {catItems.length === 1 ? "product" : "products"}
                  </span>
                </button>
                {expanded ? <ItemTable items={catItems} canWrite={canWrite} /> : null}
              </li>
            );
          })}
        </ul>
      )}

      {/* Items with no category — surfaced so nothing is hidden. */}
      {uncategorized.length > 0 ? (
        <div className="mt-6">
          <h2 className="mb-2 text-xs font-medium uppercase tracking-wide text-zinc-500">Uncategorized</h2>
          <div className="overflow-hidden rounded-xl border border-zinc-200 bg-white dark:border-zinc-800 dark:bg-zinc-900">
            <ItemTable items={uncategorized} canWrite={canWrite} />
          </div>
        </div>
      ) : null}
    </div>
  );
}

function EmptyState({ children }: { children: ReactNode }) {
  return (
    <div className="rounded-xl border border-dashed border-zinc-300 bg-white p-10 text-center text-sm text-zinc-500 dark:border-zinc-700 dark:bg-zinc-900">
      {children}
    </div>
  );
}

function ItemTable({ items, canWrite }: { items: InventoryItem[]; canWrite: boolean }) {
  if (items.length === 0) {
    return <div className="px-4 py-6 text-center text-sm text-zinc-500">No products in this category.</div>;
  }
  return (
    <div className="border-t border-zinc-200 dark:border-zinc-800">
      <table className="w-full text-sm">
        <thead className="border-b border-zinc-200 text-left text-xs uppercase tracking-wide text-zinc-500 dark:border-zinc-800">
          <tr>
            <th className="px-4 py-3 font-medium">Product</th>
            <th className="px-4 py-3 font-medium">In stock</th>
            <th className="px-4 py-3 font-medium">Cost</th>
            <th className="px-4 py-3 font-medium">Price</th>
            {canWrite ? <th className="px-4 py-3" /> : null}
          </tr>
        </thead>
        <tbody className="divide-y divide-zinc-100 dark:divide-zinc-800">
          {items.map((item) => {
            const low = isLow(item);
            return (
              <tr key={item.id} className="hover:bg-zinc-50 dark:hover:bg-zinc-800/50">
                <td className="px-4 py-3 font-medium">
                  <Link
                    href={`/inventory/${item.id}`}
                    className="text-zinc-900 underline-offset-2 hover:underline dark:text-zinc-50"
                  >
                    {item.name}
                  </Link>
                </td>
                <td className="px-4 py-3">
                  <span
                    className={
                      low
                        ? "inline-flex items-center rounded-full bg-red-100 px-2 py-0.5 text-xs font-medium text-red-700 dark:bg-red-950 dark:text-red-300"
                        : "text-zinc-700 dark:text-zinc-300"
                    }
                  >
                    {item.quantity_in_stock} {item.unit}
                    {low ? " · low" : ""}
                  </span>
                </td>
                <td className="px-4 py-3 text-zinc-600 dark:text-zinc-400">{formatCurrency(item.cost_price)}</td>
                <td className="px-4 py-3 text-zinc-600 dark:text-zinc-400">{formatCurrency(item.selling_price)}</td>
                {canWrite ? (
                  <td className="px-4 py-3 text-right">
                    <Link
                      href={`/inventory/${item.id}/edit`}
                      className="text-sm font-medium text-zinc-700 underline hover:text-zinc-900 dark:text-zinc-300"
                    >
                      Edit
                    </Link>
                  </td>
                ) : null}
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
