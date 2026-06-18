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
  const activeTier: CustomerTier | null = tier === "elite" || tier === "edition" ? tier : null;

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
        <ul className="overflow-hidden rounded-xl border border-zinc-200 bg-white divide-y divide-zinc-100 dark:divide-zinc-800 dark:border-zinc-800 dark:bg-zinc-900">
          <li className="hidden px-4 py-3 text-xs uppercase tracking-wide text-zinc-500 sm:grid sm:grid-cols-[2fr_1fr_1fr_0.7fr_1fr_auto] sm:gap-4 sm:items-center">
            <span>Name</span>
            <span>Tier</span>
            <span>Lifetime value</span>
            <span>Orders</span>
            <span>Last order</span>
            {canWrite ? <span className="w-10" /> : null}
          </li>
          {customers.map((c) => {
            const t = tierForSpend(Number(c.total_spent));
            return (
              <li
                key={c.id}
                className="flex items-center gap-4 hover:bg-zinc-50 dark:hover:bg-zinc-800/50"
              >
                <Link
                  href={`/customers/${c.id}`}
                  className="grid flex-1 cursor-pointer grid-cols-2 gap-2 px-4 py-3 text-sm sm:grid-cols-[2fr_1fr_1fr_0.7fr_1fr] sm:gap-4 sm:items-center"
                >
                  <span className="font-medium text-zinc-900 dark:text-zinc-50">{c.name}</span>
                  <span>
                    <span className={`rounded-full px-2 py-0.5 text-xs font-medium ${TIER_BADGE[t]}`}>
                      {TIER_LABELS[t]}
                    </span>
                  </span>
                  <span className="font-medium text-zinc-900 dark:text-zinc-50">
                    {formatCurrency(Number(c.total_spent))}
                  </span>
                  <span className="text-zinc-600 dark:text-zinc-400">{c.order_count}</span>
                  <span className="text-zinc-600 dark:text-zinc-400">
                    {c.last_purchase ? formatDate(c.last_purchase) : "—"}
                  </span>
                </Link>
                {canWrite ? (
                  <Link
                    href={`/customers/${c.id}/edit`}
                    className="px-4 py-3 text-sm font-medium text-zinc-700 underline hover:text-zinc-900 dark:text-zinc-300"
                  >
                    Edit
                  </Link>
                ) : null}
              </li>
            );
          })}
        </ul>
      )}
    </div>
  );
}
