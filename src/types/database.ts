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
