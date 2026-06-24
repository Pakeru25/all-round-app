import Link from "next/link";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card } from "@/components/ui/form";
import { SubmitButton } from "@/components/ui/SubmitButton";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import { formatCurrency, formatDate, formatDateTime } from "@/lib/format";
import type { ExpenseWithCategory } from "@/types/database";
import { deleteExpense } from "../actions";

function StatCard({ label, value }: { label: string; value: string }) {
  return (
    <div className="rounded-xl border border-zinc-200 bg-white p-4 dark:border-zinc-800 dark:bg-zinc-900">
      <div className="text-xs text-zinc-500">{label}</div>
      <div className="mt-1 text-xl font-semibold text-zinc-900 dark:text-zinc-50">{value}</div>
    </div>
  );
}

function Row({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex justify-between gap-4">
      <dt className="text-zinc-500">{label}</dt>
      <dd className="max-w-[60%] text-right text-zinc-900 dark:text-zinc-50">{value}</dd>
    </div>
  );
}

export default async function ExpenseDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { profile } = await requireRole(["owner", "manager", "accountant"]);
  const canWrite = profile.role === "owner" || profile.role === "manager";
  const canDelete = profile.role === "owner";
  const { id } = await params;

  const supabase = await createClient();
  const { data: expData } = await supabase
    .from("expenses")
    .select("*, expense_categories(name)")
    .eq("id", id)
    .single();
  const expense = expData as ExpenseWithCategory | null;
  if (!expense) {
    return (
      <div className="mx-auto max-w-3xl">
        <PageHeader title="Expense not found" description="This expense may have been deleted." />
        <div className="rounded-xl border border-dashed border-zinc-300 bg-white p-10 text-center text-sm text-zinc-500 dark:border-zinc-700 dark:bg-zinc-900">
          The activity log keeps a permanent record of past actions, so this entry remains even after the
          expense itself was removed.
          <div className="mt-4">
            <Link href="/expenses" className="font-medium text-zinc-700 underline hover:text-zinc-900 dark:text-zinc-300">
              Back to expenses
            </Link>
          </div>
        </div>
      </div>
    );
  }

  let recordedByName: string | null = null;
  if (expense.recorded_by) {
    const { data: profileData } = await supabase
      .from("profiles")
      .select("full_name")
      .eq("id", expense.recorded_by)
      .single();
    recordedByName = (profileData as { full_name: string | null } | null)?.full_name ?? null;
  }

  return (
    <div className="mx-auto max-w-5xl">
      <PageHeader
        title={expense.expense_number ?? "Expense"}
        description={expense.expense_categories?.name ?? "Uncategorised"}
        action={canWrite ? { href: `/expenses/${expense.id}/edit`, label: "Edit" } : undefined}
      />

      <div className="grid grid-cols-2 gap-4 lg:grid-cols-3">
        <StatCard label="Amount" value={formatCurrency(Number(expense.amount))} />
        <StatCard label="Date" value={formatDate(expense.expense_date)} />
        <StatCard label="Category" value={expense.expense_categories?.name ?? "—"} />
      </div>

      <div className="mt-4 grid grid-cols-1 gap-4 md:grid-cols-2">
        <div className="rounded-xl border border-zinc-200 bg-white p-5 dark:border-zinc-800 dark:bg-zinc-900">
          <h2 className="mb-3 text-sm font-semibold text-zinc-900 dark:text-zinc-50">Details</h2>
          <dl className="space-y-2 text-sm">
            <Row label="Expense number" value={expense.expense_number ?? "—"} />
            <Row label="Recorded by" value={recordedByName ?? "—"} />
            <Row label="Logged at" value={formatDateTime(expense.created_at)} />
            <Row
              label="Receipt"
              value={expense.receipt_url ? "Attached" : "None"}
            />
          </dl>
          {expense.receipt_url ? (
            <div className="mt-3 border-t border-zinc-100 pt-3 dark:border-zinc-800">
              <Link
                href={expense.receipt_url}
                target="_blank"
                rel="noopener noreferrer"
                className="text-sm font-medium text-zinc-700 underline hover:text-zinc-900 dark:text-zinc-300"
              >
                View receipt
              </Link>
            </div>
          ) : null}
        </div>

        <div className="rounded-xl border border-zinc-200 bg-white p-5 dark:border-zinc-800 dark:bg-zinc-900">
          <h2 className="mb-3 text-sm font-semibold text-zinc-900 dark:text-zinc-50">Description</h2>
          {expense.description ? (
            <p className="text-sm text-zinc-700 dark:text-zinc-300">{expense.description}</p>
          ) : (
            <p className="text-sm text-zinc-500">No description was added when this expense was logged.</p>
          )}
        </div>
      </div>

      {canDelete ? (
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
