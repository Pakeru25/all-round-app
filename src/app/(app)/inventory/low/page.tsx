import Link from "next/link";
import { PageHeader } from "@/components/ui/PageHeader";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import type { InventoryItemWithCategory } from "@/types/database";
import { ItemsTable } from "../ItemsTable";

export default async function LowStockPage() {
  const { profile } = await requireRole(["owner", "manager", "staff"]);
  const canWrite = profile.role === "owner" || profile.role === "manager";

  const supabase = await createClient();
  const { data } = await supabase.from("inventory_items").select("*, inventory_categories(name)").order("name");
  const items = ((data as InventoryItemWithCategory[] | null) ?? []).filter(
    (it) => it.reorder_level > 0 && it.quantity_in_stock <= it.reorder_level,
  );

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader title="Low stock" description="Items at or below their reorder level, across all stock types." />

      <div className="mb-4">
        <Link href="/inventory" className="text-sm text-zinc-500 underline">
          ← All inventory
        </Link>
      </div>

      {items.length === 0 ? (
        <div className="rounded-xl border border-dashed border-zinc-300 bg-white p-10 text-center text-sm text-zinc-500 dark:border-zinc-700 dark:bg-zinc-900">
          Nothing is low on stock right now.
        </div>
      ) : (
        <ItemsTable items={items} canWrite={canWrite} />
      )}
    </div>
  );
}
