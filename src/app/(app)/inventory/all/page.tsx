import Link from "next/link";
import { PageHeader } from "@/components/ui/PageHeader";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import type { InventoryItemWithCategory } from "@/types/database";
import { ItemsTable } from "../ItemsTable";

export default async function AllItemsPage() {
  const { profile } = await requireRole(["owner", "manager", "staff"]);
  const canWrite = profile.role === "owner" || profile.role === "manager";

  const supabase = await createClient();
  const { data } = await supabase.from("inventory_items").select("*, inventory_categories(name)").order("name");
  const items = (data as InventoryItemWithCategory[] | null) ?? [];

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader
        title="All items"
        description="Every item you stock, across all types."
        action={canWrite ? { href: "/inventory/new", label: "Add item" } : undefined}
      />

      <div className="mb-4">
        <Link href="/inventory" className="text-sm text-zinc-500 underline">
          ← Browse by type
        </Link>
      </div>

      {items.length === 0 ? (
        <div className="rounded-xl border border-dashed border-zinc-300 bg-white p-10 text-center text-sm text-zinc-500 dark:border-zinc-700 dark:bg-zinc-900">
          No items yet.
        </div>
      ) : (
        <ItemsTable items={items} canWrite={canWrite} />
      )}
    </div>
  );
}
