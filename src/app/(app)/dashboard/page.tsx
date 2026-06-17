import { getSessionContext } from "@/lib/auth/session";
import { formatCurrency } from "@/lib/format";

function StatCard({ label, value, hint }: { label: string; value: string; hint: string }) {
  return (
    <div className="rounded-xl border border-zinc-200 bg-white p-5 dark:border-zinc-800 dark:bg-zinc-900">
      <div className="text-sm text-zinc-500">{label}</div>
      <div className="mt-2 text-2xl font-semibold text-zinc-900 dark:text-zinc-50">
        {value}
      </div>
      <div className="mt-1 text-xs text-zinc-400">{hint}</div>
    </div>
  );
}

export default async function DashboardPage() {
  const ctx = await getSessionContext();
  const firstName = (ctx?.profile.full_name ?? "there").split(" ")[0];

  return (
    <div className="mx-auto max-w-6xl">
      <h1 className="text-2xl font-semibold tracking-tight text-zinc-900 dark:text-zinc-50">
        Welcome, {firstName}
      </h1>
      <p className="mt-1 text-sm text-zinc-500">
        Here is where your business at a glance will live. Live figures arrive
        when the sales, purchases and expenses screens are built.
      </p>

      <div className="mt-6 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <StatCard label="Today's sales" value={formatCurrency(0)} hint="Coming soon" />
        <StatCard label="Today's expenses" value={formatCurrency(0)} hint="Coming soon" />
        <StatCard label="Low-stock items" value="0" hint="Coming soon" />
        <StatCard label="Stock value" value={formatCurrency(0)} hint="Coming soon" />
      </div>

      <div className="mt-6 rounded-xl border border-dashed border-zinc-300 bg-white p-8 text-center text-sm text-zinc-500 dark:border-zinc-700 dark:bg-zinc-900">
        Recent activity and notifications will appear here once those features
        ship. The foundation (auth, roles, database, and security) is in place.
      </div>
    </div>
  );
}
