import Link from "next/link";
import { notFound } from "next/navigation";
import { PageHeader } from "@/components/ui/PageHeader";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import { formatCurrency } from "@/lib/format";
import { INVENTORY_TYPE_LABELS, aggregate, formatQtyByUnit, formatSell, isInventoryType } from "@/lib/inventory";

const UNCATEGORISED = "uncategorised";

type Row = {
  category_id: string | null;
  unit: string;
  quantity_in_stock: number;
  cost_price: number;
  selling_price: number;
  inventory_categories: { name: string } | null;
};

export default async function InventoryTypePage({ params }: { params: Promise<{ type: string }> }) {
  const { profile } = await requireRole(["owner", "manager", "staff"]);
  const canWrite = profile.role === "owner" || profile.role === "manager";
  const { type } = await params;
  if (!isInventoryType(type)) notFound();

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("inventory_items")
    .select("category_id,unit,quantity_in_stock,cost_price,selling_price,inventory_categories(name)")
    .eq("inventory_type", type)
    .order("name");
  const items = (data as Row[] | null) ?? [];

  // Group items by category (null → an "Uncategorised" bucket).
  const groups = new Map<string, { id: string; name: string; rows: Row[] }>();
  for (const it of items) {
    const key = it.category_id ?? UNCATEGORISED;
    let group = groups.get(key);
    if (!group) {
      group = { id: key, name: it.inventory_categories?.name ?? "Uncategorised", rows: [] };
      groups.set(key, group);
    }
    group.rows.push(it);
  }
  const categories = [...groups.values()].sort((a, b) => a.name.localeCompare(b.name));

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader
        title={INVENTORY_TYPE_LABELS[type]}
        description="Categories in this stock type. Click one to see its items."
        action={canWrite ? { href: "/inventory/new", label: "Add item" } : undefined}
      />

      <div className="mb-4">
        <Link href="/inventory" className="text-sm text-zinc-500 underline">
          ← All inventory
        </Link>
      </div>

      {error ? (
        <div className="mb-4 rounded-lg border border-red-200 bg-red-50 p-4 text-sm text-red-700 dark:border-red-900 dark:bg-red-950 dark:text-red-300">
          <strong>Database error:</strong> {error.message}
          {error.message.includes("inventory_type") ? (
            <p className="mt-1">
              The <code className="font-mono">inventory_type</code> column is missing. Run{" "}
              <code className="font-mono">0006_inventory_type.sql</code> then{" "}
              <code className="font-mono">NOTIFY pgrst, &apos;reload schema&apos;;</code> in your Supabase SQL editor.
            </p>
          ) : null}
        </div>
      ) : null}

      {!error && categories.length === 0 ? (
        <div className="rounded-xl border border-dashed border-zinc-300 bg-white p-10 text-center text-sm text-zinc-500 dark:border-zinc-700 dark:bg-zinc-900">
          No items in this stock type yet.{" "}
          {canWrite ? (
            <>
              <Link href="/inventory/new" className="underline">
                Add one
              </Link>{" "}
              or{" "}
              <Link href="/inventory/import" className="underline">
                import from CSV
              </Link>
              .
            </>
          ) : null}
        </div>
      ) : null}

      {!error && categories.length > 0 ? (
        <div className="overflow-hidden rounded-xl border border-zinc-200 bg-white dark:border-zinc-800 dark:bg-zinc-900">
          <table className="w-full text-sm">
            <thead className="border-b border-zinc-200 text-left text-xs uppercase tracking-wide text-zinc-500 dark:border-zinc-800">
              <tr>
                <th className="px-4 py-3 font-medium">Category</th>
                <th className="px-4 py-3 font-medium">In stock</th>
                <th className="px-4 py-3 font-medium">Value at cost</th>
                <th className="px-4 py-3 font-medium">Value at sell</th>
                <th className="px-4 py-3 font-medium">Items</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-zinc-100 dark:divide-zinc-800">
              {categories.map((cat) => {
                const agg = aggregate(cat.rows);
                return (
                  <tr key={cat.id} className="hover:bg-zinc-50 dark:hover:bg-zinc-800/50">
                    <td className="px-4 py-3 font-medium">
                      <Link
                        href={`/inventory/type/${type}/${cat.id}`}
                        className="text-zinc-900 underline-offset-2 hover:underline dark:text-zinc-50"
                      >
                        {cat.name}
                      </Link>
                    </td>
                    <td className="px-4 py-3 text-zinc-700 dark:text-zinc-300">{formatQtyByUnit(agg.qtyByUnit)}</td>
                    <td className="px-4 py-3 text-zinc-600 dark:text-zinc-400">{formatCurrency(agg.costValue)}</td>
                    <td className="px-4 py-3 text-zinc-600 dark:text-zinc-400">{formatSell(agg)}</td>
                    <td className="px-4 py-3 text-zinc-500">{agg.itemCount}</td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      ) : null}
    </div>
  );
}
