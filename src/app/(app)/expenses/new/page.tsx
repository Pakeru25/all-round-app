import { PageHeader } from "@/components/ui/PageHeader";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import type { ExpenseCategory } from "@/types/database";
import { ExpenseForm } from "../ExpenseForm";
import { createExpense } from "../actions";

export default async function NewExpensePage({
  searchParams,
}: {
  searchParams: Promise<{ error?: string }>;
}) {
  await requireRole(["owner", "manager"]);
  const { error } = await searchParams;

  const supabase = await createClient();
  const { data } = await supabase.from("expense_categories").select("*").order("name");
  const categories = (data as ExpenseCategory[] | null) ?? [];

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader title="Log expense" />
      <ExpenseForm action={createExpense} categories={categories} submitLabel="Save expense" error={error} />
    </div>
  );
}
