import { PageHeader } from "@/components/ui/PageHeader";
import { SubmitButton } from "@/components/ui/SubmitButton";
import { createClient } from "@/lib/supabase/server";
import { formatDateTime } from "@/lib/format";
import type { AppNotification } from "@/types/database";
import { markAllRead } from "./actions";

export default async function NotificationsPage() {
  const supabase = await createClient();
  // RLS already restricts these to the signed-in recipient.
  const { data } = await supabase
    .from("notifications")
    .select("*")
    .order("created_at", { ascending: false })
    .limit(100);
  const notifications = (data as AppNotification[] | null) ?? [];
  const hasUnread = notifications.some((n) => !n.is_read);

  return (
    <div className="mx-auto max-w-3xl">
      <div className="flex items-start justify-between gap-4">
        <PageHeader title="Notifications" description="Alerts for sales, purchases, expenses and low stock." />
        {hasUnread ? (
          <form action={markAllRead}>
            <SubmitButton>Mark all as read</SubmitButton>
          </form>
        ) : null}
      </div>

      {notifications.length === 0 ? (
        <div className="rounded-xl border border-dashed border-zinc-300 bg-white p-10 text-center text-sm text-zinc-500 dark:border-zinc-700 dark:bg-zinc-900">
          No notifications yet.
        </div>
      ) : (
        <ol className="overflow-hidden rounded-xl border border-zinc-200 bg-white dark:border-zinc-800 dark:bg-zinc-900">
          {notifications.map((n) => (
            <li
              key={n.id}
              className={`border-b border-zinc-100 px-4 py-3 last:border-b-0 dark:border-zinc-800 ${
                n.is_read ? "" : "bg-zinc-50 dark:bg-zinc-800/40"
              }`}
            >
              <div className="flex items-center gap-2">
                {n.is_read ? null : <span className="h-2 w-2 shrink-0 rounded-full bg-zinc-900 dark:bg-zinc-100" />}
                <p className="text-sm font-medium text-zinc-900 dark:text-zinc-50">{n.title}</p>
              </div>
              <p className="mt-0.5 text-sm text-zinc-600 dark:text-zinc-400">{n.message}</p>
              <p className="mt-0.5 text-xs text-zinc-400">{formatDateTime(n.created_at)}</p>
            </li>
          ))}
        </ol>
      )}
    </div>
  );
}
