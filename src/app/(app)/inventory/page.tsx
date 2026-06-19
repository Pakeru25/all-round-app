import Link from "next/link";
import { PageHeader } from "@/components/ui/PageHeader";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import type { InventoryCategory, InventoryItem } from "@/types/database";
import { InventoryBrowser } from "./InventoryBrowser";

export default async function InventoryPage() {
  const { profile } = await requireRole(["owner", "manager", "staff"]);
  const canWrite = profile.role === "owner" || profile.role === "manager";

  const supabase = await createClient();
  const [catsRes, itemsRes] = await Promise.all([
    supabase.from("inventory_categories").select("id,name,type").order("name"),
    supabase.from("inventory_items").select("*").order("name"),
  ]);
  const categories = (catsRes.data as Pick<InventoryCategory, "id" | "name" | "type">[] | null) ?? [];
  const items = (itemsRes.data as InventoryItem[] | null) ?? [];

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader
        title="Inventory"
        description="Browse by group, then category, then product."
        action={canWrite ? { href: "/inventory/new", label: "Add item" } : undefined}
      />

      {canWrite ? (
        <div className="mb-4">
          <Link
            href="/inventory/categories"
            className="text-sm font-medium text-zinc-600 underline dark:text-zinc-400"
          >
            Manage categories
          </Link>
        </div>
      ) : null}

      <InventoryBrowser categories={categories} items={items} canWrite={canWrite} />
    </div>
  );
}
