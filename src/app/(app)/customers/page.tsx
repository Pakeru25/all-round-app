import Link from "next/link";
import { PageHeader } from "@/components/ui/PageHeader";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import type { Customer } from "@/types/database";

export default async function CustomersPage() {
  const { profile } = await requireRole(["owner", "manager", "staff"]);
  const canWrite = profile.role === "owner" || profile.role === "manager";

  const supabase = await createClient();
  const { data } = await supabase.from("customers").select("*").order("name");
  const customers = (data as Customer[] | null) ?? [];

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader
        title="Customers"
        description="Everyone you sell to."
        action={canWrite ? { href: "/customers/new", label: "Add customer" } : undefined}
      />

      {customers.length === 0 ? (
        <div className="rounded-xl border border-dashed border-zinc-300 bg-white p-10 text-center text-sm text-zinc-500 dark:border-zinc-700 dark:bg-zinc-900">
          No customers yet.{canWrite ? " Use “Add customer” to create your first one." : ""}
        </div>
      ) : (
        <div className="overflow-hidden rounded-xl border border-zinc-200 bg-white dark:border-zinc-800 dark:bg-zinc-900">
          <table className="w-full text-sm">
            <thead className="border-b border-zinc-200 text-left text-xs uppercase tracking-wide text-zinc-500 dark:border-zinc-800">
              <tr>
                <th className="px-4 py-3 font-medium">Name</th>
                <th className="px-4 py-3 font-medium">Email</th>
                <th className="px-4 py-3 font-medium">Phone</th>
                {canWrite ? <th className="px-4 py-3" /> : null}
              </tr>
            </thead>
            <tbody className="divide-y divide-zinc-100 dark:divide-zinc-800">
              {customers.map((c) => (
                <tr key={c.id} className="hover:bg-zinc-50 dark:hover:bg-zinc-800/50">
                  <td className="px-4 py-3 font-medium text-zinc-900 dark:text-zinc-50">{c.name}</td>
                  <td className="px-4 py-3 text-zinc-600 dark:text-zinc-400">{c.email ?? "—"}</td>
                  <td className="px-4 py-3 text-zinc-600 dark:text-zinc-400">{c.phone ?? "—"}</td>
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
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
