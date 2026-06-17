import Link from "next/link";
import { notFound } from "next/navigation";
import { PageHeader } from "@/components/ui/PageHeader";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import { formatCurrency, formatDateTime } from "@/lib/format";
import type { InventoryItem } from "@/types/database";

type CategoryRow = { id: string; name: string; description: string | null; parent_id: string | null };
type DamageRow = { inventory_item_id: string; quantity: number };
type MovementRow = {
  id: string;
  inventory_item_id: string;
  movement_type: "in" | "out" | "adjustment";
  quantity: number;
  reason: string;
  created_at: string;
};

function StatCard({ label, value, hint }: { label: string; value: string; hint?: string }) {
  return (
    <div className="rounded-xl border border-zinc-200 bg-white p-4 dark:border-zinc-800 dark:bg-zinc-900">
      <div className="text-xs text-zinc-500">{label}</div>
      <div className="mt-1 text-xl font-semibold text-zinc-900 dark:text-zinc-50">{value}</div>
      {hint ? <div className="mt-0.5 text-xs text-zinc-400">{hint}</div> : null}
    </div>
  );
}

export default async function CategoryDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { profile } = await requireRole(["owner", "manager", "staff"]);
  const canWrite = profile.role === "owner" || profile.role === "manager";
  const canSeeMovements = canWrite; // inventory_movements is owner/manager via RLS
  const { id } = await params;

  const supabase = await createClient();
  const { data: catData } = await supabase
    .from("inventory_categories")
    .select("id,name,description,parent_id")
    .eq("id", id)
    .single();
  const category = catData as CategoryRow | null;
  if (!category) notFound();

  // The parent group (if this is a type-level category) for breadcrumb + linking.
  let group: { id: string; name: string } | null = null;
  if (category.parent_id) {
    const { data } = await supabase
      .from("inventory_categories")
      .select("id,name")
      .eq("id", category.parent_id)
      .single();
    group = (data as { id: string; name: string } | null) ?? null;
  }

  const { data: itemData } = await supabase
    .from("inventory_items")
    .select("*")
    .eq("category_id", id)
    .order("name");
  const items = (itemData as InventoryItem[] | null) ?? [];
  const itemIds = items.map((i) => i.id);

  // Defective totals per item, from `damage` stock movements (owner/manager only).
  const defectiveByItem = new Map<string, number>();
  let recentMovements: MovementRow[] = [];
  if (canSeeMovements && itemIds.length) {
    const [{ data: dmg }, { data: mov }] = await Promise.all([
      supabase
        .from("inventory_movements")
        .select("inventory_item_id,quantity")
        .in("inventory_item_id", itemIds)
        .eq("reason", "damage"),
      supabase
        .from("inventory_movements")
        .select("id,inventory_item_id,movement_type,quantity,reason,created_at")
        .in("inventory_item_id", itemIds)
        .order("created_at", { ascending: false })
        .limit(30),
    ]);
    for (const d of (dmg as DamageRow[] | null) ?? []) {
      defectiveByItem.set(d.inventory_item_id, (defectiveByItem.get(d.inventory_item_id) ?? 0) + Number(d.quantity));
    }
    recentMovements = (mov as MovementRow[] | null) ?? [];
  }

  const totalAvailable = items.reduce((sum, i) => sum + Number(i.quantity_in_stock), 0);
  const totalDefective = [...defectiveByItem.values()].reduce((sum, n) => sum + n, 0);
  const stockValue = items.reduce((sum, i) => sum + Number(i.quantity_in_stock) * Number(i.cost_price), 0);
  const itemName = new Map(items.map((i) => [i.id, i.name] as const));

  return (
    <div className="mx-auto max-w-5xl">
      <div className="mb-2 text-sm text-zinc-500">
        <Link href="/inventory" className="hover:underline">
          Inventory
        </Link>
        {group ? (
          <>
            {" / "}
            <Link href={`/inventory/group/${group.id}`} className="hover:underline">
              {group.name}
            </Link>
          </>
        ) : null}
      </div>

      <PageHeader
        title={category.name}
        description={category.description ?? "Stock in this category."}
        action={canWrite ? { href: `/inventory/new?category=${category.id}`, label: "Add item" } : undefined}
      />

      <div className="grid grid-cols-2 gap-4 lg:grid-cols-4">
        <StatCard label="Items" value={String(items.length)} />
        <StatCard label="Available" value={String(totalAvailable)} />
        {canSeeMovements ? (
          <StatCard label="Defective" value={String(totalDefective)} hint="From logged damage" />
        ) : null}
        <StatCard label="Stock value (at cost)" value={formatCurrency(stockValue)} />
      </div>

      <div className="mt-4 overflow-hidden rounded-xl border border-zinc-200 bg-white dark:border-zinc-800 dark:bg-zinc-900">
        {items.length === 0 ? (
          <div className="p-8 text-center text-sm text-zinc-500">
            No items in this category yet.
            {canWrite ? " Use “Add item” to create the first one." : ""}
          </div>
        ) : (
          <table className="w-full text-sm">
            <thead className="border-b border-zinc-200 text-left text-xs uppercase tracking-wide text-zinc-500 dark:border-zinc-800">
              <tr>
                <th className="px-4 py-3 font-medium">Item</th>
                <th className="px-4 py-3 font-medium">Available</th>
                {canSeeMovements ? <th className="px-4 py-3 font-medium">Defective</th> : null}
                <th className="px-4 py-3 font-medium">Cost</th>
                <th className="px-4 py-3 font-medium">Price</th>
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
                    {canSeeMovements ? (
                      <td className="px-4 py-3 text-zinc-600 dark:text-zinc-400">
                        {defectiveByItem.get(item.id) ?? 0}
                      </td>
                    ) : null}
                    <td className="px-4 py-3 text-zinc-600 dark:text-zinc-400">{formatCurrency(item.cost_price)}</td>
                    <td className="px-4 py-3 text-zinc-600 dark:text-zinc-400">{formatCurrency(item.selling_price)}</td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        )}
      </div>

      {canSeeMovements ? (
        <div className="mt-4 rounded-xl border border-zinc-200 bg-white p-5 dark:border-zinc-800 dark:bg-zinc-900">
          <h2 className="mb-3 text-sm font-semibold text-zinc-900 dark:text-zinc-50">Recent stock activity</h2>
          {recentMovements.length === 0 ? (
            <p className="text-sm text-zinc-500">
              No movements yet. Purchases, sales and damage logs appear here as they happen.
            </p>
          ) : (
            <ol className="space-y-2">
              {recentMovements.map((m) => {
                const sign = m.movement_type === "out" ? "−" : "+";
                const color =
                  m.movement_type === "out"
                    ? "text-red-600 dark:text-red-400"
                    : "text-emerald-600 dark:text-emerald-400";
                return (
                  <li
                    key={m.id}
                    className="flex items-center justify-between gap-3 border-b border-zinc-100 pb-2 text-sm last:border-b-0 dark:border-zinc-800"
                  >
                    <div>
                      <span className={`font-medium ${color}`}>
                        {sign}
                        {m.quantity}
                      </span>
                      <span className="ml-2 text-zinc-700 dark:text-zinc-300">
                        {itemName.get(m.inventory_item_id) ?? "Item"}
                      </span>
                      <span className="ml-2 text-zinc-500">{m.reason.replace("_", " ")}</span>
                    </div>
                    <span className="text-xs text-zinc-400">{formatDateTime(m.created_at)}</span>
                  </li>
                );
              })}
            </ol>
          )}
        </div>
      ) : null}
    </div>
  );
}
