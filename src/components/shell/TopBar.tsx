import Link from "next/link";
import { Bell, Search } from "lucide-react";
import { ROLE_LABELS, type Role } from "@/lib/auth/roles";

export function TopBar({
  orgName,
  fullName,
  role,
  unreadCount,
}: {
  orgName: string;
  fullName: string;
  role: Role;
  unreadCount: number;
}) {
  return (
    <header className="flex h-14 shrink-0 items-center gap-4 border-b border-zinc-200 bg-white px-4 dark:border-zinc-800 dark:bg-zinc-900">
      <div className="text-sm font-medium text-zinc-500 md:hidden">{orgName}</div>

      <div className="relative hidden flex-1 sm:block">
        <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-zinc-400" />
        <input
          type="search"
          disabled
          placeholder="Search (coming soon)"
          className="w-full max-w-md rounded-md border border-zinc-200 bg-zinc-50 py-2 pl-9 pr-3 text-sm text-zinc-500 outline-none dark:border-zinc-800 dark:bg-zinc-950"
        />
      </div>

      <div className="ml-auto flex items-center gap-4">
        <Link
          href="/notifications"
          aria-label="Notifications"
          className="relative rounded-md p-2 text-zinc-500 hover:bg-zinc-100 dark:hover:bg-zinc-800"
        >
          <Bell className="h-5 w-5" />
          {unreadCount > 0 ? (
            <span className="absolute -right-0.5 -top-0.5 flex h-4 min-w-4 items-center justify-center rounded-full bg-red-600 px-1 text-[10px] font-semibold text-white">
              {unreadCount > 9 ? "9+" : unreadCount}
            </span>
          ) : null}
        </Link>

        <div className="flex items-center gap-3">
          <div className="text-right leading-tight">
            <div className="text-sm font-medium text-zinc-900 dark:text-zinc-50">
              {fullName}
            </div>
            <div className="text-xs text-zinc-500">{ROLE_LABELS[role]}</div>
          </div>
          <form action="/auth/signout" method="post">
            <button
              type="submit"
              className="rounded-md border border-zinc-200 px-3 py-1.5 text-sm text-zinc-700 transition hover:bg-zinc-100 dark:border-zinc-700 dark:text-zinc-300 dark:hover:bg-zinc-800"
            >
              Sign out
            </button>
          </form>
        </div>
      </div>
    </header>
  );
}
