"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { getSessionContext } from "@/lib/auth/session";
import { str, strOrNull } from "@/lib/forms";
import { INVENTORY_TYPE_ORDER } from "@/lib/inventory";
import type { InventoryType } from "@/types/database";

function toType(value: FormDataEntryValue | null): InventoryType {
  const v = typeof value === "string" ? value : "";
  return (INVENTORY_TYPE_ORDER as string[]).includes(v) ? (v as InventoryType) : "finished_product";
}

export async function createCategory(formData: FormData) {
  const ctx = await getSessionContext();
  if (!ctx) redirect("/login");
  if (!["owner", "manager"].includes(ctx.profile.role)) redirect("/inventory/categories");

  const supabase = await createClient();
  const { error } = await supabase.from("inventory_categories").insert({
    organization_id: ctx.profile.organization_id,
    name: str(formData.get("name")),
    description: strOrNull(formData.get("description")),
    type: toType(formData.get("type")),
  });

  if (error) redirect(`/inventory/categories?error=${encodeURIComponent(error.message)}`);
  revalidatePath("/inventory/categories");
  revalidatePath("/inventory");
}

export async function deleteCategory(id: string) {
  const ctx = await getSessionContext();
  if (!ctx) redirect("/login");
  // Deletes are owner-only (per the role matrix / RLS).
  if (ctx.profile.role !== "owner") redirect("/inventory/categories");

  const supabase = await createClient();
  const { error } = await supabase.from("inventory_categories").delete().eq("id", id);

  if (error) redirect(`/inventory/categories?error=${encodeURIComponent(error.message)}`);
  revalidatePath("/inventory/categories");
  revalidatePath("/inventory");
}
