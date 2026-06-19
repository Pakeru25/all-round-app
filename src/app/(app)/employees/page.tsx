import Link from "next/link";
import { PageHeader } from "@/components/ui/PageHeader";
import { SearchBar } from "@/components/ui/SearchBar";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import { matchesQuery } from "@/lib/search";
import type { Employee, Profile, Role } from "@/types/database";

type Row = {
  kind: "user" | "staff";
  id: string;
  name: string;
  subtitle: string;
  role: Role | null;
  active: boolean;
};

const ROLE_LABELS: Record<Role, string> = {
  owner: "Owner",
  manager: "Manager",
  staff: "Staff",
  accountant: "Accountant",
};

const ROLE_BADGE: Record<Role, string> = {
  owner: "bg-amber-100 text-amber-800 dark:bg-amber-900/40 dark:text-amber-200",
  manager: "bg-blue-100 text-blue-800 dark:bg-blue-900/40 dark:text-blue-200",
  staff: "bg-zinc-100 text-zinc-700 dark:bg-zinc-800 dark:text-zinc-200",
  accountant: "bg-purple-100 text-purple-800 dark:bg-purple-900/40 dark:text-purple-200",
};

export default async function EmployeesPage({
  searchParams,
}: {
  searchParams: Promise<{ q?: string }>;
}) {
  await requireRole(["owner"]);
  const { q } = await searchParams;
  const search = q ?? "";

  const supabase = await createClient();
  const [profilesRes, employeesRes] = await Promise.all([
    supabase
      .from("profiles")
      .select("id,full_name,email,role,avatar_url,is_active,organization_id,created_at"),
    supabase.from("employees").select("id,full_name,position,email,phone,status"),
  ]);

  const profiles = (profilesRes.data as Profile[] | null) ?? [];
  const employees =
    (employeesRes.data as Pick<
      Employee,
      "id" | "full_name" | "position" | "email" | "phone" | "status"
    >[] | null) ?? [];

  let rows: Row[] = [
    ...profiles.map<Row>((p) => ({
      kind: "user",
      id: p.id,
      name: p.full_name ?? p.email ?? "Unnamed",
      subtitle: p.email ?? "—",
      role: p.role,
      active: p.is_active,
    })),
    ...employees.map<Row>((e) => ({
      kind: "staff",
      id: e.id,
      name: e.full_name,
      subtitle: e.position ?? e.email ?? e.phone ?? "—",
      role: null,
      active: e.status === "active",
    })),
  ].sort((a, b) => a.name.localeCompare(b.name));

  if (search) {
    rows = rows.filter((r) =>
      matchesQuery(search, r.name, r.subtitle, r.role ? ROLE_LABELS[r.role] : "Employee"),
    );
  }

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader
        title="Employees"
        description="Everyone on the team — owners, managers, staff and hired employees."
        action={{ href: "/employees/new", label: "Add employee" }}
      />

      <div className="mb-4">
        <SearchBar placeholder="Search employees…" />
      </div>

      {rows.length === 0 ? (
        <div className="rounded-xl border border-dashed border-zinc-300 bg-white p-10 text-center text-sm text-zinc-500 dark:border-zinc-700 dark:bg-zinc-900">
          {search
            ? "No team members match your search."
            : "No team members yet. Use “Add employee” to create the first record."}
        </div>
      ) : (
        <ul className="overflow-hidden rounded-xl border border-zinc-200 bg-white divide-y divide-zinc-100 dark:divide-zinc-800 dark:border-zinc-800 dark:bg-zinc-900">
          <li className="hidden px-4 py-3 text-xs uppercase tracking-wide text-zinc-500 sm:grid sm:grid-cols-[2fr_1.5fr_1fr_0.6fr] sm:gap-4 sm:items-center">
            <span>Name</span>
            <span>Email / position</span>
            <span>Role</span>
            <span>Status</span>
          </li>
          {rows.map((r) => {
            const badgeLabel = r.role ? ROLE_LABELS[r.role] : "Employee";
            const badgeClass = r.role
              ? ROLE_BADGE[r.role]
              : "bg-emerald-100 text-emerald-800 dark:bg-emerald-900/40 dark:text-emerald-200";
            return (
              <li
                key={`${r.kind}:${r.id}`}
                className="hover:bg-zinc-50 dark:hover:bg-zinc-800/50"
              >
                <Link
                  href={`/employees/${r.kind}/${r.id}`}
                  className="grid cursor-pointer grid-cols-2 gap-2 px-4 py-3 text-sm sm:grid-cols-[2fr_1.5fr_1fr_0.6fr] sm:gap-4 sm:items-center"
                >
                  <span className="font-medium text-zinc-900 dark:text-zinc-50">{r.name}</span>
                  <span className="text-zinc-600 dark:text-zinc-400">{r.subtitle}</span>
                  <span>
                    <span className={`rounded-full px-2 py-0.5 text-xs font-medium ${badgeClass}`}>
                      {badgeLabel}
                    </span>
                  </span>
                  <span className="text-xs text-zinc-500">
                    {r.active ? "Active" : "Inactive"}
                  </span>
                </Link>
              </li>
            );
          })}
        </ul>
      )}
    </div>
  );
}
