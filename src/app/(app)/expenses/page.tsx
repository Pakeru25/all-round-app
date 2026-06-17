import Link from "next/link";
import { PageHeader } from "@/components/ui/PageHeader";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import { formatCurrency, formatDate } from "@/lib/format";
import type { ExpenseWithCategory } from "@/types/database";

export default async function ExpensesPage({
  searchParams,
}: {
  searchParams: Promise<{ category?: string }>;
}) {
  const { profile } = await requireRole(["owner", "manager", "accountant"]);
  const canWrite = profile.role === "owner" || profile.role === "manager";
  const { category } = await searchParams;

  const supabase = await createClient();
  let query = supabase
    .from("expenses")
    .select("*, expense_categories(name)")
    .order("expense_date", { ascending: false });
  if (category) query = query.eq("category_id", category);
  const { data } = await query;
  const expenses = (data as ExpenseWithCategory[] | null) ?? [];
  const total = expenses.reduce((sum, e) => sum + Number(e.amount), 0);

  let activeLabel: string | null = null;
  if (category) {
    const { data: cat } = await supabase.from("expense_categories").select("name").eq("id", category).single();
    activeLabel = (cat as { name: string } | null)?.name ?? "Category";
  }

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader
        title="Expenses"
        description={activeLabel ? `Showing: ${activeLabel}` : "Money going out of the business."}
        action={canWrite ? { href: "/expenses/new", label: "Log expense" } : undefined}
      />

      <div className="mb-4 flex items-center justify-between gap-4">
        <div className="text-sm text-zinc-500">
          {expenses.length} expense{expenses.length === 1 ? "" : "s"} · total{" "}
          <span className="font-semibold text-zinc-900 dark:text-zinc-50">{formatCurrency(total)}</span>
        </div>
        {activeLabel ? (
          <Link href="/expenses" className="text-sm text-zinc-500 underline">
            Clear filter
          </Link>
        ) : null}
      </div>

      {expenses.length === 0 ? (
        <div className="rounded-xl border border-dashed border-zinc-300 bg-white p-10 text-center text-sm text-zinc-500 dark:border-zinc-700 dark:bg-zinc-900">
          {activeLabel ? "No expenses in this category." : "No expenses yet."}
          {canWrite && !activeLabel ? " Use “Log expense” to record your first one." : ""}
        </div>
      ) : (
        <div className="overflow-hidden rounded-xl border border-zinc-200 bg-white dark:border-zinc-800 dark:bg-zinc-900">
          <table className="w-full text-sm">
            <thead className="border-b border-zinc-200 text-left text-xs uppercase tracking-wide text-zinc-500 dark:border-zinc-800">
              <tr>
                <th className="px-4 py-3 font-medium">Number</th>
                <th className="px-4 py-3 font-medium">Date</th>
                <th className="px-4 py-3 font-medium">Category</th>
                <th className="px-4 py-3 font-medium">Description</th>
                <th className="px-4 py-3 font-medium">Amount</th>
                {canWrite ? <th className="px-4 py-3" /> : null}
              </tr>
            </thead>
            <tbody className="divide-y divide-zinc-100 dark:divide-zinc-800">
              {expenses.map((e) => (
                <tr key={e.id} className="hover:bg-zinc-50 dark:hover:bg-zinc-800/50">
                  <td className="px-4 py-3 font-mono text-xs text-zinc-500">{e.expense_number ?? "—"}</td>
                  <td className="px-4 py-3 text-zinc-600 dark:text-zinc-400">{formatDate(e.expense_date)}</td>
                  <td className="px-4 py-3 text-zinc-600 dark:text-zinc-400">{e.expense_categories?.name ?? "—"}</td>
                  <td className="px-4 py-3 text-zinc-600 dark:text-zinc-400">{e.description ?? "—"}</td>
                  <td className="px-4 py-3 font-medium text-zinc-900 dark:text-zinc-50">{formatCurrency(e.amount)}</td>
                  {canWrite ? (
                    <td className="px-4 py-3 text-right">
                      <Link
                        href={`/expenses/${e.id}/edit`}
                        className="text-sm font-medium text-zinc-700 underline hover:text-zinc-900 dark:text-zinc-300"
                      >
                        Edit
                      </Link>
                    </td>
                  ) : null}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
