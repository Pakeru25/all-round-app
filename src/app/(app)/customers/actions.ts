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
    email: strOrNull(formData.get("email")),
    phone: strOrNull(formData.get("phone")),
    address: strOrNull(formData.get("address")),
    notes: strOrNull(formData.get("notes")),
  };
}

export async function createCustomer(formData: FormData) {
  const ctx = await getSessionContext();
  if (!ctx) redirect("/login");
  if (!CAN_WRITE.includes(ctx.profile.role)) redirect("/customers");

  const supabase = await createClient();
  const { error } = await supabase
    .from("customers")
    .insert({ organization_id: ctx.profile.organization_id, ...payloadFrom(formData) });

  if (error) redirect(`/customers/new?error=${encodeURIComponent(error.message)}`);
  revalidatePath("/customers");
  redirect("/customers");
}

export async function updateCustomer(id: string, formData: FormData) {
  const ctx = await getSessionContext();
  if (!ctx) redirect("/login");
  if (!CAN_WRITE.includes(ctx.profile.role)) redirect("/customers");

  const supabase = await createClient();
  const { error } = await supabase.from("customers").update(payloadFrom(formData)).eq("id", id);

  if (error) redirect(`/customers/${id}/edit?error=${encodeURIComponent(error.message)}`);
  revalidatePath("/customers");
  redirect("/customers");
}

export async function deleteCustomer(id: string) {
  const ctx = await getSessionContext();
  if (!ctx) redirect("/login");
  // Only owners may delete (per the role matrix).
  if (ctx.profile.role !== "owner") redirect("/customers");

  const supabase = await createClient();
  const { error } = await supabase.from("customers").delete().eq("id", id);

  if (error) redirect(`/customers/${id}/edit?error=${encodeURIComponent(error.message)}`);
  revalidatePath("/customers");
  redirect("/customers");
}
