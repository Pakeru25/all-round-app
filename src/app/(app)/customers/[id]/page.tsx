import { notFound } from "next/navigation";
import { PageHeader } from "@/components/ui/PageHeader";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import { formatCurrency, formatDate } from "@/lib/format";
import { TIER_BADGE, TIER_LABELS, tierForSpend } from "@/lib/segments";
import type { CustomerStats } from "@/types/database";

type Sale = {
  id: string;
  sale_number: string | null;
  sale_date: string;
  total_amount: number;
  payment_status: string;
};

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

export default async function CustomerDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { profile } = await requireRole(["owner", "manager", "staff"]);
  const canWrite = profile.role === "owner" || profile.role === "manager";
  const { id } = await params;

  const supabase = await createClient();
  const { data: cData } = await supabase.from("customer_stats").select("*").eq("id", id).single();
  const c = cData as CustomerStats | null;
  if (!c) notFound();

  const { data: salesData } = await supabase
    .from("sales")
    .select("id,sale_number,sale_date,total_amount,payment_status")
    .eq("customer_id", id)
    .order("sale_date", { ascending: false })
    .limit(50);
  const sales = (salesData as Sale[] | null) ?? [];

  const tier = tierForSpend(Number(c.total_spent));
  const avg = c.order_count > 0 ? Number(c.total_spent) / c.order_count : 0;

  return (
    <div className="mx-auto max-w-5xl">
      <PageHeader
        title={c.name}
        description={c.email ?? c.phone ?? "Customer"}
        action={canWrite ? { href: `/customers/${c.id}/edit`, label: "Edit" } : undefined}
      />

      <div className="mb-4">
        <span className={`rounded-full px-2.5 py-1 text-xs font-medium ${TIER_BADGE[tier]}`}>
          {TIER_LABELS[tier]} customer
        </span>
      </div>

      <div className="grid grid-cols-2 gap-4 lg:grid-cols-4">
        <StatCard label="Lifetime value" value={formatCurrency(Number(c.total_spent))} />
        <StatCard label="Orders" value={String(c.order_count)} />
        <StatCard label="Last purchase" value={c.last_purchase ? formatDate(c.last_purchase) : "—"} />
        <StatCard label="Average order" value={formatCurrency(avg)} />
      </div>

      <div className="mt-4 grid grid-cols-1 gap-4 md:grid-cols-2">
        <div className="rounded-xl border border-zinc-200 bg-white p-5 dark:border-zinc-800 dark:bg-zinc-900">
          <h2 className="mb-3 text-sm font-semibold text-zinc-900 dark:text-zinc-50">Profile</h2>
          <dl className="space-y-2 text-sm">
            <Row label="Email" value={c.email ?? "—"} />
            <Row label="Phone" value={c.phone ?? "—"} />
            <Row label="Location" value={c.address ?? "—"} />
            <Row label="Customer since" value={formatDate(c.created_at)} />
          </dl>
          {c.preferences ? (
            <div className="mt-3 border-t border-zinc-100 pt-3 dark:border-zinc-800">
              <div className="text-xs font-medium text-zinc-500">Preferences</div>
              <p className="mt-1 text-sm text-zinc-700 dark:text-zinc-300">{c.preferences}</p>
            </div>
          ) : null}
          {c.notes ? (
            <div className="mt-3 border-t border-zinc-100 pt-3 dark:border-zinc-800">
              <div className="text-xs font-medium text-zinc-500">Notes</div>
              <p className="mt-1 text-sm text-zinc-700 dark:text-zinc-300">{c.notes}</p>
            </div>
          ) : null}
        </div>

        <div className="rounded-xl border border-zinc-200 bg-white p-5 dark:border-zinc-800 dark:bg-zinc-900">
          <h2 className="mb-3 text-sm font-semibold text-zinc-900 dark:text-zinc-50">Purchase history</h2>
          {sales.length === 0 ? (
            <p className="text-sm text-zinc-500">
              No purchases recorded yet. Once sales are logged for this customer, they appear here and their lifetime
              value and tier update automatically.
            </p>
          ) : (
            <ol className="space-y-2">
              {sales.map((s) => (
                <li key={s.id} className="flex items-center justify-between gap-3 border-b border-zinc-100 pb-2 text-sm last:border-b-0 dark:border-zinc-800">
                  <div>
                    <span className="font-mono text-xs text-zinc-500">{s.sale_number ?? "—"}</span>
                    <span className="ml-2 text-zinc-500">{formatDate(s.sale_date)}</span>
                  </div>
                  <span className="font-medium text-zinc-900 dark:text-zinc-50">{formatCurrency(Number(s.total_amount))}</span>
                </li>
              ))}
            </ol>
          )}
        </div>
      </div>
    </div>
  );
}
