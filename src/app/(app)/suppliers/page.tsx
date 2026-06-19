import { PageHeader } from "@/components/ui/PageHeader";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import { formatCurrency } from "@/lib/format";
import type { Supplier } from "@/types/database";

export default async function SuppliersPage() {
  await requireRole(["owner", "manager"]);

  const supabase = await createClient();
  const { data } = await supabase
    .from("suppliers")
    .select("*")
    .order("amount_spent", { ascending: false });
  const suppliers = (data as Supplier[] | null) ?? [];

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader
        title="Suppliers"
        description="Your supplier directory with spend and order history."
      />

      {suppliers.length === 0 ? (
        <div className="rounded-xl border border-dashed border-zinc-300 bg-white p-10 text-center text-sm text-zinc-500 dark:border-zinc-700 dark:bg-zinc-900">
          No suppliers yet.
        </div>
      ) : (
        <ul className="overflow-hidden rounded-xl border border-zinc-200 bg-white divide-y divide-zinc-100 dark:divide-zinc-800 dark:border-zinc-800 dark:bg-zinc-900">
          <li className="hidden px-4 py-3 text-xs uppercase tracking-wide text-zinc-500 sm:grid sm:grid-cols-[1.4fr_1fr_0.7fr_3fr] sm:gap-4 sm:items-center">
            <span>Name</span>
            <span>Total spent</span>
            <span>Orders</span>
            <span>Notes</span>
          </li>
          {suppliers.map((s) => (
            <li
              key={s.id}
              className="grid grid-cols-2 gap-2 px-4 py-3 text-sm hover:bg-zinc-50 sm:grid-cols-[1.4fr_1fr_0.7fr_3fr] sm:gap-4 sm:items-start dark:hover:bg-zinc-800/50"
            >
              <span className="font-medium text-zinc-900 dark:text-zinc-50">{s.name}</span>
              <span className="font-medium text-zinc-900 dark:text-zinc-50">
                {formatCurrency(Number(s.amount_spent))}
              </span>
              <span className="text-zinc-600 dark:text-zinc-400">{s.order_count}</span>
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
