import { notFound } from "next/navigation";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card } from "@/components/ui/form";
import { SubmitButton } from "@/components/ui/SubmitButton";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import type { InventoryCategory, InventoryItem } from "@/types/database";
import { ItemForm } from "../../ItemForm";
import { updateItem, deleteItem } from "../../actions";

export default async function EditItemPage({
  params,
  searchParams,
}: {
  params: Promise<{ id: string }>;
  searchParams: Promise<{ error?: string }>;
}) {
  const { profile } = await requireRole(["owner", "manager"]);
  const { id } = await params;
  const { error } = await searchParams;

  const supabase = await createClient();
  const [{ data: itemData }, { data: catData }] = await Promise.all([
    supabase.from("inventory_items").select("*").eq("id", id).single(),
    supabase.from("inventory_categories").select("*").order("name"),
  ]);
  const item = itemData as InventoryItem | null;
  if (!item) notFound();
  const categories = (catData as InventoryCategory[] | null) ?? [];

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader title="Edit item" description={item.name} />
      <ItemForm
        action={updateItem.bind(null, item.id)}
        categories={categories}
        defaults={item}
        submitLabel="Save changes"
        error={error}
      />

      {profile.role === "owner" ? (
        <div className="mt-4 max-w-2xl">
          <Card>
            <form action={deleteItem.bind(null, item.id)} className="flex items-center justify-between gap-4">
              <span className="text-sm text-zinc-500">Permanently delete this item.</span>
              <SubmitButton variant="danger">Delete</SubmitButton>
            </form>
          </Card>
        </div>
      ) : null}
    </div>
  );
}
