"use client";

import Link from "next/link";
import { usePathname, useSearchParams } from "next/navigation";
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
  ChevronDown,
  type LucideIcon,
} from "lucide-react";
import { ROLE_LABELS, type NavSection, type Role } from "@/lib/auth/roles";

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

function rowClass(active: boolean) {
  return [
    "flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium transition",
    active
      ? "bg-zinc-900 text-white dark:bg-zinc-50 dark:text-zinc-900"
      : "text-zinc-600 hover:bg-zinc-100 dark:text-zinc-400 dark:hover:bg-zinc-800",
  ].join(" ");
}

function childClass(active: boolean) {
  return [
    "flex items-center gap-2 rounded-md px-3 py-1.5 text-sm transition",
    active
      ? "bg-zinc-100 font-medium text-zinc-900 dark:bg-zinc-800 dark:text-zinc-50"
      : "text-zinc-500 hover:bg-zinc-100 hover:text-zinc-800 dark:text-zinc-400 dark:hover:bg-zinc-800",
  ].join(" ");
}

export function Sidebar({ role, sections }: { role: Role; sections: NavSection[] }) {
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const currentQuery = searchParams.toString();

  const sectionActive = (href: string) => pathname === href || pathname.startsWith(href + "/");
  const childActive = (href: string) => {
    const [path, query] = href.split("?");
    if (pathname !== path) return false;
    if (!query) return currentQuery === ""; // the "All" entry
    const params = new URLSearchParams(query);
    for (const [k, v] of params) if (searchParams.get(k) !== v) return false;
    return true;
  };

  return (
    <aside className="hidden w-64 shrink-0 flex-col border-r border-zinc-200 bg-white md:flex dark:border-zinc-800 dark:bg-zinc-900">
      <div className="flex h-14 items-center gap-2 border-b border-zinc-200 px-4 dark:border-zinc-800">
        <span className="text-base font-semibold tracking-tight text-zinc-900 dark:text-zinc-50">
          All Round App
        </span>
      </div>

      <nav className="flex-1 space-y-1 overflow-y-auto p-3">
        {sections.map((section) => {
          const Icon = ICONS[section.icon] ?? LayoutDashboard;
          const active = sectionActive(section.href);
          const hasChildren = !!section.children && section.children.length > 0;

          if (!hasChildren) {
            return (
              <Link key={section.href} href={section.href} className={rowClass(active)}>
                <Icon className="h-4 w-4 shrink-0" />
                <span className="flex-1">{section.label}</span>
              </Link>
            );
          }

          return (
            <div key={section.href} className="group">
              <div className={rowClass(active)}>
                <Link href={section.href} className="flex flex-1 items-center gap-3">
                  <Icon className="h-4 w-4 shrink-0" />
                  <span className="flex-1">{section.label}</span>
                </Link>
                {section.badge ? (
                  <span className="rounded-full bg-red-600 px-1.5 text-[10px] font-semibold text-white">
                    {section.badge}
                  </span>
                ) : null}
                <ChevronDown className="h-4 w-4 shrink-0 text-zinc-400 transition-transform md:group-hover:rotate-180" />
              </div>

              {/* Children reveal solely on hover (desktop); they collapse when not hovered. */}
              <ul className="hidden md:group-hover:block mt-1 space-y-0.5 pl-9 pr-1">
                {section.children!.map((child) => (
                  <li key={child.href}>
                    <Link href={child.href} className={childClass(childActive(child.href))}>
                      {child.low ? <span className="h-1.5 w-1.5 shrink-0 rounded-full bg-red-500" /> : null}
                      <span className="flex-1 truncate">{child.label}</span>
                      {typeof child.count === "number" ? (
                        <span className="text-xs text-zinc-400">{child.count}</span>
                      ) : null}
                    </Link>
                  </li>
                ))}
              </ul>
            </div>
          );
        })}
      </nav>

      <div className="border-t border-zinc-200 px-4 py-3 text-xs text-zinc-500 dark:border-zinc-800">
        Signed in as {ROLE_LABELS[role]}
      </div>
    </aside>
  );
}
