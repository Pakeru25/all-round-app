"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { getSessionContext } from "@/lib/auth/session";
import { str, strOrNull, num, intOrZero } from "@/lib/forms";
import { isInventoryType } from "@/lib/inventory";
import type { InventoryType } from "@/types/database";

const CAN_WRITE = ["owner", "manager"];

function payloadFrom(formData: FormData) {
  const rawType = str(formData.get("inventory_type"));
  const inventory_type: InventoryType = isInventoryType(rawType) ? rawType : "raw_material";
  return {
    name: str(formData.get("name")),
    sku: strOrNull(formData.get("sku")),
    description: strOrNull(formData.get("description")),
    category_id: strOrNull(formData.get("category_id")),
    inventory_type,
    unit: str(formData.get("unit")) || "pieces",
    quantity_in_stock: num(formData.get("quantity_in_stock")),
    cost_price: num(formData.get("cost_price")),
    selling_price: num(formData.get("selling_price")),
    reorder_level: intOrZero(formData.get("reorder_level")),
    is_active: formData.get("is_active") === "on",
  };
}

export async function createItem(formData: FormData) {
  const ctx = await getSessionContext();
  if (!ctx) redirect("/login");
  if (!CAN_WRITE.includes(ctx.profile.role)) redirect("/inventory");

  const supabase = await createClient();
  const { error } = await supabase
    .from("inventory_items")
    .insert({ organization_id: ctx.profile.organization_id, ...payloadFrom(formData) });

  if (error) redirect(`/inventory/new?error=${encodeURIComponent(error.message)}`);
  revalidatePath("/inventory");
  redirect("/inventory");
}

export async function updateItem(id: string, formData: FormData) {
  const ctx = await getSessionContext();
  if (!ctx) redirect("/login");
  if (!CAN_WRITE.includes(ctx.profile.role)) redirect("/inventory");

  const supabase = await createClient();
  const { error } = await supabase.from("inventory_items").update(payloadFrom(formData)).eq("id", id);

  if (error) redirect(`/inventory/${id}/edit?error=${encodeURIComponent(error.message)}`);
  revalidatePath("/inventory");
  redirect("/inventory");
}

export async function deleteItem(id: string) {
  const ctx = await getSessionContext();
  if (!ctx) redirect("/login");
  if (ctx.profile.role !== "owner") redirect("/inventory");

  const supabase = await createClient();
  const { error } = await supabase.from("inventory_items").delete().eq("id", id);

  if (error) redirect(`/inventory/${id}/edit?error=${encodeURIComponent(error.message)}`);
  revalidatePath("/inventory");
  redirect("/inventory");
}
