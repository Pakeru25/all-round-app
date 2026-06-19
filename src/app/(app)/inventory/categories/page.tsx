import { PageHeader } from "@/components/ui/PageHeader";
import { Card, CancelLink, Field, FormError, inputClassName } from "@/components/ui/form";
import { SubmitButton } from "@/components/ui/SubmitButton";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import type { InventoryCategory } from "@/types/database";
import { MATERIAL_TYPES, MATERIAL_TYPE_LABELS } from "@/types/database";
import { createCategory, deleteCategory } from "./actions";

export default async function CategoriesPage({
  searchParams,
}: {
  searchParams: Promise<{ error?: string }>;
}) {
  const { profile } = await requireRole(["owner", "manager"]);
  const { error } = await searchParams;
  const canDelete = profile.role === "owner";

  const supabase = await createClient();
  const { data } = await supabase
    .from("inventory_categories")
    .select("*")
    .order("material_type")
    .order("name");
  const categories = (data as InventoryCategory[] | null) ?? [];

  return (
    <div className="mx-auto max-w-3xl">
      <PageHeader
        title="Inventory categories"
        description="Group your stock items under a material type."
      />

      <Card>
        <form action={createCategory} className="flex flex-col gap-4">
          <FormError message={error} />
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
            <Field label="Name">
              <input name="name" required className={inputClassName} />
            </Field>
            <Field label="Description">
              <input name="description" className={inputClassName} />
            </Field>
          </div>
          <Field label="Type" hint="Which section this category belongs to.">
            <select name="material_type" required className={inputClassName} defaultValue="">
              <option value="" disabled>
                — Select type —
              </option>
              {MATERIAL_TYPES.map((mt) => (
                <option key={mt} value={mt}>
                  {MATERIAL_TYPE_LABELS[mt]}
                </option>
              ))}
            </select>
          </Field>
          <div>
            <SubmitButton>Add category</SubmitButton>
          </div>
        </form>
      </Card>

      <div className="mt-4 overflow-hidden rounded-xl border border-zinc-200 bg-white dark:border-zinc-800 dark:bg-zinc-900">
        {categories.length === 0 ? (
          <div className="p-8 text-center text-sm text-zinc-500">
            No categories yet.
          </div>
        ) : (
          <table className="w-full text-sm">
            <thead className="border-b border-zinc-200 text-left text-xs uppercase tracking-wide text-zinc-500 dark:border-zinc-800">
              <tr>
                <th className="px-4 py-3 font-medium">Name</th>
                <th className="px-4 py-3 font-medium">Type</th>
                <th className="px-4 py-3 font-medium">Description</th>
                {canDelete ? <th className="px-4 py-3" /> : null}
              </tr>
            </thead>
            <tbody className="divide-y divide-zinc-100 dark:divide-zinc-800">
              {categories.map((cat) => (
                <tr
                  key={cat.id}
                  className="hover:bg-zinc-50 dark:hover:bg-zinc-800/50"
                >
                  <td className="px-4 py-3 font-medium text-zinc-900 dark:text-zinc-50">
                    {cat.name}
                  </td>
                  <td className="px-4 py-3 text-zinc-600 dark:text-zinc-400">
                    {cat.material_type
                      ? MATERIAL_TYPE_LABELS[cat.material_type]
                      : "—"}
                  </td>
                  <td className="px-4 py-3 text-zinc-600 dark:text-zinc-400">
                    {cat.description ?? "—"}
                  </td>
                  {canDelete ? (
                    <td className="px-4 py-3 text-right">
                      <form action={deleteCategory.bind(null, cat.id)}>
                        <SubmitButton variant="danger">Delete</SubmitButton>
                      </form>
                    </td>
                  ) : null}
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>

      <div className="mt-4">
        <CancelLink href="/inventory" />
      </div>
    </div>
  );
}
