/**
 * One mapper per entity: turn a raw CSV row into a clean insert payload. This is
 * the file to tweak once the real sheet headers are known — each `pick(...)`
 * lists the header names we accept, so adding an alias is a one-line change.
 *
 * Mappers stay pure (no DB access). Foreign keys that need a lookup (category,
 * customer, supplier, item) are returned here as *names* and resolved to IDs in
 * index.ts, where the lookup maps live.
 */
import { pick, type Row } from "./csv";

/* ----------------------------- value coercion ----------------------------- */

/** Parse a money/number cell, tolerating "GH₵1,200.50", spaces, blanks. */
export function num(value: string): number {
  const cleaned = value.replace(/[^0-9.\-]/g, "");
  const n = Number(cleaned);
  return Number.isFinite(n) && cleaned !== "" ? n : 0;
}

/** Parse a whole-number cell (e.g. reorder level, quantity). */
export function intOrZero(value: string): number {
  const n = parseInt(value.replace(/[^0-9\-]/g, ""), 10);
  return Number.isFinite(n) ? n : 0;
}

export function orNull(value: string): string | null {
  return value === "" ? null : value;
}

/**
 * Normalize a date cell to YYYY-MM-DD. Accepts ISO dates directly; otherwise
 * falls back to JS Date parsing, and to "today" if unparseable. NOTE: ambiguous
 * DD/MM vs MM/DD ordering follows JS Date (US-style) — see README if your sheet
 * uses day-first dates.
 */
export function toDate(value: string): string {
  if (!value) return today();
  const iso = /^(\d{4})-(\d{2})-(\d{2})/.exec(value);
  if (iso) return `${iso[1]}-${iso[2]}-${iso[3]}`;
  const d = new Date(value);
  return Number.isNaN(d.getTime()) ? today() : d.toISOString().slice(0, 10);
}

function today(): string {
  return new Date().toISOString().slice(0, 10);
}

export type PaymentMethod = "cash" | "transfer" | "card" | "credit";
export type PaymentStatus = "paid" | "partial" | "unpaid";

export function paymentMethod(value: string): PaymentMethod {
  const v = value.toLowerCase();
  return v === "transfer" || v === "card" || v === "credit" ? v : "cash";
}

export function paymentStatus(value: string): PaymentStatus {
  const v = value.toLowerCase();
  return v === "partial" || v === "unpaid" ? v : "paid";
}

/* ------------------------------- customers -------------------------------- */

export interface CustomerInput {
  name: string;
  email: string | null;
  phone: string | null;
  address: string | null;
  notes: string | null;
  preferences: string | null;
}

export function mapCustomer(row: Row): CustomerInput {
  return {
    name: pick(row, "name", "customer", "customer name", "full name"),
    email: orNull(pick(row, "email", "e-mail")),
    phone: orNull(pick(row, "phone", "phone number", "tel", "mobile", "contact")),
    address: orNull(pick(row, "address", "location")),
    notes: orNull(pick(row, "notes", "note", "comments")),
    preferences: orNull(pick(row, "preferences", "prefs")),
  };
}

/* ------------------------------- suppliers -------------------------------- */

export interface SupplierInput {
  name: string;
  contact_person: string | null;
  email: string | null;
  phone: string | null;
  address: string | null;
  notes: string | null;
}

export function mapSupplier(row: Row): SupplierInput {
  return {
    name: pick(row, "name", "supplier", "supplier name", "vendor"),
    contact_person: orNull(pick(row, "contact person", "contact", "contact name")),
    email: orNull(pick(row, "email", "e-mail")),
    phone: orNull(pick(row, "phone", "phone number", "tel", "mobile")),
    address: orNull(pick(row, "address", "location")),
    notes: orNull(pick(row, "notes", "note", "comments")),
  };
}

/* ------------------------------- employees -------------------------------- */

export interface EmployeeInput {
  full_name: string;
  position: string | null;
  phone: string | null;
  email: string | null;
  salary: number | null;
  hire_date: string | null;
  notes: string | null;
}

export function mapEmployee(row: Row): EmployeeInput {
  const salary = pick(row, "salary", "pay", "wage");
  const hire = pick(row, "hire date", "hired", "start date", "date joined");
  return {
    full_name: pick(row, "full name", "name", "employee", "employee name"),
    position: orNull(pick(row, "position", "role", "title", "job title")),
    phone: orNull(pick(row, "phone", "phone number", "tel", "mobile")),
    email: orNull(pick(row, "email", "e-mail")),
    salary: salary === "" ? null : num(salary),
    hire_date: hire === "" ? null : toDate(hire),
    notes: orNull(pick(row, "notes", "note", "comments")),
  };
}

/* ----------------------------- inventory items ---------------------------- */

export interface ItemInput {
  name: string;
  sku: string | null;
  description: string | null;
  categoryName: string;
  unit: string;
  quantity_in_stock: number;
  cost_price: number;
  selling_price: number;
  reorder_level: number;
}

