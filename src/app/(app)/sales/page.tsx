import Link from "next/link";
import { PageHeader } from "@/components/ui/PageHeader";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import { formatCurrency, formatDate } from "@/lib/format";
import type { Sale } from "@/types/database";

type SaleWithCustomer = Sale & {
  customers: { name: string } | null;
};

const STATUS_STYLES: Record<string, string> = {
  paid: "bg-emerald-100 text-emerald-700 dark:bg-emerald-950 dark:text-emerald-300",
  partial: "bg-amber-100 text-amber-700 dark:bg-amber-950 dark:text-amber-300",
  unpaid: "bg-red-100 text-red-700 dark:bg-red-950 dark:text-red-300",
};

export default async function SalesPage({
  searchParams,
}: {
  searchParams: Promise<{ year?: string }>;
}) {
  const { profile } = await requireRole(["owner", "manager", "staff"]);
  const canWrite = profile.role === "owner" || profile.role === "manager";
  const { year } = await searchParams;

  const supabase = await createClient();

  let query = supabase
    .from("sales")
    .select("*, customers(name)")
    .order("sale_date", { ascending: false });

  if (year) {
    query = query
      .gte("sale_date", `${year}-01-01`)
      .lte("sale_date", `${year}-12-31`);
  }

  const { data } = await query;
  const sales = (data as SaleWithCustomer[] | null) ?? [];
  const totalRevenue = sales.reduce((sum, s) => sum + Number(s.total_amount), 0);

  const years = ["2025", "2026"];

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader
        title="Sales"
        description="All sales records from the retail channel."
        action={canWrite ? { href: "/sales/new", label: "Record sale" } : undefined}
      />

      <div className="mb-4 flex flex-wrap items-center gap-2">
        <Link
          href="/sales"
          className={`rounded-md px-3 py-1.5 text-sm font-medium transition-colors ${
            !year
              ? "bg-zinc-900 text-white dark:bg-white dark:text-zinc-900"
              : "bg-zinc-100 text-zinc-600 hover:bg-zinc-200 dark:bg-zinc-800 dark:text-zinc-400 dark:hover:bg-zinc-700"
          }`}
        >
          All
        </Link>
        {years.map((y) => (
          <Link
            key={y}
            href={`/sales?year=${y}`}
            className={`rounded-md px-3 py-1.5 text-sm font-medium transition-colors ${
              year === y
                ? "bg-zinc-900 text-white dark:bg-white dark:text-zinc-900"
                : "bg-zinc-100 text-zinc-600 hover:bg-zinc-200 dark:bg-zinc-800 dark:text-zinc-400 dark:hover:bg-zinc-700"
            }`}
          >
            {y}
          </Link>
        ))}
        <span className="ml-auto text-sm text-zinc-500">
          {sales.length} sale{sales.length !== 1 ? "s" : ""} ·{" "}
          <span className="font-semibold text-zinc-900 dark:text-zinc-50">
            {formatCurrency(totalRevenue)}
          </span>
        </span>
      </div>

      {sales.length === 0 ? (
        <div className="rounded-xl border border-dashed border-zinc-300 bg-white p-10 text-center text-sm text-zinc-500 dark:border-zinc-700 dark:bg-zinc-900">
          {year ? `No sales found for ${year}.` : "No sales recorded yet. Run the SQL import to load historical data."}
        </div>
      ) : (
        <div className="overflow-hidden rounded-xl border border-zinc-200 bg-white dark:border-zinc-800 dark:bg-zinc-900">
          <table className="w-full text-sm">
            <thead className="border-b border-zinc-200 text-left text-xs uppercase tracking-wide text-zinc-500 dark:border-zinc-800">
              <tr>
                <th className="px-4 py-3 font-medium">Sale #</th>
                <th className="px-4 py-3 font-medium">Date</th>
                <th className="px-4 py-3 font-medium">Customer</th>
                <th className="px-4 py-3 font-medium">Method</th>
                <th className="px-4 py-3 font-medium">Status</th>
                <th className="px-4 py-3 text-right font-medium">Total</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-zinc-100 dark:divide-zinc-800">
              {sales.map((s) => (
                <tr
                  key={s.id}
                  className="cursor-pointer hover:bg-zinc-50 dark:hover:bg-zinc-800/50"
                >
                  <td className="px-4 py-3">
                    <Link href={`/sales/${s.id}`} className="font-mono text-xs text-zinc-500 hover:underline">
                      {s.sale_number ?? "—"}
                    </Link>
                  </td>
                  <td className="px-4 py-3 text-zinc-600 dark:text-zinc-400">
                    <Link href={`/sales/${s.id}`} className="hover:underline">
                      {formatDate(s.sale_date)}
                    </Link>
                  </td>
                  <td className="px-4 py-3 font-medium text-zinc-900 dark:text-zinc-50">
                    <Link href={`/sales/${s.id}`} className="hover:underline">
                      {s.customers?.name ?? "Walk-in"}
                    </Link>
                  </td>
                  <td className="px-4 py-3 capitalize text-zinc-600 dark:text-zinc-400">
                    {s.payment_method}
                  </td>
                  <td className="px-4 py-3">
                    <span
                      className={`inline-flex rounded-full px-2 py-0.5 text-xs font-medium ${STATUS_STYLES[s.payment_status] ?? "bg-zinc-100 text-zinc-600"}`}
                    >
                      {s.payment_status}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-right font-medium text-zinc-900 dark:text-zinc-50">
                    {formatCurrency(Number(s.total_amount))}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
