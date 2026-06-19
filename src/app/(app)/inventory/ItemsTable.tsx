import Link from "next/link";
import { formatCurrency } from "@/lib/format";
import type { InventoryItemWithCategory } from "@/types/database";

/**
 * Shared item table used by the category drill-down and the low-stock list.
 * Keeps the low-stock badge logic in one place.
 */
export function ItemsTable({
  items,
  canWrite,
  showCategory = true,
}: {
  items: InventoryItemWithCategory[];
  canWrite: boolean;
  showCategory?: boolean;
}) {
  return (
    <div className="overflow-hidden rounded-xl border border-zinc-200 bg-white dark:border-zinc-800 dark:bg-zinc-900">
      <table className="w-full text-sm">
        <thead className="border-b border-zinc-200 text-left text-xs uppercase tracking-wide text-zinc-500 dark:border-zinc-800">
          <tr>
            <th className="px-4 py-3 font-medium">Item</th>
            {showCategory ? <th className="px-4 py-3 font-medium">Category</th> : null}
            <th className="px-4 py-3 font-medium">In stock</th>
            <th className="px-4 py-3 font-medium">Cost</th>
            <th className="px-4 py-3 font-medium">Price</th>
            {canWrite ? <th className="px-4 py-3" /> : null}
          </tr>
        </thead>
        <tbody className="divide-y divide-zinc-100 dark:divide-zinc-800">
          {items.map((item) => {
            const low = item.reorder_level > 0 && item.quantity_in_stock <= item.reorder_level;
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
                {showCategory ? (
                  <td className="px-4 py-3 text-zinc-600 dark:text-zinc-400">
                    {item.inventory_categories?.name ?? "—"}
                  </td>
                ) : null}
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
                <td className="px-4 py-3 text-zinc-600 dark:text-zinc-400">
                  {item.selling_price > 0 ? formatCurrency(item.selling_price) : "N/A"}
                </td>
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
