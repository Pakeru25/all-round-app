import { notFound } from "next/navigation";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card } from "@/components/ui/form";
import { SubmitButton } from "@/components/ui/SubmitButton";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import type { Expense, ExpenseCategory } from "@/types/database";
import { ExpenseForm } from "../../ExpenseForm";
import { updateExpense, deleteExpense } from "../../actions";

export default async function EditExpensePage({
  params,
  searchParams,
}: {
  params: Promise<{ id: string }>;
  searchParams: Promise<{ error?: string }>;
}) {
  const { profile } = await requireRole(["owner", "manager"]);
  const { id } = await params;
  const { error } = await searchParams;

  const supabase = await createClient();
  const [{ data: expData }, { data: catData }] = await Promise.all([
    supabase.from("expenses").select("*").eq("id", id).single(),
    supabase.from("expense_categories").select("*").order("name"),
  ]);
  const expense = expData as Expense | null;
  if (!expense) notFound();
  const categories = (catData as ExpenseCategory[] | null) ?? [];

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader title="Edit expense" description={expense.expense_number ?? undefined} />
      <ExpenseForm
        action={updateExpense.bind(null, expense.id)}
        categories={categories}
        defaults={expense}
        submitLabel="Save changes"
        error={error}
      />

      {profile.role === "owner" ? (
        <div className="mt-4 max-w-xl">
          <Card>
            <form action={deleteExpense.bind(null, expense.id)} className="flex items-center justify-between gap-4">
              <span className="text-sm text-zinc-500">Permanently delete this expense.</span>
              <SubmitButton variant="danger">Delete</SubmitButton>
            </form>
          </Card>
        </div>
      ) : null}
    </div>
  );
}
