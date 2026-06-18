import Link from "next/link";
import { PageHeader } from "@/components/ui/PageHeader";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import { formatCurrency, formatDate, formatDateTime } from "@/lib/format";
import type { Purchase, PurchaseItem } from "@/types/database";

type PurchaseWithRelations = Purchase & {
  suppliers: { name: string } | null;
  profiles: { full_name: string | null } | null;
};

type PurchaseItemWithItem = PurchaseItem & {
  inventory_items: { name: string; unit: string } | null;
};

const PAYMENT_STATUS_STYLES: Record<string, string> = {
  paid: "bg-emerald-100 text-emerald-700 dark:bg-emerald-950 dark:text-emerald-300",
  partial: "bg-amber-100 text-amber-700 dark:bg-amber-950 dark:text-amber-300",
  unpaid: "bg-red-100 text-red-700 dark:bg-red-950 dark:text-red-300",
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

export default async function PurchaseDetailPage({ params }: { params: Promise<{ id: string }> }) {
  await requireRole(["owner", "manager", "accountant"]);
  const { id } = await params;

  const supabase = await createClient();
  const { data: purchaseData } = await supabase
    .from("purchases")
    .select("*, suppliers(name), profiles!recorded_by(full_name)")
    .eq("id", id)
    .single();
  const purchase = purchaseData as PurchaseWithRelations | null;
  if (!purchase) {
    return (
      <div className="mx-auto max-w-3xl">
        <PageHeader title="Purchase not found" description="This purchase may have been deleted." />
        <div className="rounded-xl border border-dashed border-zinc-300 bg-white p-10 text-center text-sm text-zinc-500 dark:border-zinc-700 dark:bg-zinc-900">
          The activity log keeps a permanent record of past actions, so this entry remains even after the
          purchase itself was removed.
          <div className="mt-4">
            <Link href="/purchases" className="font-medium text-zinc-700 underline hover:text-zinc-900 dark:text-zinc-300">
              Back to purchases
            </Link>
          </div>
        </div>
      </div>
    );
  }

  const { data: itemsData } = await supabase
    .from("purchase_items")
    .select("*, inventory_items(name, unit)")
    .eq("purchase_id", id);
  const items = (itemsData as PurchaseItemWithItem[] | null) ?? [];

  return (
    <div className="mx-auto max-w-5xl">
      <PageHeader
        title={purchase.purchase_number ?? "Purchase"}
        description={purchase.suppliers?.name ?? "Supplier"}
      />

      <div className="mb-4">
        <span
          className={`rounded-full px-2.5 py-1 text-xs font-medium ${
            PAYMENT_STATUS_STYLES[purchase.payment_status] ?? "bg-zinc-100 text-zinc-600"
          }`}
        >
          {purchase.payment_status}
        </span>
      </div>

      <div className="grid grid-cols-2 gap-4 lg:grid-cols-3">
        <StatCard label="Total" value={formatCurrency(Number(purchase.total_amount))} />
        <StatCard label="Date" value={formatDate(purchase.purchase_date)} />
        <StatCard label="Payment" value={purchase.payment_method} />
      </div>

      <div className="mt-4 grid grid-cols-1 gap-4 md:grid-cols-2">
        <div className="rounded-xl border border-zinc-200 bg-white p-5 dark:border-zinc-800 dark:bg-zinc-900">
          <h2 className="mb-3 text-sm font-semibold text-zinc-900 dark:text-zinc-50">Details</h2>
          <dl className="space-y-2 text-sm">
            <Row label="Purchase number" value={purchase.purchase_number ?? "—"} />
            <Row label="Supplier" value={purchase.suppliers?.name ?? "—"} />
            <Row label="Payment method" value={purchase.payment_method} />
            <Row label="Recorded by" value={purchase.profiles?.full_name ?? "—"} />
            <Row label="Logged at" value={formatDateTime(purchase.created_at)} />
          </dl>
          {purchase.notes ? (
            <div className="mt-3 border-t border-zinc-100 pt-3 dark:border-zinc-800">
              <div className="text-xs font-medium text-zinc-500">Notes</div>
              <p className="mt-1 text-sm text-zinc-700 dark:text-zinc-300">{purchase.notes}</p>
            </div>
          ) : null}
        </div>

        <div className="rounded-xl border border-zinc-200 bg-white p-5 dark:border-zinc-800 dark:bg-zinc-900">
          <h2 className="mb-3 text-sm font-semibold text-zinc-900 dark:text-zinc-50">Line items</h2>
          {items.length === 0 ? (
            <p className="text-sm text-zinc-500">No line items recorded for this purchase.</p>
          ) : (
            <ol className="space-y-2">
              {items.map((it) => (
                <li
                  key={it.id}
                  className="flex items-center justify-between gap-3 border-b border-zinc-100 pb-2 text-sm last:border-b-0 dark:border-zinc-800"
                >
                  <div>
                    <div className="text-zinc-900 dark:text-zinc-50">
                      {it.inventory_items?.name ?? "Item"}
                    </div>
                    <div className="text-xs text-zinc-500">
                      {Number(it.quantity)} {it.inventory_items?.unit ?? ""} ×{" "}
                      {formatCurrency(Number(it.unit_cost))}
                    </div>
                  </div>
                  <span className="font-medium text-zinc-900 dark:text-zinc-50">
                    {formatCurrency(Number(it.total_cost))}
                  </span>
                </li>
              ))}
            </ol>
          )}
        </div>
      </div>
    </div>
  );
}
