import Link from "next/link";
import { notFound } from "next/navigation";
import { PageHeader } from "@/components/ui/PageHeader";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import { INVENTORY_TYPE_LABELS, isInventoryType } from "@/lib/inventory";
import type { InventoryItemWithCategory } from "@/types/database";
import { ItemsTable } from "../../../ItemsTable";

const UNCATEGORISED = "uncategorised";

export default async function CategoryItemsPage({
  params,
}: {
  params: Promise<{ type: string; categoryId: string }>;
}) {
  const { profile } = await requireRole(["owner", "manager", "staff"]);
  const canWrite = profile.role === "owner" || profile.role === "manager";
  const { type, categoryId } = await params;
  if (!isInventoryType(type)) notFound();

  const supabase = await createClient();
  let query = supabase
    .from("inventory_items")
    .select("*, inventory_categories(name)")
    .eq("inventory_type", type)
    .order("name");
  query = categoryId === UNCATEGORISED ? query.is("category_id", null) : query.eq("category_id", categoryId);
  const { data } = await query;
  const items = (data as InventoryItemWithCategory[] | null) ?? [];

  const categoryName =
    categoryId === UNCATEGORISED ? "Uncategorised" : items[0]?.inventory_categories?.name ?? "Category";

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader
        title={categoryName}
        description={INVENTORY_TYPE_LABELS[type]}
        action={canWrite ? { href: "/inventory/new", label: "Add item" } : undefined}
      />

      <div className="mb-4">
        <Link href={`/inventory/type/${type}`} className="text-sm text-zinc-500 underline">
          ← {INVENTORY_TYPE_LABELS[type]}
        </Link>
      </div>

      {items.length === 0 ? (
        <div className="rounded-xl border border-dashed border-zinc-300 bg-white p-10 text-center text-sm text-zinc-500 dark:border-zinc-700 dark:bg-zinc-900">
          No items in this category.
        </div>
      ) : (
        <ItemsTable items={items} canWrite={canWrite} showCategory={false} />
      )}
    </div>
  );
}
