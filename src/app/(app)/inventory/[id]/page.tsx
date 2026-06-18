import { notFound } from "next/navigation";
import { PageHeader } from "@/components/ui/PageHeader";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import { formatCurrency, formatDate, formatDateTime } from "@/lib/format";
import type { InventoryItemWithCategory } from "@/types/database";

type Movement = {
  id: string;
  movement_type: "in" | "out" | "adjustment";
  quantity: number;
  reason: string;
  notes: string | null;
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

export default async function ProductDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { profile } = await requireRole(["owner", "manager", "staff"]);
  const canWrite = profile.role === "owner" || profile.role === "manager";
  const { id } = await params;

  const supabase = await createClient();
  const { data: itemData } = await supabase
    .from("inventory_items")
    .select("*, inventory_categories(name)")
    .eq("id", id)
    .single();
  const item = itemData as InventoryItemWithCategory | null;
  if (!item) notFound();

  const { data: movData } = await supabase
    .from("inventory_movements")
    .select("id,movement_type,quantity,reason,notes,created_at")
    .eq("inventory_item_id", id)
    .order("created_at", { ascending: false });
  const allMovements = (movData as Movement[] | null) ?? [];
  const movements = allMovements.slice(0, 50);

  const low = item.reorder_level > 0 && item.quantity_in_stock <= item.reorder_level;
  const stockValue = item.quantity_in_stock * item.cost_price;
  const margin = item.selling_price - item.cost_price;

  // Defective units come from "damage" stock movements; purchase figures come
  // from "purchase" movements (logged automatically when a purchase is recorded).
  const defectiveUnits = allMovements
    .filter((m) => m.reason === "damage")
    .reduce((sum, m) => sum + Number(m.quantity), 0);
  const purchaseMovements = allMovements.filter((m) => m.reason === "purchase");
  const totalPurchased = purchaseMovements.reduce((sum, m) => sum + Number(m.quantity), 0);
  // allMovements is sorted newest-first, so the first/last purchase entries are
  // the most/least recent purchase dates respectively.
  const lastPurchasedAt = purchaseMovements[0]?.created_at ?? null;
  const firstPurchasedAt = purchaseMovements[purchaseMovements.length - 1]?.created_at ?? null;

  return (
    <div className="mx-auto max-w-5xl">
      <PageHeader
        title={item.name}
        description={item.inventory_categories?.name ?? "Uncategorised"}
        action={canWrite ? { href: `/inventory/${item.id}/edit`, label: "Edit" } : undefined}
      />

      <div className="grid grid-cols-2 gap-4 lg:grid-cols-3">
        <StatCard
          label="Available"
          value={`${item.quantity_in_stock} ${item.unit}`}
          hint={low ? `⚠ at/below reorder level (${item.reorder_level})` : `Reorder at ${item.reorder_level}`}
        />
        <StatCard
          label="Defective"
          value={`${defectiveUnits} ${item.unit}`}
          hint={defectiveUnits > 0 ? "Total recorded as damaged" : "None recorded"}
        />
        <StatCard
          label="Last purchased"
          value={lastPurchasedAt ? formatDate(lastPurchasedAt) : "—"}
          hint={totalPurchased > 0 ? `${totalPurchased} ${item.unit} purchased in total` : "No purchases recorded"}
        />
        <StatCard label="Stock value (at cost)" value={formatCurrency(stockValue)} />
        <StatCard label="Selling price" value={formatCurrency(item.selling_price)} />
        <StatCard label="Margin / unit" value={formatCurrency(margin)} />
      </div>

      <div className="mt-4 grid grid-cols-1 gap-4 md:grid-cols-2">
        <div className="rounded-xl border border-zinc-200 bg-white p-5 dark:border-zinc-800 dark:bg-zinc-900">
          <h2 className="mb-3 text-sm font-semibold text-zinc-900 dark:text-zinc-50">Details</h2>
          <dl className="space-y-2 text-sm">
            <Row label="SKU" value={item.sku ?? "—"} />
            <Row label="Unit" value={item.unit} />
            <Row label="Cost price" value={formatCurrency(item.cost_price)} />
            <Row label="Reorder level" value={String(item.reorder_level)} />
            <Row label="Status" value={item.is_active ? "Active" : "Inactive"} />
            <Row label="Total purchased" value={`${totalPurchased} ${item.unit}`} />
            <Row label="First purchased" value={firstPurchasedAt ? formatDate(firstPurchasedAt) : "—"} />
            <Row label="Added on" value={formatDate(item.created_at)} />
          </dl>
          {item.description ? (
            <p className="mt-3 border-t border-zinc-100 pt-3 text-sm text-zinc-600 dark:border-zinc-800 dark:text-zinc-400">
              {item.description}
            </p>
          ) : null}
        </div>

        <div className="rounded-xl border border-zinc-200 bg-white p-5 dark:border-zinc-800 dark:bg-zinc-900">
          <h2 className="mb-3 text-sm font-semibold text-zinc-900 dark:text-zinc-50">Stock movement history</h2>
          {movements.length === 0 ? (
            <p className="text-sm text-zinc-500">
              No movements yet. Recording sales and purchases will log every stock change here automatically.
            </p>
          ) : (
            <ol className="space-y-2">
              {movements.map((m) => {
                const sign = m.movement_type === "out" ? "−" : "+";
                const color =
                  m.movement_type === "out"
                    ? "text-red-600 dark:text-red-400"
                    : "text-emerald-600 dark:text-emerald-400";
                return (
                  <li key={m.id} className="flex items-center justify-between gap-3 border-b border-zinc-100 pb-2 text-sm last:border-b-0 dark:border-zinc-800">
                    <div>
                      <span className={`font-medium ${color}`}>
                        {sign}
                        {m.quantity} {item.unit}
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
      </div>
    </div>
  );
}

function Row({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex justify-between gap-4">
      <dt className="text-zinc-500">{label}</dt>
      <dd className="text-zinc-900 dark:text-zinc-50">{value}</dd>
    </div>
  );
}
