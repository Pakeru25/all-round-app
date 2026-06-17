import type { Role } from "@/types/database";

export type { Role } from "@/types/database";

/**
 * Client-safe role data: labels, the navigation map, and the per-role filter.
 * No server-only imports here so Client Components (e.g. the Sidebar) can use it.
 * Server-only session helpers live in ./session.
 */

export const ALL_ROLES: Role[] = ["owner", "manager", "staff", "accountant"];

export const ROLE_LABELS: Record<Role, string> = {
  owner: "Owner",
  manager: "Manager",
  staff: "Staff",
  accountant: "Accountant",
};

/** A single sidebar entry plus the roles allowed to see it (matches the approved matrix). */
export interface NavItem {
  href: string;
  label: string;
  /** lucide-react icon name, resolved in the Sidebar component. */
  icon: string;
  roles: Role[];
}

export const NAV_ITEMS: NavItem[] = [
  { href: "/dashboard", label: "Dashboard", icon: "LayoutDashboard", roles: ALL_ROLES },
  { href: "/inventory", label: "Inventory", icon: "Package", roles: ["owner", "manager", "staff"] },
  { href: "/sales", label: "Sales", icon: "ShoppingCart", roles: ["owner", "manager", "staff"] },
  { href: "/purchases", label: "Purchases", icon: "Truck", roles: ["owner", "manager"] },
  { href: "/expenses", label: "Expenses", icon: "Wallet", roles: ["owner", "manager", "accountant"] },
  { href: "/customers", label: "Customers", icon: "Users", roles: ["owner", "manager", "staff"] },
  { href: "/suppliers", label: "Suppliers", icon: "Factory", roles: ["owner", "manager"] },
  { href: "/employees", label: "Employees", icon: "IdCard", roles: ["owner"] },
  { href: "/activity", label: "Activity Log", icon: "ScrollText", roles: ["owner", "manager"] },
  { href: "/reports", label: "Reports", icon: "BarChart3", roles: ["owner", "manager", "accountant"] },
  { href: "/settings", label: "Settings", icon: "Settings", roles: ["owner"] },
];

export function navItemsForRole(role: Role): NavItem[] {
  return NAV_ITEMS.filter((item) => item.roles.includes(role));
}

/** A dynamic child entry under a nav section (e.g. an inventory group or category). */
export interface NavChild {
  label: string;
  href: string;
  count?: number;
  /** show a low-stock dot next to this child */
  low?: boolean;
  /** nested entries (e.g. the categories under an inventory group) */
  children?: NavChild[];
}

/** A top-level nav section, optionally with dynamic children + a badge. */
export interface NavSection extends NavItem {
  /** e.g. low-stock count shown on the Inventory parent */
  badge?: number;
  children?: NavChild[];
}
