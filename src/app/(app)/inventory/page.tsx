import Link from "next/link";
import { PageHeader } from "@/components/ui/PageHeader";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import { formatCurrency } from "@/lib/format";
import type { InventoryCategory, InventoryItemWithCategory } from "@/types/database";
import { MATERIAL_TYPES, MATERIAL_TYPE_LABELS } from "@/types/database";
import type { MaterialType } from "@/types/database";

export default async function InventoryPage({
  searchParams,
}: {
  searchParams: Promise<{ type?: string; category?: string }>;
}) {
  const { profile } = await requireRole(["owner", "manager", "staff"]);
  const canWrite = profile.role === "owner" || profile.role === "manager";
  const { type, category } = await searchParams;

  const activeType: MaterialType =
    (MATERIAL_TYPES as string[]).includes(type ?? "")
      ? (type as MaterialType)
      : "raw_material";

  const supabase = await createClient();

  const { data: catsData } = await supabase
    .from("inventory_categories")
    .select("*")
    .eq("material_type", activeType)
    .order("name");
  const categories = (catsData as InventoryCategory[] | null) ?? [];

  let items: InventoryItemWithCategory[] = [];
  let activeCategoryName: string | null = null;

  if (category) {
    const catRow = categories.find((c) => c.id === category);
    activeCategoryName = catRow?.name ?? null;

    const { data: itemsData } = await supabase
      .from("inventory_items")
      .select("*, inventory_categories(name)")
      .eq("category_id", category)
      .order("name");
    items = (itemsData as InventoryItemWithCategory[] | null) ?? [];
  }

  const typeLabel = MATERIAL_TYPE_LABELS[activeType];
  const description = activeCategoryName
    ? `${typeLabel} › ${activeCategoryName}`
    : typeLabel;

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader
        title="Inventory"
        description={description}
        action={
          canWrite && category
            ? { href: `/inventory/new?category=${category}`, label: "Add item" }
            : undefined
        }
      />

      {/* Type tabs */}
      <div className="mb-6 flex gap-1 rounded-lg border border-zinc-200 bg-zinc-50 p-1 dark:border-zinc-800 dark:bg-zinc-950">
        {MATERIAL_TYPES.map((mt) => (
          <Link
            key={mt}
            href={`/inventory?type=${mt}`}
            className={[
              "flex-1 rounded-md px-4 py-2 text-center text-sm font-medium transition",
              activeType === mt
                ? "bg-white text-zinc-900 shadow-sm dark:bg-zinc-800 dark:text-zinc-50"
                : "text-zinc-500 hover:text-zinc-700 dark:text-zinc-400 dark:hover:text-zinc-300",
            ].join(" ")}
          >
            {MATERIAL_TYPE_LABELS[mt]}
          </Link>
        ))}
      </div>

      {/* Category drill-down */}
      {!category ? (
        <CategoryGrid
          categories={categories}
          activeType={activeType}
          canWrite={canWrite}
        />
      ) : (
        <ItemList
          items={items}
          activeType={activeType}
          canWrite={canWrite}
          activeCategoryName={activeCategoryName}
        />
      )}
    </div>
  );
}

function CategoryGrid({
  categories,
  activeType,
  canWrite,
}: {
  categories: InventoryCategory[];
  activeType: MaterialType;
  canWrite: boolean;
}) {
  return (
    <>
      {canWrite && (
        <div className="mb-4">
          <Link
            href="/inventory/categories"
            className="text-sm font-medium text-zinc-600 underline dark:text-zinc-400"
          >
            Manage categories
          </Link>
        </div>
      )}

      {categories.length === 0 ? (
        <div className="rounded-xl border border-dashed border-zinc-300 bg-white p-10 text-center text-sm text-zinc-500 dark:border-zinc-700 dark:bg-zinc-900">
          No categories yet for {MATERIAL_TYPE_LABELS[activeType]}.
          {canWrite ? ' Use "Manage categories" to create one.' : ""}
        </div>
      ) : (
        <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
          {categories.map((cat) => (
            <Link
              key={cat.id}
              href={`/inventory?type=${activeType}&category=${cat.id}`}
              className="rounded-xl border border-zinc-200 bg-white p-5 transition hover:border-zinc-300 hover:shadow-sm dark:border-zinc-800 dark:bg-zinc-900 dark:hover:border-zinc-700"
            >
              <div className="font-semibold text-zinc-900 dark:text-zinc-50">
                {cat.name}
              </div>
              {cat.description && (
                <div className="mt-1 text-sm text-zinc-500 dark:text-zinc-400">
                  {cat.description}
                </div>
              )}
            </Link>
          ))}
        </div>
      )}
    </>
  );
}

function ItemList({
  items,
  activeType,
  canWrite,
  activeCategoryName,
}: {
  items: InventoryItemWithCategory[];
  activeType: MaterialType;
  canWrite: boolean;
  activeCategoryName: string | null;
}) {
  return (
    <>
      <div className="mb-4">
        <Link
          href={`/inventory?type=${activeType}`}
          className="text-sm text-zinc-500 hover:text-zinc-700 dark:text-zinc-400 dark:hover:text-zinc-300"
        >
          ← Back to{" "}
          {activeCategoryName
            ? MATERIAL_TYPE_LABELS[activeType]
            : "categories"}
        </Link>
      </div>

      {items.length === 0 ? (
        <div className="rounded-xl border border-dashed border-zinc-300 bg-white p-10 text-center text-sm text-zinc-500 dark:border-zinc-700 dark:bg-zinc-900">
          No items in this category.
          {canWrite ? ' Use "Add item" to create one.' : ""}
        </div>
      ) : (
        <div className="overflow-hidden rounded-xl border border-zinc-200 bg-white dark:border-zinc-800 dark:bg-zinc-900">
          <table className="w-full text-sm">
            <thead className="border-b border-zinc-200 text-left text-xs uppercase tracking-wide text-zinc-500 dark:border-zinc-800">
              <tr>
                <th className="px-4 py-3 font-medium">Item</th>
                <th className="px-4 py-3 font-medium">In stock</th>
                <th className="px-4 py-3 font-medium">Cost</th>
                <th className="px-4 py-3 font-medium">Price</th>
                {canWrite ? <th className="px-4 py-3" /> : null}
              </tr>
            </thead>
            <tbody className="divide-y divide-zinc-100 dark:divide-zinc-800">
              {items.map((item) => {
                const low =
                  item.reorder_level > 0 &&
                  item.quantity_in_stock <= item.reorder_level;
                return (
                  <tr
                    key={item.id}
                    className="hover:bg-zinc-50 dark:hover:bg-zinc-800/50"
                  >
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
                    <td className="px-4 py-3 text-zinc-600 dark:text-zinc-400">
                      {formatCurrency(item.cost_price)}
                    </td>
                    <td className="px-4 py-3 text-zinc-600 dark:text-zinc-400">
                      {formatCurrency(item.selling_price)}
                    </td>
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
    </>
  );
}
