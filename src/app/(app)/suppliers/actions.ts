"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { getSessionContext } from "@/lib/auth/session";
import { str, strOrNull } from "@/lib/forms";

const CAN_WRITE = ["owner", "manager"];

function payloadFrom(formData: FormData) {
  return {
    name: str(formData.get("name")),
    contact_person: strOrNull(formData.get("contact_person")),
    email: strOrNull(formData.get("email")),
    phone: strOrNull(formData.get("phone")),
    address: strOrNull(formData.get("address")),
    notes: strOrNull(formData.get("notes")),
  };
}

export async function createSupplier(formData: FormData) {
  const ctx = await getSessionContext();
  if (!ctx) redirect("/login");
  if (!CAN_WRITE.includes(ctx.profile.role)) redirect("/suppliers");

  const supabase = await createClient();
  const { error } = await supabase
    .from("suppliers")
    .insert({ organization_id: ctx.profile.organization_id, ...payloadFrom(formData) });

  if (error) redirect(`/suppliers/new?error=${encodeURIComponent(error.message)}`);
  revalidatePath("/suppliers");
  redirect("/suppliers");
}

export async function updateSupplier(id: string, formData: FormData) {
  const ctx = await getSessionContext();
  if (!ctx) redirect("/login");
  if (!CAN_WRITE.includes(ctx.profile.role)) redirect("/suppliers");

  const supabase = await createClient();
  const { error } = await supabase.from("suppliers").update(payloadFrom(formData)).eq("id", id);

  if (error) redirect(`/suppliers/${id}/edit?error=${encodeURIComponent(error.message)}`);
  revalidatePath("/suppliers");
  redirect("/suppliers");
}

export async function deleteSupplier(id: string) {
  const ctx = await getSessionContext();
  if (!ctx) redirect("/login");
  // Only owners may delete (per the role matrix).
  if (ctx.profile.role !== "owner") redirect("/suppliers");

  const supabase = await createClient();
  const { error } = await supabase.from("suppliers").delete().eq("id", id);

  if (error) redirect(`/suppliers/${id}/edit?error=${encodeURIComponent(error.message)}`);
  revalidatePath("/suppliers");
  redirect("/suppliers");
}
