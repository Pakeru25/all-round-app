"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { getSessionContext } from "@/lib/auth/session";
import { str, strOrNull, num, intOrZero } from "@/lib/forms";

const CAN_WRITE = ["owner", "manager"];

/**
 * Record damaged/defective units for an item. Writes a `damage` stock movement
 * (the single source of truth for the defective totals shown on item/category
 * pages) and reduces available stock by the same amount.
 */
export async function logDamage(itemId: string, formData: FormData) {
  const ctx = await getSessionContext();
  if (!ctx) redirect("/login");
  const back = `/inventory/${itemId}`;
  if (!CAN_WRITE.includes(ctx.profile.role)) redirect(back);

  const quantity = num(formData.get("quantity"));
  if (quantity <= 0) redirect(`${back}?error=${encodeURIComponent("Enter a quantity greater than zero.")}`);

  const supabase = await createClient();
  const { data: item } = await supabase
    .from("inventory_items")
    .select("quantity_in_stock")
    .eq("id", itemId)
    .single();
  if (!item) redirect(`${back}?error=${encodeURIComponent("Item not found.")}`);

  const { error: movErr } = await supabase.from("inventory_movements").insert({
    organization_id: ctx.profile.organization_id,
    inventory_item_id: itemId,
    movement_type: "out",
    quantity,
    reason: "damage",
    notes: strOrNull(formData.get("notes")),
    recorded_by: ctx.profile.id,
  });
  if (movErr) redirect(`${back}?error=${encodeURIComponent(movErr.message)}`);

  const next = Number(item.quantity_in_stock) - quantity;
  const { error: updErr } = await supabase
    .from("inventory_items")
    .update({ quantity_in_stock: next })
    .eq("id", itemId);
  if (updErr) redirect(`${back}?error=${encodeURIComponent(updErr.message)}`);

  revalidatePath(back);
  revalidatePath("/inventory");
  redirect(back);
}

function payloadFrom(formData: FormData) {
  return {
    name: str(formData.get("name")),
    sku: strOrNull(formData.get("sku")),
    description: strOrNull(formData.get("description")),
    category_id: strOrNull(formData.get("category_id")),
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
