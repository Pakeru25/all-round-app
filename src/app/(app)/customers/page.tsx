import Link from "next/link";
import { PageHeader } from "@/components/ui/PageHeader";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import { formatCurrency, formatDate } from "@/lib/format";
import { TIER_BADGE, TIER_LABELS, tierForSpend, type CustomerTier } from "@/lib/segments";
import type { CustomerStats } from "@/types/database";

export default async function CustomersPage({
  searchParams,
}: {
  searchParams: Promise<{ tier?: string }>;
}) {
  const { profile } = await requireRole(["owner", "manager", "staff"]);
  const canWrite = profile.role === "owner" || profile.role === "manager";
  const { tier } = await searchParams;
  const activeTier: CustomerTier | null = tier === "elite" || tier === "addition" ? tier : null;

  const supabase = await createClient();
  const { data } = await supabase.from("customer_stats").select("*").order("total_spent", { ascending: false });
  let customers = (data as CustomerStats[] | null) ?? [];
  if (activeTier) customers = customers.filter((c) => tierForSpend(Number(c.total_spent)) === activeTier);

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader
        title="Customers"
        description={activeTier ? `Showing: ${TIER_LABELS[activeTier]} customers` : "Everyone you sell to."}
        action={canWrite ? { href: "/customers/new", label: "Add customer" } : undefined}
      />

      {activeTier ? (
        <div className="mb-4">
          <Link href="/customers" className="text-sm text-zinc-500 underline">
            Clear filter
          </Link>
        </div>
      ) : null}

      {customers.length === 0 ? (
        <div className="rounded-xl border border-dashed border-zinc-300 bg-white p-10 text-center text-sm text-zinc-500 dark:border-zinc-700 dark:bg-zinc-900">
          {activeTier ? "No customers in this tier yet." : "No customers yet."}
          {canWrite && !activeTier ? " Use “Add customer” to create your first one." : ""}
        </div>
      ) : (
        <div className="overflow-hidden rounded-xl border border-zinc-200 bg-white dark:border-zinc-800 dark:bg-zinc-900">
          <table className="w-full text-sm">
            <thead className="border-b border-zinc-200 text-left text-xs uppercase tracking-wide text-zinc-500 dark:border-zinc-800">
              <tr>
                <th className="px-4 py-3 font-medium">Name</th>
                <th className="px-4 py-3 font-medium">Tier</th>
                <th className="px-4 py-3 font-medium">Lifetime value</th>
                <th className="px-4 py-3 font-medium">Orders</th>
                <th className="px-4 py-3 font-medium">Last order</th>
                {canWrite ? <th className="px-4 py-3" /> : null}
              </tr>
            </thead>
            <tbody className="divide-y divide-zinc-100 dark:divide-zinc-800">
              {customers.map((c) => {
                const t = tierForSpend(Number(c.total_spent));
                return (
                  <tr key={c.id} className="hover:bg-zinc-50 dark:hover:bg-zinc-800/50">
                    <td className="px-4 py-3 font-medium">
                      <Link href={`/customers/${c.id}`} className="text-zinc-900 underline-offset-2 hover:underline dark:text-zinc-50">
                        {c.name}
                      </Link>
                    </td>
                    <td className="px-4 py-3">
                      <span className={`rounded-full px-2 py-0.5 text-xs font-medium ${TIER_BADGE[t]}`}>
                        {TIER_LABELS[t]}
                      </span>
                    </td>
                    <td className="px-4 py-3 font-medium text-zinc-900 dark:text-zinc-50">
                      {formatCurrency(Number(c.total_spent))}
                    </td>
                    <td className="px-4 py-3 text-zinc-600 dark:text-zinc-400">{c.order_count}</td>
                    <td className="px-4 py-3 text-zinc-600 dark:text-zinc-400">
                      {c.last_purchase ? formatDate(c.last_purchase) : "—"}
                    </td>
                    {canWrite ? (
                      <td className="px-4 py-3 text-right">
                        <Link
                          href={`/customers/${c.id}/edit`}
                          className="text-sm font-medium text-zinc-700 underline hover:text-zinc-900 dark:text-zinc-300"
                        >
                          Edit
                        </Link>
                      </td>
                    ) : null}
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
