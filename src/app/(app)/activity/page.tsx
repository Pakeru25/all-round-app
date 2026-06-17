import { PageHeader } from "@/components/ui/PageHeader";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import { formatDateTime } from "@/lib/format";
import type { ActivityLogEntry } from "@/types/database";

const ACTION_STYLES: Record<string, string> = {
  created: "bg-emerald-100 text-emerald-700 dark:bg-emerald-950 dark:text-emerald-300",
  updated: "bg-amber-100 text-amber-700 dark:bg-amber-950 dark:text-amber-300",
  deleted: "bg-red-100 text-red-700 dark:bg-red-950 dark:text-red-300",
};

export default async function ActivityPage() {
  await requireRole(["owner", "manager"]);

  const supabase = await createClient();
  const { data } = await supabase
    .from("activity_log")
    .select("*")
    .order("created_at", { ascending: false })
    .limit(100);
  const entries = (data as ActivityLogEntry[] | null) ?? [];

  return (
    <div className="mx-auto max-w-4xl">
      <PageHeader
        title="Activity Log"
        description="Every action by every user, newest first. This trail is permanent — it can't be edited or deleted."
      />

      {entries.length === 0 ? (
        <div className="rounded-xl border border-dashed border-zinc-300 bg-white p-10 text-center text-sm text-zinc-500 dark:border-zinc-700 dark:bg-zinc-900">
          No activity recorded yet. Logging a sale, purchase or expense will appear here.
        </div>
      ) : (
        <ol className="overflow-hidden rounded-xl border border-zinc-200 bg-white dark:border-zinc-800 dark:bg-zinc-900">
          {entries.map((entry) => (
            <li
              key={entry.id}
              className="flex items-start gap-3 border-b border-zinc-100 px-4 py-3 last:border-b-0 dark:border-zinc-800"
            >
              <span
                className={`mt-0.5 rounded-full px-2 py-0.5 text-xs font-medium ${
                  ACTION_STYLES[entry.action] ?? "bg-zinc-100 text-zinc-600"
                }`}
              >
                {entry.action}
              </span>
              <div className="flex-1">
                <p className="text-sm text-zinc-800 dark:text-zinc-200">{entry.description}</p>
                <p className="text-xs text-zinc-400">
                  {entry.entity_type} · {formatDateTime(entry.created_at)}
                </p>
              </div>
            </li>
          ))}
        </ol>
      )}
    </div>
  );
}
