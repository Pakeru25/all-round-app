import { PageHeader } from "@/components/ui/PageHeader";
import { Card, CancelLink, Field, FormError, inputClassName } from "@/components/ui/form";
import { SubmitButton } from "@/components/ui/SubmitButton";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import type { InventoryCategory } from "@/types/database";
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
  const { data } = await supabase.from("inventory_categories").select("*").order("name");
  const categories = (data as InventoryCategory[] | null) ?? [];

  const groups = categories.filter((c) => c.parent_id === null);
  const typesByGroup = new Map<string, InventoryCategory[]>();
  for (const c of categories) {
    if (!c.parent_id) continue;
    const bucket = typesByGroup.get(c.parent_id);
    if (bucket) bucket.push(c);
    else typesByGroup.set(c.parent_id, [c]);
  }

  return (
    <div className="mx-auto max-w-3xl">
      <PageHeader
        title="Inventory categories"
        description="Organize stock as groups (e.g. Packaging materials) → categories (e.g. Boxes)."
      />

      <Card>
        <form action={createCategory} className="flex flex-col gap-4">
          <FormError message={error} />
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
            <Field label="Name">
              <input name="name" required className={inputClassName} />
            </Field>
            <Field label="Group" hint="Leave as “Top-level group” to create a new group.">
              <select name="parent_id" defaultValue="" className={inputClassName}>
                <option value="">— Top-level group —</option>
                {groups.map((g) => (
                  <option key={g.id} value={g.id}>
                    {g.name}
                  </option>
                ))}
              </select>
            </Field>
          </div>
          <Field label="Description">
            <input name="description" className={inputClassName} />
          </Field>
          <div>
            <SubmitButton>Add category</SubmitButton>
          </div>
        </form>
      </Card>

      <div className="mt-4 space-y-4">
        {groups.length === 0 ? (
          <div className="rounded-xl border border-zinc-200 bg-white p-8 text-center text-sm text-zinc-500 dark:border-zinc-800 dark:bg-zinc-900">
            No groups yet.
          </div>
        ) : (
          groups.map((group) => {
            const types = typesByGroup.get(group.id) ?? [];
            return (
              <div
                key={group.id}
                className="overflow-hidden rounded-xl border border-zinc-200 bg-white dark:border-zinc-800 dark:bg-zinc-900"
              >
                <div className="flex items-center justify-between gap-4 border-b border-zinc-100 px-4 py-3 dark:border-zinc-800">
                  <div>
                    <div className="font-semibold text-zinc-900 dark:text-zinc-50">{group.name}</div>
                    {group.description ? (
                      <div className="text-xs text-zinc-500">{group.description}</div>
                    ) : null}
                  </div>
                  {canDelete ? (
                    <form action={deleteCategory.bind(null, group.id)}>
                      <SubmitButton variant="danger">Delete</SubmitButton>
                    </form>
                  ) : null}
                </div>
                {types.length === 0 ? (
                  <div className="px-4 py-3 text-sm text-zinc-500">No categories in this group yet.</div>
                ) : (
                  <table className="w-full text-sm">
                    <tbody className="divide-y divide-zinc-100 dark:divide-zinc-800">
                      {types.map((cat) => (
                        <tr key={cat.id} className="hover:bg-zinc-50 dark:hover:bg-zinc-800/50">
                          <td className="px-4 py-3 font-medium text-zinc-900 dark:text-zinc-50">{cat.name}</td>
                          <td className="px-4 py-3 text-zinc-600 dark:text-zinc-400">{cat.description ?? "—"}</td>
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
            );
          })
        )}
      </div>

      <div className="mt-4">
        <CancelLink href="/inventory" />
      </div>
    </div>
  );
}
