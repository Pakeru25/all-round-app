/**
 * Lightweight hand-written types for the rows the foundation touches today.
 * Once feature tables get their UIs, this can be replaced/augmented by the
 * Supabase type generator (`supabase gen types typescript`).
 */

export type Role = "owner" | "manager" | "staff" | "accountant";

export type PaymentMethod = "cash" | "transfer" | "card" | "credit";
export type PaymentStatus = "paid" | "partial" | "unpaid";

export interface Profile {
  id: string;
  organization_id: string;
  full_name: string | null;
  email: string | null;
  role: Role;
  avatar_url: string | null;
  is_active: boolean;
  created_at: string;
}

export interface Organization {
  id: string;
  name: string;
  currency: string;
  created_at: string;
}

export interface InventoryCategory {
  id: string;
  organization_id: string;
  name: string;
  description: string | null;
  created_at: string;
}

export interface InventoryItem {
  id: string;
  organization_id: string;
  category_id: string | null;
  name: string;
  sku: string | null;
  description: string | null;
  unit: string;
  quantity_in_stock: number;
  cost_price: number;
  selling_price: number;
  reorder_level: number;
  image_url: string | null;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

/** An inventory item joined with its category name (for list views). */
export interface InventoryItemWithCategory extends InventoryItem {
  inventory_categories: { name: string } | null;
}

export interface Customer {
  id: string;
  organization_id: string;
  name: string;
  email: string | null;
  phone: string | null;
  address: string | null;
  notes: string | null;
  created_at: string;
  updated_at: string;
}
