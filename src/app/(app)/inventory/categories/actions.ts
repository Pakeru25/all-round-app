"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { getSessionContext } from "@/lib/auth/session";
import { str, strOrNull } from "@/lib/forms";
import { MATERIAL_TYPES } from "@/types/database";
import type { MaterialType } from "@/types/database";

export async function createCategory(formData: FormData) {
  const ctx = await getSessionContext();
  if (!ctx) redirect("/login");
  if (!["owner", "manager"].includes(ctx.profile.role)) redirect("/inventory/categories");

  const materialTypeRaw = str(formData.get("material_type"));
  const materialType = (MATERIAL_TYPES as string[]).includes(materialTypeRaw)
    ? (materialTypeRaw as MaterialType)
    : null;

  const supabase = await createClient();
  const { error } = await supabase.from("inventory_categories").insert({
    organization_id: ctx.profile.organization_id,
    name: str(formData.get("name")),
    description: strOrNull(formData.get("description")),
    material_type: materialType,
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
