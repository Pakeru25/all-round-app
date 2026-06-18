import Link from "next/link";
import { PageHeader } from "@/components/ui/PageHeader";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import { formatCurrency } from "@/lib/format";
import { INVENTORY_TYPES, aggregate, formatQtyByUnit, formatSell } from "@/lib/inventory";
import type { InventoryType } from "@/types/database";

type Row = {
  inventory_type: InventoryType;
  unit: string;
  quantity_in_stock: number;
  cost_price: number;
  selling_price: number;
};

export default async function InventoryPage() {
  const { profile } = await requireRole(["owner", "manager", "staff"]);
  const canWrite = profile.role === "owner" || profile.role === "manager";

  const supabase = await createClient();
  const { data } = await supabase
    .from("inventory_items")
    .select("inventory_type,unit,quantity_in_stock,cost_price,selling_price");
  const items = (data as Row[] | null) ?? [];

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader
        title="Inventory"
        description="Browse by stock type, then drill into categories and items."
        action={canWrite ? { href: "/inventory/new", label: "Add item" } : undefined}
      />

      {canWrite ? (
        <div className="mb-4">
          <Link href="/inventory/categories" className="text-sm font-medium text-zinc-600 underline dark:text-zinc-400">
            Manage categories
          </Link>
        </div>
      ) : null}

      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {INVENTORY_TYPES.map((type) => {
          const agg = aggregate(items.filter((it) => it.inventory_type === type.value));
          return (
            <Link
              key={type.value}
              href={`/inventory/type/${type.slug}`}
              className="group rounded-xl border border-zinc-200 bg-white p-5 transition hover:border-zinc-400 hover:shadow-sm dark:border-zinc-800 dark:bg-zinc-900 dark:hover:border-zinc-600"
            >
              <div className="flex items-center justify-between">
                <h2 className="text-base font-semibold text-zinc-900 dark:text-zinc-50">{type.label}</h2>
                <span className="text-xs text-zinc-400">{agg.itemCount} items</span>
              </div>
              <dl className="mt-4 space-y-2 text-sm">
                <Stat label="In stock" value={formatQtyByUnit(agg.qtyByUnit)} />
                <Stat label="Value at cost" value={formatCurrency(agg.costValue)} />
                <Stat label="Value at sell" value={formatSell(agg)} />
              </dl>
            </Link>
          );
        })}
      </div>
    </div>
  );
}

function Stat({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex items-baseline justify-between gap-3">
      <dt className="text-zinc-500">{label}</dt>
      <dd className="font-medium text-zinc-900 dark:text-zinc-50">{value}</dd>
    </div>
  );
}
