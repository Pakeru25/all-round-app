import { notFound } from "next/navigation";
import { PageHeader } from "@/components/ui/PageHeader";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import { formatCurrency, formatDate } from "@/lib/format";
import type { Employee } from "@/types/database";

function Row({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex justify-between gap-4">
      <dt className="text-zinc-500">{label}</dt>
      <dd className="max-w-[60%] text-right text-zinc-900 dark:text-zinc-50">{value}</dd>
    </div>
  );
}

export default async function EmployeeProfilePage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  await requireRole(["owner"]);
  const { id } = await params;

  const supabase = await createClient();
  const { data } = await supabase.from("employees").select("*").eq("id", id).single();
  const employee = data as Employee | null;
  if (!employee) notFound();

  return (
    <div className="mx-auto max-w-3xl">
      <PageHeader
        title={employee.full_name}
        description={employee.position ?? "Employee"}
        action={{ href: `/employees/staff/${employee.id}/edit`, label: "Edit" }}
      />

      <div className="mb-4">
        <span
          className={`rounded-full px-2.5 py-1 text-xs font-medium ${
            employee.status === "active"
              ? "bg-emerald-100 text-emerald-800 dark:bg-emerald-900/40 dark:text-emerald-200"
              : "bg-zinc-100 text-zinc-700 dark:bg-zinc-800 dark:text-zinc-300"
          }`}
        >
          {employee.status === "active" ? "Active" : "Inactive"}
        </span>
      </div>

      <div className="rounded-xl border border-zinc-200 bg-white p-5 dark:border-zinc-800 dark:bg-zinc-900">
        <h2 className="mb-3 text-sm font-semibold text-zinc-900 dark:text-zinc-50">Profile</h2>
        <dl className="space-y-2 text-sm">
          <Row label="Position" value={employee.position ?? "—"} />
          <Row label="Email" value={employee.email ?? "—"} />
          <Row label="Phone" value={employee.phone ?? "—"} />
          <Row
            label="Salary"
            value={employee.salary != null ? formatCurrency(Number(employee.salary)) : "—"}
          />
          <Row label="Hire date" value={formatDate(employee.hire_date)} />
          <Row label="Record created" value={formatDate(employee.created_at)} />
        </dl>
        {employee.notes ? (
          <div className="mt-3 border-t border-zinc-100 pt-3 dark:border-zinc-800">
            <div className="text-xs font-medium text-zinc-500">Notes</div>
            <p className="mt-1 text-sm text-zinc-700 dark:text-zinc-300">{employee.notes}</p>
          </div>
        ) : null}
      </div>
    </div>
  );
}
