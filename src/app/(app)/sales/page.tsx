import Link from "next/link";
import { PageHeader } from "@/components/ui/PageHeader";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import { formatCurrency, formatDate } from "@/lib/format";
import type { Sale } from "@/types/database";

type SaleRow = Sale & { customers: { name: string } | null };

const PAYMENT_STATUS_STYLES: Record<string, string> = {
  paid: "bg-emerald-100 text-emerald-700 dark:bg-emerald-950 dark:text-emerald-300",
  partial: "bg-amber-100 text-amber-700 dark:bg-amber-950 dark:text-amber-300",
  unpaid: "bg-red-100 text-red-700 dark:bg-red-950 dark:text-red-300",
};

export default async function SalesPage() {
  await requireRole(["owner", "manager", "staff", "accountant"]);

  const supabase = await createClient();
  const { data } = await supabase
    .from("sales")
    .select("*, customers(name)")
    .order("sale_date", { ascending: false });
  const sales = (data as SaleRow[] | null) ?? [];
  const total = sales.reduce((sum, s) => sum + Number(s.total_amount), 0);

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader
        title="Sales"
        description="Every transaction, newest first. Tap a row to see its full details."
      />

      <div className="mb-4 text-sm text-zinc-500">
        {sales.length} sale{sales.length === 1 ? "" : "s"} · total{" "}
        <span className="font-semibold text-zinc-900 dark:text-zinc-50">{formatCurrency(total)}</span>
      </div>

      {sales.length === 0 ? (
        <div className="rounded-xl border border-dashed border-zinc-300 bg-white p-10 text-center text-sm text-zinc-500 dark:border-zinc-700 dark:bg-zinc-900">
          No sales recorded yet.
        </div>
      ) : (
        <div className="overflow-hidden rounded-xl border border-zinc-200 bg-white dark:border-zinc-800 dark:bg-zinc-900">
          <table className="w-full text-sm">
            <thead className="border-b border-zinc-200 text-left text-xs uppercase tracking-wide text-zinc-500 dark:border-zinc-800">
              <tr>
                <th className="px-4 py-3 font-medium">Number</th>
                <th className="px-4 py-3 font-medium">Date</th>
                <th className="px-4 py-3 font-medium">Customer</th>
                <th className="px-4 py-3 font-medium">Status</th>
                <th className="px-4 py-3 font-medium">Total</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-zinc-100 dark:divide-zinc-800">
              {sales.map((s) => {
                const detail = `/sales/${s.id}`;
                return (
                  <tr key={s.id} className="hover:bg-zinc-50 dark:hover:bg-zinc-800/50">
                    <td className="p-0 font-mono text-xs text-zinc-500">
                      <Link href={detail} className="block px-4 py-3">
                        {s.sale_number ?? "—"}
                      </Link>
                    </td>
                    <td className="p-0 text-zinc-600 dark:text-zinc-400">
                      <Link href={detail} className="block px-4 py-3">
                        {formatDate(s.sale_date)}
                      </Link>
                    </td>
                    <td className="p-0 text-zinc-600 dark:text-zinc-400">
                      <Link href={detail} className="block px-4 py-3">
                        {s.customers?.name ?? "Walk-in"}
                      </Link>
                    </td>
                    <td className="p-0">
                      <Link href={detail} className="block px-4 py-3">
                        <span
                          className={`rounded-full px-2 py-0.5 text-xs font-medium ${
                            PAYMENT_STATUS_STYLES[s.payment_status] ?? "bg-zinc-100 text-zinc-600"
                          }`}
                        >
                          {s.payment_status}
                        </span>
                      </Link>
                    </td>
                    <td className="p-0 font-medium text-zinc-900 dark:text-zinc-50">
                      <Link href={detail} className="block px-4 py-3">
                        {formatCurrency(Number(s.total_amount))}
                      </Link>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
