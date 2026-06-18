"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { getSessionContext } from "@/lib/auth/session";
import { num, str, strOrNull } from "@/lib/forms";

function payloadFrom(formData: FormData) {
  const salaryRaw = str(formData.get("salary"));
  const status = str(formData.get("status")) === "inactive" ? "inactive" : "active";
  return {
    full_name: str(formData.get("full_name")),
    position: strOrNull(formData.get("position")),
    email: strOrNull(formData.get("email")),
    phone: strOrNull(formData.get("phone")),
    salary: salaryRaw === "" ? null : num(formData.get("salary")),
    hire_date: strOrNull(formData.get("hire_date")),
    status,
    notes: strOrNull(formData.get("notes")),
  };
}

export async function createEmployee(formData: FormData) {
  const ctx = await getSessionContext();
  if (!ctx) redirect("/login");
  if (ctx.profile.role !== "owner") redirect("/employees");

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("employees")
    .insert({ organization_id: ctx.profile.organization_id, ...payloadFrom(formData) })
    .select("id")
    .single();

  if (error) redirect(`/employees/new?error=${encodeURIComponent(error.message)}`);
  revalidatePath("/employees");
  redirect(`/employees/staff/${data!.id}`);
}

export async function updateEmployee(id: string, formData: FormData) {
  const ctx = await getSessionContext();
  if (!ctx) redirect("/login");
  if (ctx.profile.role !== "owner") redirect("/employees");

  const supabase = await createClient();
  const { error } = await supabase.from("employees").update(payloadFrom(formData)).eq("id", id);

  if (error) redirect(`/employees/staff/${id}/edit?error=${encodeURIComponent(error.message)}`);
  revalidatePath("/employees");
  revalidatePath(`/employees/staff/${id}`);
  redirect(`/employees/staff/${id}`);
}

export async function deleteEmployee(id: string) {
  const ctx = await getSessionContext();
  if (!ctx) redirect("/login");
  if (ctx.profile.role !== "owner") redirect("/employees");

  const supabase = await createClient();
  const { error } = await supabase.from("employees").delete().eq("id", id);

  if (error) redirect(`/employees/staff/${id}/edit?error=${encodeURIComponent(error.message)}`);
  revalidatePath("/employees");
  redirect("/employees");
}
