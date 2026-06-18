import "server-only";

import { createClient } from "@/lib/supabase/server";
import { navItemsForRole } from "@/lib/auth/roles";
import type { NavChild, NavSection } from "@/lib/auth/roles";
import { INVENTORY_TYPES } from "@/lib/inventory";
import { TIER_LABELS, TIER_ORDER, tierForSpend } from "@/lib/segments";
import type { InventoryType, Profile } from "@/types/database";

type ItemRow = {
  id: string;
  category_id: string | null;
  inventory_type: InventoryType;
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

  const [itemsRes, expCatsRes, custRes] = await Promise.all([
    supabase.from("inventory_items").select("id,category_id,inventory_type,quantity_in_stock,reorder_level"),
    supabase.from("expense_categories").select("id,name").order("name"),
    supabase.from("customer_stats").select("total_spent"),
  ]);

  const items = (itemsRes.data as ItemRow[] | null) ?? [];
  const expenseCats = (expCatsRes.data as { id: string; name: string }[] | null) ?? [];
  const customerStats = (custRes.data as { total_spent: number }[] | null) ?? [];

  // --- Inventory: per-type counts + low stock -------------------------------
  const countByType = new Map<InventoryType, number>();
  const lowByType = new Map<InventoryType, number>();
  let lowTotal = 0;
  for (const it of items) {
    countByType.set(it.inventory_type, (countByType.get(it.inventory_type) ?? 0) + 1);
    const isLow = it.reorder_level > 0 && Number(it.quantity_in_stock) <= it.reorder_level;
    if (isLow) {
      lowTotal += 1;
      lowByType.set(it.inventory_type, (lowByType.get(it.inventory_type) ?? 0) + 1);
    }
  }
  const inventoryChildren: NavChild[] = [
    { label: "All", href: "/inventory/all", count: items.length },
    ...INVENTORY_TYPES.map((t) => ({
      label: t.label,
      href: `/inventory/type/${t.slug}`,
      count: countByType.get(t.value) ?? 0,
      low: (lowByType.get(t.value) ?? 0) > 0,
    })),
    ...(lowTotal > 0 ? [{ label: "Low stock", href: "/inventory/low", count: lowTotal, low: true }] : []),
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
