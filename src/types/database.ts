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
  preferences: string | null;
  created_at: string;
  updated_at: string;
}

/** A customer row enriched with live figures from the `customer_stats` view. */
export interface CustomerStats extends Customer {
  total_spent: number;
  order_count: number;
  last_purchase: string | null;
  first_purchase: string | null;
}

export type EmployeeStatus = "active" | "inactive";

export interface Employee {
  id: string;
  organization_id: string;
  full_name: string;
  position: string | null;
  phone: string | null;
  email: string | null;
  salary: number | null;
  hire_date: string | null;
  status: EmployeeStatus;
  linked_user_id: string | null;
  notes: string | null;
  created_at: string;
  updated_at: string;
}

export interface ExpenseCategory {
  id: string;
  organization_id: string;
  name: string;
  created_at: string;
}

export interface Expense {
  id: string;
  organization_id: string;
  category_id: string | null;
  recorded_by: string | null;
  expense_number: string | null;
  amount: number;
  description: string | null;
  expense_date: string;
  receipt_url: string | null;
  created_at: string;
}

/** An expense joined with its category name (for list views). */
export interface ExpenseWithCategory extends Expense {
  expense_categories: { name: string } | null;
}

export interface Sale {
  id: string;
  organization_id: string;
  customer_id: string | null;
  recorded_by: string | null;
  sale_number: string | null;
  sale_date: string;
  subtotal: number;
  discount: number;
  total_amount: number;
  payment_method: PaymentMethod;
  payment_status: PaymentStatus;
  notes: string | null;
  created_at: string;
}

export interface SaleItem {
  id: string;
  sale_id: string;
  inventory_item_id: string;
  quantity: number;
  unit_price: number;
  total_price: number;
}

export interface Purchase {
  id: string;
  organization_id: string;
  supplier_id: string | null;
  recorded_by: string | null;
  purchase_number: string | null;
  purchase_date: string;
  total_amount: number;
  payment_method: PaymentMethod;
  payment_status: PaymentStatus;
  notes: string | null;
  created_at: string;
}

export interface PurchaseItem {
  id: string;
  purchase_id: string;
  inventory_item_id: string;
  quantity: number;
  unit_cost: number;
  total_cost: number;
}

export type ActivityAction = "created" | "updated" | "deleted";

export interface ActivityLogEntry {
  id: string;
  organization_id: string;
  user_id: string | null;
  action: ActivityAction;
  entity_type: string;
  entity_id: string | null;
  description: string;
  metadata: Record<string, unknown>;
  created_at: string;
}

export type NotificationType =
  | "sale_created"
  | "expense_logged"
  | "purchase_created"
  | "inventory_low"
  | "inventory_adjusted";

export interface AppNotification {
  id: string;
  organization_id: string;
  recipient_id: string;
  triggered_by: string | null;
  type: NotificationType;
  title: string;
  message: string;
  entity_type: string | null;
  entity_id: string | null;
  is_read: boolean;
  created_at: string;
}
