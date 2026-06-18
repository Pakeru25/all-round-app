import Link from "next/link";
import { notFound } from "next/navigation";
import { Package } from "lucide-react";
import { PageHeader } from "@/components/ui/PageHeader";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";

type CategoryRow = { id: string; name: string; description: string | null; parent_id: string | null };
type ItemRow = { id: string; category_id: string | null; quantity_in_stock: number; reorder_level: number };

export default async function GroupPage({ params }: { params: Promise<{ id: string }> }) {
  const { profile } = await requireRole(["owner", "manager", "staff"]);
  const canWrite = profile.role === "owner" || profile.role === "manager";
  const { id } = await params;

  const supabase = await createClient();
  const { data: groupData } = await supabase
    .from("inventory_categories")
    .select("id,name,description,parent_id")
    .eq("id", id)
    .single();
  const group = groupData as CategoryRow | null;
  if (!group) notFound();

  const [{ data: catData }, { data: itemData }] = await Promise.all([
    supabase.from("inventory_categories").select("id,name,description,parent_id").eq("parent_id", id).order("name"),
    supabase.from("inventory_items").select("id,category_id,quantity_in_stock,reorder_level"),
  ]);
  const categories = (catData as CategoryRow[] | null) ?? [];
  const items = (itemData as ItemRow[] | null) ?? [];

  const countByCat = new Map<string, number>();
  const availableByCat = new Map<string, number>();
  const lowByCat = new Map<string, number>();
  for (const it of items) {
    if (!it.category_id) continue;
    countByCat.set(it.category_id, (countByCat.get(it.category_id) ?? 0) + 1);
    availableByCat.set(it.category_id, (availableByCat.get(it.category_id) ?? 0) + Number(it.quantity_in_stock));
    if (it.reorder_level > 0 && Number(it.quantity_in_stock) <= it.reorder_level) {
      lowByCat.set(it.category_id, (lowByCat.get(it.category_id) ?? 0) + 1);
    }
  }

  return (
    <div className="mx-auto max-w-5xl">
      <div className="mb-2 text-sm text-zinc-500">
        <Link href="/inventory" className="hover:underline">
          Inventory
        </Link>
      </div>

      <PageHeader
        title={group.name}
        description={group.description ?? "Categories in this group."}
        action={canWrite ? { href: "/inventory/categories", label: "Manage categories" } : undefined}
      />

      {categories.length === 0 ? (
        <div className="rounded-xl border border-dashed border-zinc-300 bg-white p-10 text-center text-sm text-zinc-500 dark:border-zinc-700 dark:bg-zinc-900">
          No categories in this group yet.
          {canWrite ? (
            <>
              {" "}
              <Link href="/inventory/categories" className="underline">
                Add one
              </Link>
              .
            </>
          ) : null}
        </div>
      ) : (
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {categories.map((cat) => {
            const low = (lowByCat.get(cat.id) ?? 0) > 0;
            return (
              <Link
                key={cat.id}
                href={`/inventory/category/${cat.id}`}
                className="flex flex-col gap-2 rounded-xl border border-zinc-200 bg-white p-5 transition hover:border-zinc-300 hover:shadow-sm dark:border-zinc-800 dark:bg-zinc-900 dark:hover:border-zinc-700"
              >
                <div className="flex items-center gap-2">
                  <Package className="h-4 w-4 text-zinc-400" />
                  <span className="font-medium text-zinc-900 dark:text-zinc-50">{cat.name}</span>
                  {low ? <span className="h-1.5 w-1.5 rounded-full bg-red-500" /> : null}
                </div>
                {cat.description ? (
                  <p className="line-clamp-2 text-sm text-zinc-500">{cat.description}</p>
                ) : null}
                <div className="mt-auto flex gap-4 text-xs text-zinc-500">
                  <span>{countByCat.get(cat.id) ?? 0} items</span>
                  <span>{availableByCat.get(cat.id) ?? 0} available</span>
                </div>
              </Link>
            );
          })}
        </div>
      )}
    </div>
  );
}
