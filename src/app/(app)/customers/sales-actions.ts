"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { getSessionContext } from "@/lib/auth/session";
import { num, str, strOrNull } from "@/lib/forms";
import type { PaymentMethod } from "@/types/database";

const CAN_WRITE = ["owner", "manager"];
const PAYMENT_METHODS: PaymentMethod[] = ["cash", "transfer", "card", "credit"];

export async function recordHistoricalSale(customerId: string, formData: FormData) {
  const ctx = await getSessionContext();
  if (!ctx) redirect("/login");
  if (!CAN_WRITE.includes(ctx.profile.role)) redirect("/customers");

  const total = num(formData.get("total_amount"));
  if (!(total > 0)) {
    redirect(`/customers/${customerId}?error=${encodeURIComponent("Total must be greater than 0.")}`);
  }

  const saleDate = str(formData.get("sale_date"));
  if (!saleDate) {
    redirect(`/customers/${customerId}?error=${encodeURIComponent("Sale date is required.")}`);
  }

  const methodRaw = str(formData.get("payment_method"));
  const payment_method: PaymentMethod = (PAYMENT_METHODS as string[]).includes(methodRaw)
    ? (methodRaw as PaymentMethod)
    : "cash";

  const userNote = strOrNull(formData.get("notes"));
  const notes = userNote
    ? `Historical sale (imported) — ${userNote}`
    : "Historical sale (imported)";

  const supabase = await createClient();
  const { error } = await supabase.from("sales").insert({
    organization_id: ctx.profile.organization_id,
    customer_id: customerId,
    recorded_by: ctx.profile.id,
    sale_date: saleDate,
    subtotal: total,
    discount: 0,
    total_amount: total,
    payment_method,
    payment_status: "paid",
    notes,
  });

  if (error) {
    redirect(`/customers/${customerId}?error=${encodeURIComponent(error.message)}`);
  }
  revalidatePath(`/customers/${customerId}`);
  revalidatePath("/customers");
  redirect(`/customers/${customerId}`);
}
