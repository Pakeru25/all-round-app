import { PageHeader } from "@/components/ui/PageHeader";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import { formatCurrency, formatDate } from "@/lib/format";
import type { Sale } from "@/types/database";

type SaleRow = Sale & { customers: { name: string } | null };

const STATUS_BADGE: Record<string, string> = {
  paid: "bg-emerald-100 text-emerald-700 dark:bg-emerald-900/40 dark:text-emerald-300",
  partial: "bg-amber-100 text-amber-700 dark:bg-amber-900/40 dark:text-amber-300",
  unpaid: "bg-rose-100 text-rose-700 dark:bg-rose-900/40 dark:text-rose-300",
};

export default async function SalesPage() {
  await requireRole(["owner", "manager", "staff"]);

  const supabase = await createClient();
  const { data } = await supabase
    .from("sales")
    .select("*, customers(name)")
    .order("sale_date", { ascending: false });
  const sales = (data as SaleRow[] | null) ?? [];

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader title="Sales" description="Every sale you've recorded." />

      {sales.length === 0 ? (
        <div className="rounded-xl border border-dashed border-zinc-300 bg-white p-10 text-center text-sm text-zinc-500 dark:border-zinc-700 dark:bg-zinc-900">
          No sales yet.
        </div>
      ) : (
        <ul className="overflow-hidden rounded-xl border border-zinc-200 bg-white divide-y divide-zinc-100 dark:divide-zinc-800 dark:border-zinc-800 dark:bg-zinc-900">
          <li className="hidden px-4 py-3 text-xs uppercase tracking-wide text-zinc-500 sm:grid sm:grid-cols-[1fr_1fr_1.3fr_1fr_0.8fr_2.5fr] sm:gap-4 sm:items-center">
            <span>Sale #</span>
            <span>Date</span>
            <span>Customer</span>
            <span>Total</span>
            <span>Status</span>
            <span>Notes</span>
          </li>
          {sales.map((s) => (
            <li
              key={s.id}
              className="grid grid-cols-2 gap-2 px-4 py-3 text-sm hover:bg-zinc-50 sm:grid-cols-[1fr_1fr_1.3fr_1fr_0.8fr_2.5fr] sm:gap-4 sm:items-start dark:hover:bg-zinc-800/50"
            >
              <span className="font-medium text-zinc-900 dark:text-zinc-50">{s.sale_number ?? "—"}</span>
              <span className="text-zinc-600 dark:text-zinc-400">{formatDate(s.sale_date)}</span>
              <span className="text-zinc-600 dark:text-zinc-400">{s.customers?.name ?? "—"}</span>
              <span className="font-medium text-zinc-900 dark:text-zinc-50">
                {formatCurrency(Number(s.total_amount))}
              </span>
              <span>
                <span
                  className={`rounded-full px-2 py-0.5 text-xs font-medium ${
                    STATUS_BADGE[s.payment_status] ?? ""
                  }`}
                >
                  {s.payment_status}
                </span>
              </span>
              <span className="col-span-2 text-zinc-600 sm:col-span-1 dark:text-zinc-400">
                {s.notes ?? "—"}
              </span>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
