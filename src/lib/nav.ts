import "server-only";

import { createClient } from "@/lib/supabase/server";
import { navItemsForRole } from "@/lib/auth/roles";
import type { NavChild, NavSection } from "@/lib/auth/roles";
import { TIER_LABELS, TIER_ORDER, tierForSpend } from "@/lib/segments";
import type { Profile } from "@/types/database";

/**
 * Builds the role-filtered sidebar tree, attaching live groupings + counts to
 * Expenses (by category) and Customers (by value tier). Inventory is a plain
 * link — its type → category → product browse lives on the Inventory page
 * itself. All queries are RLS-scoped to the caller's organization.
 */
export async function getNavSections(profile: Profile): Promise<NavSection[]> {
  const base = navItemsForRole(profile.role);
  const supabase = await createClient();

  const [expCatsRes, custRes] = await Promise.all([
    supabase.from("expense_categories").select("id,name").order("name"),
    supabase.from("customer_stats").select("total_spent"),
  ]);

  const expenseCats = (expCatsRes.data as { id: string; name: string }[] | null) ?? [];
  const customerStats = (custRes.data as { total_spent: number }[] | null) ?? [];

  // --- Expenses: by category ------------------------------------------------
  const expenseChildren: NavChild[] = [
    { label: "All", href: "/expenses" },
    ...expenseCats.map((c) => ({ label: c.name, href: `/expenses?category=${c.id}` })),
  ];

  // --- Customers: by value tier --------------------------------------------
  const tierCounts = new Map<string, number>();
  for (const cs of customerStats) {
    const t = tierForSpend(Number(cs.total_spent) || 0);
    tierCounts.set(t, (tierCounts.get(t) ?? 0) + 1);
  }
  const customerChildren: NavChild[] = [
    { label: "All", href: "/customers", count: customerStats.length },
    ...TIER_ORDER.map((t) => ({
      label: TIER_LABELS[t],
      href: `/customers?tier=${t}`,
      count: tierCounts.get(t) ?? 0,
    })),
  ];

  return base.map((item): NavSection => {
    if (item.href === "/expenses") return { ...item, children: expenseChildren };
    if (item.href === "/customers") return { ...item, children: customerChildren };
    return { ...item };
  });
}
