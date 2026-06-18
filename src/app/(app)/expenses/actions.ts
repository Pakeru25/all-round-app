"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { getSessionContext } from "@/lib/auth/session";
import { str, strOrNull, num } from "@/lib/forms";

const CAN_WRITE = ["owner", "manager"];

function payloadFrom(formData: FormData) {
  return {
    category_id: strOrNull(formData.get("category_id")),
    amount: num(formData.get("amount")),
    description: strOrNull(formData.get("description")),
    expense_date: str(formData.get("expense_date")) || new Date().toISOString().slice(0, 10),
  };
}

export async function createExpense(formData: FormData) {
  const ctx = await getSessionContext();
  if (!ctx) redirect("/login");
  if (!CAN_WRITE.includes(ctx.profile.role)) redirect("/expenses");

  const supabase = await createClient();
  const { error } = await supabase.from("expenses").insert({
    organization_id: ctx.profile.organization_id,
    recorded_by: ctx.profile.id, // who logged it -> drives the activity trail + owner alerts
    ...payloadFrom(formData),
  });

  if (error) redirect(`/expenses/new?error=${encodeURIComponent(error.message)}`);
  revalidatePath("/expenses");
  redirect("/expenses");
}

export async function updateExpense(id: string, formData: FormData) {
  const ctx = await getSessionContext();
  if (!ctx) redirect("/login");
  if (!CAN_WRITE.includes(ctx.profile.role)) redirect("/expenses");

  const supabase = await createClient();
  const { error } = await supabase.from("expenses").update(payloadFrom(formData)).eq("id", id);

  if (error) redirect(`/expenses/${id}/edit?error=${encodeURIComponent(error.message)}`);
  revalidatePath("/expenses");
  redirect("/expenses");
}

export async function deleteExpense(id: string) {
  const ctx = await getSessionContext();
  if (!ctx) redirect("/login");
  if (ctx.profile.role !== "owner") redirect("/expenses");

  const supabase = await createClient();
  const { data: expData } = await supabase
    .from("expenses")
    .select("organization_id, expense_number, amount")
    .eq("id", id)
    .single();
  const expense = expData as
    | { organization_id: string; expense_number: string | null; amount: number }
    | null;

  const { error } = await supabase.from("expenses").delete().eq("id", id);
  if (error) redirect(`/expenses/${id}/edit?error=${encodeURIComponent(error.message)}`);

  if (expense) {
    const actor = ctx.profile.full_name ?? "Someone";
    const ref = expense.expense_number ?? "";
    await supabase.from("activity_log").insert({
      organization_id: expense.organization_id,
      user_id: ctx.profile.id,
      action: "deleted",
      entity_type: "expense",
      entity_id: id,
      description: `${actor} deleted expense ${ref} for GH₵${expense.amount}`.replace(/\s+/g, " ").trim(),
      metadata: { amount: expense.amount, expense_number: expense.expense_number },
    });
  }

  revalidatePath("/expenses");
  revalidatePath("/activity");
  redirect("/expenses");
}