export function mapItem(row: Row): ItemInput {
  return {
    name: pick(row, "name", "item", "item name", "product", "product name"),
    sku: orNull(pick(row, "sku", "code", "item code", "product code")),
    description: orNull(pick(row, "description", "desc")),
    categoryName: pick(row, "category", "category name", "type"),
    unit: pick(row, "unit", "uom") || "pieces",
    // The sheet's CURRENT stock — set directly (triggers are disabled during the
    // historical load, so this value is authoritative and not double-adjusted).
    quantity_in_stock: num(pick(row, "quantity in stock", "quantity", "qty", "stock", "in stock")),
    cost_price: num(pick(row, "cost price", "cost", "buy price", "purchase price")),
    selling_price: num(pick(row, "selling price", "price", "sell price", "unit price")),
    reorder_level: intOrZero(pick(row, "reorder level", "reorder", "min stock", "reorder point")),
  };
}

/* -------------------------------- expenses -------------------------------- */

export interface ExpenseInput {
  categoryName: string;
  amount: number;
  description: string | null;
  expense_date: string;
  expense_number: string | null;
}

export function mapExpense(row: Row): ExpenseInput {
  return {
    categoryName: pick(row, "category", "category name", "type"),
    amount: num(pick(row, "amount", "cost", "total", "value")),
    description: orNull(pick(row, "description", "desc", "details", "notes", "item")),
    expense_date: toDate(pick(row, "date", "expense date", "expense_date")),
    expense_number: orNull(pick(row, "expense number", "expense_number", "number", "ref", "reference")),
  };
}

/* ------------------------- sales / purchases (lines) ----------------------- */
// Sheets typically keep ONE ROW PER LINE ITEM, sharing an invoice number. The
// runner groups rows by their number (or treats each numberless row as its own
// single-line transaction). Header-level fields (date, customer, payment...) are
// read from the first row of each group.

export interface SaleLineInput {
  number: string | null;
  date: string;
  customerName: string;
  paymentMethod: PaymentMethod;
  paymentStatus: PaymentStatus;
  discount: number;
  notes: string | null;
  itemName: string;
  sku: string;
  quantity: number;
  unitPrice: number;
  lineTotal: number;
}

export function mapSaleLine(row: Row): SaleLineInput {
  const qty = num(pick(row, "quantity", "qty", "units"));
  const unitPrice = num(pick(row, "unit price", "price", "selling price", "rate"));
  const lineTotalRaw = pick(row, "total", "line total", "amount", "subtotal");
  return {
    number: orNull(pick(row, "sale number", "sale_number", "invoice", "invoice number", "receipt", "number")),
    date: toDate(pick(row, "date", "sale date", "sale_date")),
    customerName: pick(row, "customer", "customer name", "client", "name"),
    paymentMethod: paymentMethod(pick(row, "payment method", "payment", "method")),
    paymentStatus: paymentStatus(pick(row, "payment status", "status")),
    discount: num(pick(row, "discount")),
    notes: orNull(pick(row, "notes", "note", "comments")),
    itemName: pick(row, "item", "item name", "product", "product name", "description"),
    sku: pick(row, "sku", "code", "item code", "product code"),
    quantity: qty,
    unitPrice,
    lineTotal: lineTotalRaw === "" ? qty * unitPrice : num(lineTotalRaw),
  };
}

export interface PurchaseLineInput {
  number: string | null;
  date: string;
  supplierName: string;
  paymentMethod: PaymentMethod;
  paymentStatus: PaymentStatus;
  notes: string | null;
  itemName: string;
  sku: string;
  quantity: number;
  unitCost: number;
  lineTotal: number;
}

export function mapPurchaseLine(row: Row): PurchaseLineInput {
  const qty = num(pick(row, "quantity", "qty", "units"));
  const unitCost = num(pick(row, "unit cost", "cost", "cost price", "rate", "price"));
  const lineTotalRaw = pick(row, "total", "line total", "amount", "subtotal");
  return {
    number: orNull(pick(row, "purchase number", "purchase_number", "invoice", "invoice number", "number", "ref")),
    date: toDate(pick(row, "date", "purchase date", "purchase_date")),
    supplierName: pick(row, "supplier", "supplier name", "vendor", "name"),
    paymentMethod: paymentMethod(pick(row, "payment method", "payment", "method")),
    paymentStatus: paymentStatus(pick(row, "payment status", "status")),
    notes: orNull(pick(row, "notes", "note", "comments")),
    itemName: pick(row, "item", "item name", "product", "product name", "description"),
    sku: pick(row, "sku", "code", "item code", "product code"),
    quantity: qty,
    unitCost,
    lineTotal: lineTotalRaw === "" ? qty * unitCost : num(lineTotalRaw),
  };
}
