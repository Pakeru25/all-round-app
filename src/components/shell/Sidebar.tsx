"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import {
  LayoutDashboard,
  Package,
  ShoppingCart,
  Truck,
  Wallet,
  Users,
  Factory,
  IdCard,
  ScrollText,
  BarChart3,
  Settings,
  type LucideIcon,
} from "lucide-react";
import { navItemsForRole, ROLE_LABELS, type Role } from "@/lib/auth/roles";

const ICONS: Record<string, LucideIcon> = {
  LayoutDashboard,
  Package,
  ShoppingCart,
  Truck,
  Wallet,
  Users,
  Factory,
  IdCard,
  ScrollText,
  BarChart3,
  Settings,
};

export function Sidebar({ role }: { role: Role }) {
  const pathname = usePathname();
  const items = navItemsForRole(role);

  return (
    <aside className="hidden w-60 shrink-0 flex-col border-r border-zinc-200 bg-white md:flex dark:border-zinc-800 dark:bg-zinc-900">
      <div className="flex h-14 items-center gap-2 border-b border-zinc-200 px-4 dark:border-zinc-800">
        <span className="text-base font-semibold tracking-tight text-zinc-900 dark:text-zinc-50">
          All Round App
        </span>
      </div>

      <nav className="flex-1 space-y-1 overflow-y-auto p-3">
        {items.map((item) => {
          const Icon = ICONS[item.icon] ?? LayoutDashboard;
          const active =
            pathname === item.href || pathname.startsWith(item.href + "/");
          return (
            <Link
              key={item.href}
              href={item.href}
              className={[
                "flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium transition",
                active
                  ? "bg-zinc-900 text-white dark:bg-zinc-50 dark:text-zinc-900"
                  : "text-zinc-600 hover:bg-zinc-100 dark:text-zinc-400 dark:hover:bg-zinc-800",
              ].join(" ")}
            >
              <Icon className="h-4 w-4" />
              {item.label}
            </Link>
          );
        })}
      </nav>

      <div className="border-t border-zinc-200 px-4 py-3 text-xs text-zinc-500 dark:border-zinc-800">
        Signed in as {ROLE_LABELS[role]}
      </div>
    </aside>
  );
}
