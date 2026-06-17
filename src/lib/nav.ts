import "server-only";

import { createClient } from "@/lib/supabase/server";
import { navItemsForRole } from "@/lib/auth/roles";
import type { NavChild, NavSection } from "@/lib/auth/roles";
import { TIER_LABELS, TIER_ORDER, tierForSpend } from "@/lib/segments";
import type { Profile } from "@/types/database";

type ItemRow = {
  id: string;
  category_id: string | null;
  quantity_in_stock: number;
  reorder_level: number;
};

/**
 * Builds the role-filtered sidebar tree, attaching live groupings + counts to
 * Inventory (by category + low stock), Expenses (by category) and Customers
 * (by value tier). All queries are RLS-scoped to the caller's organization.
 */
export async function getNavSections(profile: Profile): Promise<NavSection[]> {
  const base = navItemsForRole(profile.role);
  const supabase = await createClient();

  const [catsRes, itemsRes, expCatsRes, custRes] = await Promise.all([
    supabase.from("inventory_categories").select("id,name").order("name"),
    supabase.from("inventory_items").select("id,category_id,quantity_in_stock,reorder_level"),
    supabase.from("expense_categories").select("id,name").order("name"),
    supabase.from("customer_stats").select("total_spent"),
  ]);

  const categories = (catsRes.data as { id: string; name: string }[] | null) ?? [];
  const items = (itemsRes.data as ItemRow[] | null) ?? [];
  const expenseCats = (expCatsRes.data as { id: string; name: string }[] | null) ?? [];
  const customerStats = (custRes.data as { total_spent: number }[] | null) ?? [];

  // --- Inventory: per-category counts + low stock ---------------------------
  const countByCat = new Map<string, number>();
  const lowByCat = new Map<string, number>();
  let lowTotal = 0;
  for (const it of items) {
    if (it.category_id) countByCat.set(it.category_id, (countByCat.get(it.category_id) ?? 0) + 1);
    const isLow = it.reorder_level > 0 && Number(it.quantity_in_stock) <= it.reorder_level;
    if (isLow) {
      lowTotal += 1;
      if (it.category_id) lowByCat.set(it.category_id, (lowByCat.get(it.category_id) ?? 0) + 1);
    }
  }
  const inventoryChildren: NavChild[] = [
    { label: "All items", href: "/inventory", count: items.length },
    ...(lowTotal > 0 ? [{ label: "Low stock", href: "/inventory?filter=low", count: lowTotal, low: true }] : []),
    ...categories.map((c) => ({
      label: c.name,
      href: `/inventory?category=${c.id}`,
      count: countByCat.get(c.id) ?? 0,
      low: (lowByCat.get(c.id) ?? 0) > 0,
    })),
  ];

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
    if (item.href === "/inventory") {
      return { ...item, children: inventoryChildren, badge: lowTotal || undefined };
    }
    if (item.href === "/expenses") return { ...item, children: expenseChildren };
    if (item.href === "/customers") return { ...item, children: customerChildren };
    return { ...item };
  });
}
