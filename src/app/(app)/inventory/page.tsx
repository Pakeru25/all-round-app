import Link from "next/link";
import { PageHeader } from "@/components/ui/PageHeader";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import { formatCurrency } from "@/lib/format";
import type { InventoryItemWithCategory } from "@/types/database";

export default async function InventoryPage({
  searchParams,
}: {
  searchParams: Promise<{ category?: string; filter?: string }>;
}) {
  const { profile } = await requireRole(["owner", "manager", "staff"]);
  const canWrite = profile.role === "owner" || profile.role === "manager";
  const { category, filter } = await searchParams;
  const lowOnly = filter === "low";

  const supabase = await createClient();
  let query = supabase.from("inventory_items").select("*, inventory_categories(name)").order("name");
  if (category) query = query.eq("category_id", category);
  const { data } = await query;
  let items = (data as InventoryItemWithCategory[] | null) ?? [];
  if (lowOnly) {
    items = items.filter((it) => it.reorder_level > 0 && it.quantity_in_stock <= it.reorder_level);
  }

  let activeLabel: string | null = null;
  if (lowOnly) {
    activeLabel = "Low stock";
  } else if (category) {
    const { data: cat } = await supabase.from("inventory_categories").select("name").eq("id", category).single();
    activeLabel = (cat as { name: string } | null)?.name ?? "Category";
  }

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader
        title="Inventory"
        description={activeLabel ? `Showing: ${activeLabel}` : "Everything you stock and sell."}
        action={canWrite ? { href: "/inventory/new", label: "Add item" } : undefined}
      />

      <div className="mb-4 flex items-center gap-4">
        {canWrite ? (
          <Link href="/inventory/categories" className="text-sm font-medium text-zinc-600 underline dark:text-zinc-400">
            Manage categories
          </Link>
        ) : null}
        {activeLabel ? (
          <Link href="/inventory" className="text-sm text-zinc-500 underline">
            Clear filter
          </Link>
        ) : null}
      </div>

      {items.length === 0 ? (
        <div className="rounded-xl border border-dashed border-zinc-300 bg-white p-10 text-center text-sm text-zinc-500 dark:border-zinc-700 dark:bg-zinc-900">
          {activeLabel ? "No items match this filter." : "No items yet."}
          {canWrite && !activeLabel ? " Use “Add item” to create your first one." : ""}
        </div>
      ) : (
        <div className="overflow-hidden rounded-xl border border-zinc-200 bg-white dark:border-zinc-800 dark:bg-zinc-900">
          <table className="w-full text-sm">
            <thead className="border-b border-zinc-200 text-left text-xs uppercase tracking-wide text-zinc-500 dark:border-zinc-800">
              <tr>
                <th className="px-4 py-3 font-medium">Item</th>
                <th className="px-4 py-3 font-medium">Category</th>
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
                      <Link href={`/inventory/${item.id}`} className="text-zinc-900 underline-offset-2 hover:underline dark:text-zinc-50">
                        {item.name}
                      </Link>
                    </td>
                    <td className="px-4 py-3 text-zinc-600 dark:text-zinc-400">
                      {item.inventory_categories?.name ?? "—"}
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
      )}
    </div>
  );
}
