import { notFound } from "next/navigation";
import { PageHeader } from "@/components/ui/PageHeader";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import { formatDate } from "@/lib/format";
import type { Profile, Role } from "@/types/database";

const ROLE_LABELS: Record<Role, string> = {
  owner: "Owner",
  manager: "Manager",
  staff: "Staff",
  accountant: "Accountant",
};

function Row({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex justify-between gap-4">
      <dt className="text-zinc-500">{label}</dt>
      <dd className="max-w-[60%] text-right text-zinc-900 dark:text-zinc-50">{value}</dd>
    </div>
  );
}

export default async function UserProfilePage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  await requireRole(["owner"]);
  const { id } = await params;

  const supabase = await createClient();
  const { data } = await supabase.from("profiles").select("*").eq("id", id).single();
  const profile = data as Profile | null;
  if (!profile) notFound();

  const displayName = profile.full_name ?? profile.email ?? "Unnamed";

  return (
    <div className="mx-auto max-w-3xl">
      <PageHeader title={displayName} description={profile.email ?? "Team member"} />

      <div className="mb-4">
        <span className="rounded-full bg-zinc-100 px-2.5 py-1 text-xs font-medium text-zinc-700 dark:bg-zinc-800 dark:text-zinc-200">
          Account user
        </span>
      </div>

      <div className="rounded-xl border border-zinc-200 bg-white p-5 dark:border-zinc-800 dark:bg-zinc-900">
        <h2 className="mb-3 text-sm font-semibold text-zinc-900 dark:text-zinc-50">Profile</h2>
        <dl className="space-y-2 text-sm">
          <Row label="Full name" value={profile.full_name ?? "—"} />
          <Row label="Email" value={profile.email ?? "—"} />
          <Row label="Role" value={ROLE_LABELS[profile.role]} />
          <Row label="Status" value={profile.is_active ? "Active" : "Inactive"} />
          <Row label="Member since" value={formatDate(profile.created_at)} />
        </dl>
      </div>
    </div>
  );
}
