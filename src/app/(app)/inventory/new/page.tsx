import { PageHeader } from "@/components/ui/PageHeader";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import type { InventoryCategory } from "@/types/database";
import { ItemForm } from "../ItemForm";
import { createItem } from "../actions";

export default async function NewItemPage({
  searchParams,
}: {
  searchParams: Promise<{ error?: string; category?: string }>;
}) {
  await requireRole(["owner", "manager"]);
  const { error, category } = await searchParams;

  const supabase = await createClient();
  const { data } = await supabase.from("inventory_categories").select("*").order("name");
  const categories = (data as InventoryCategory[] | null) ?? [];

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader title="Add item" />
      <ItemForm
        action={createItem}
        categories={categories}
        defaults={category ? { category_id: category } : undefined}
        submitLabel="Create item"
        error={error}
      />
    </div>
  );
}
