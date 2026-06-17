/**
 * One-time migration: load exported Google Sheets CSVs into the All Round App
 * Supabase database, each record routed to the right table.
 *
 *   npm run migrate -- --dry-run     # map + validate everything, write nothing
 *   npm run migrate                  # perform the load
 *
 * Put your exported sheet tabs in scripts/migrate/data/ as:
 *   customers.csv  suppliers.csv  employees.csv  inventory.csv
 *   expenses.csv   sales.csv      purchases.csv
 * (Any file you omit is simply skipped.) See scripts/migrate/README.md.
 *
 * Run order respects foreign keys, and the side-effect triggers on
 * sales/purchases/expenses are disabled for the transactional load so historical
 * data doesn't corrupt current stock or spam owner notifications.
 */
import type { SupabaseClient } from "@supabase/supabase-js";
import { createServiceClient } from "./client";
import { readCsv, type Row } from "./csv";
import {
  mapCustomer,
  mapSupplier,
  mapEmployee,
  mapItem,
  mapExpense,
  mapSaleLine,
  mapPurchaseLine,
  type SaleLineInput,
  type PurchaseLineInput,
} from "./mappers";

const DRY_RUN = process.argv.includes("--dry-run");

/** Accepted file names per sheet (matched case-insensitively; first found wins). */
const FILES = {
  customers: ["customers", "customer"],
  suppliers: ["suppliers", "supplier"],
  employees: ["employees", "employee", "staff"],
  inventory: ["inventory", "products", "items"], // NB: prices.csv is intentionally excluded
  expenses: ["expenses", "expense"],
  sales: ["sales"],
  purchases: ["purchases", "purchase"],
};

/** A case-insensitive name→id lookup. */
class NameMap {
  private readonly byKey = new Map<string, string>();
  set(name: string | null | undefined, id: string): void {
    if (name) this.byKey.set(name.trim().toLowerCase(), id);
  }
  get(name: string | null | undefined): string | null {
    if (!name) return null;
    return this.byKey.get(name.trim().toLowerCase()) ?? null;
  }
  get size(): number {
    return this.byKey.size;
  }
}

const warnings: string[] = [];
function warn(message: string): void {
  warnings.push(message);
}

async function main(): Promise<void> {
  const supabase = createServiceClient();

  console.log(DRY_RUN ? "DRY RUN — no data will be written.\n" : "Live import.\n");

  const orgId = await resolveOrgId(supabase);
  const recordedBy = await resolveOwnerId(supabase);
  console.log(`Organization: ${orgId}`);
  console.log(`recorded_by:  ${recordedBy ?? "(null)"}\n`);

  // Lookup maps, seeded with whatever already exists in the DB.
  const invCategories = await loadCategoryMap(supabase, "inventory_categories", orgId);
  const expCategories = await loadCategoryMap(supabase, "expense_categories", orgId);
  const customers = await loadNameMap(supabase, "customers", orgId);
  const suppliers = await loadNameMap(supabase, "suppliers", orgId);
  const items = new NameMap(); // by name
  const itemsBySku = new NameMap(); // by sku
  await loadItemMaps(supabase, orgId, items, itemsBySku);

  // ---- Independent entities -------------------------------------------------
  await importCustomers(supabase, orgId, customers);
  await importSuppliers(supabase, orgId, suppliers);
  await importEmployees(supabase, orgId);
  await importItems(supabase, orgId, invCategories, items, itemsBySku);
  await importItemsFromSales(supabase, orgId, items, itemsBySku);

  // ---- Transactions (triggers off for the bulk historical load) -------------
  const hasTransactions =
    readCsv(FILES.expenses).length || readCsv(FILES.sales).length || readCsv(FILES.purchases).length;

  if (hasTransactions && !DRY_RUN) await setTriggers(supabase, false);
  try {
    await importExpenses(supabase, orgId, recordedBy, expCategories);
    await importSales(supabase, orgId, recordedBy, customers, items, itemsBySku);
    await importPurchases(supabase, orgId, recordedBy, suppliers, items, itemsBySku);
  } finally {
    if (hasTransactions && !DRY_RUN) await setTriggers(supabase, true);
  }

  if (warnings.length) {
    console.log(`\n⚠️  ${warnings.length} warning(s):`);
    for (const w of warnings.slice(0, 50)) console.log(`   - ${w}`);
    if (warnings.length > 50) console.log(`   …and ${warnings.length - 50} more.`);
  }
  console.log(DRY_RUN ? "\nDry run complete." : "\nImport complete.");
}

/* ----------------------------- org / owner -------------------------------- */

async function resolveOrgId(supabase: SupabaseClient): Promise<string> {
  if (process.env.ORG_ID) return process.env.ORG_ID;
  const { data, error } = await supabase
    .from("organizations")
    .select("id")
    .order("created_at", { ascending: true })
    .limit(1)
    .maybeSingle();
  if (error) throw error;
  if (!data) throw new Error("No organization found. Run supabase/schema.sql first.");
  return data.id as string;
}

/** Optional: attribute imported records to a specific owner (set OWNER_EMAIL). */
async function resolveOwnerId(supabase: SupabaseClient): Promise<string | null> {
  const email = process.env.OWNER_EMAIL;
  if (!email) return null;
  const { data } = await supabase.from("profiles").select("id").eq("email", email).maybeSingle();
  if (!data) {
    warn(`OWNER_EMAIL ${email} not found in profiles; recording with null.`);
    return null;
  }
  return data.id as string;
}

/* ------------------------------ lookup maps ------------------------------- */

async function loadCategoryMap(
  supabase: SupabaseClient,
  table: string,
  orgId: string,
): Promise<NameMap> {
  const map = new NameMap();
  const { data } = await supabase.from(table).select("id, name").eq("organization_id", orgId);
  for (const row of data ?? []) map.set(row.name as string, row.id as string);
  return map;
}

async function loadNameMap(
  supabase: SupabaseClient,
  table: string,
  orgId: string,
): Promise<NameMap> {
  const map = new NameMap();
  const { data } = await supabase.from(table).select("id, name").eq("organization_id", orgId);
  for (const row of data ?? []) map.set(row.name as string, row.id as string);
  return map;
}

async function loadItemMaps(
  supabase: SupabaseClient,
  orgId: string,
  byName: NameMap,
  bySku: NameMap,
): Promise<void> {
  const { data } = await supabase
    .from("inventory_items")
    .select("id, name, sku")
    .eq("organization_id", orgId);
  for (const row of data ?? []) {
    byName.set(row.name as string, row.id as string);
    if (row.sku) bySku.set(row.sku as string, row.id as string);
  }
}

/** Find an existing category by name, else create it (live only). */
async function ensureCategory(
  supabase: SupabaseClient,
  table: string,
  orgId: string,
  name: string,
  map: NameMap,
): Promise<string | null> {
  if (!name) return null;
  const existing = map.get(name);
  if (existing) return existing;
  if (DRY_RUN) {
    map.set(name, "(new)");
    return null;
  }
  const { data, error } = await supabase
    .from(table)
    .insert({ organization_id: orgId, name })
    .select("id")
    .single();
  if (error) {
    warn(`Could not create category "${name}" in ${table}: ${error.message}`);
    return null;
  }
  map.set(name, data.id as string);
  return data.id as string;
}

/* ------------------------------- importers -------------------------------- */

async function importCustomers(
  supabase: SupabaseClient,
  orgId: string,
  customers: NameMap,
): Promise<void> {
  const rows = readCsv(FILES.customers);
  let created = 0;
  for (const row of rows) {
    const input = mapCustomer(row);
    if (!input.name) {
      warn("customers: skipped a row with no name.");
      continue;
    }
    if (customers.get(input.name)) continue; // idempotent: already present
    if (DRY_RUN) {
      customers.set(input.name, "(new)");
      created++;
      continue;
    }
    const { data, error } = await supabase
      .from("customers")
      .insert({ organization_id: orgId, ...input })
      .select("id")
      .single();
    if (error) {
      warn(`customers "${input.name}": ${error.message}`);
      continue;
    }
    customers.set(input.name, data.id as string);
    created++;
  }
  report("customers", rows.length, created);
}

async function importSuppliers(
  supabase: SupabaseClient,
  orgId: string,
  suppliers: NameMap,
): Promise<void> {
  const rows = readCsv(FILES.suppliers);
  let created = 0;
  for (const row of rows) {
    const input = mapSupplier(row);
    if (!input.name) {
      warn("suppliers: skipped a row with no name.");
      continue;
    }
    if (suppliers.get(input.name)) continue;
    if (DRY_RUN) {
      suppliers.set(input.name, "(new)");
      created++;
      continue;
    }
    const { data, error } = await supabase
      .from("suppliers")
      .insert({ organization_id: orgId, ...input })
      .select("id")
      .single();
    if (error) {
      warn(`suppliers "${input.name}": ${error.message}`);
      continue;
    }
    suppliers.set(input.name, data.id as string);
    created++;
  }
  report("suppliers", rows.length, created);
}

async function importEmployees(supabase: SupabaseClient, orgId: string): Promise<void> {
  const rows = readCsv(FILES.employees);
  let created = 0;
  const seen = new Set<string>();
  for (const row of rows) {
    const input = mapEmployee(row);
    if (!input.full_name) {
      warn("employees: skipped a row with no name.");
      continue;
    }
    const key = input.full_name.toLowerCase();
    if (seen.has(key)) continue;
    seen.add(key);
    if (DRY_RUN) {
      created++;
      continue;
    }
    const { error } = await supabase.from("employees").insert({ organization_id: orgId, ...input });
    if (error) {
      warn(`employees "${input.full_name}": ${error.message}`);
      continue;
    }
    created++;
  }
  report("employees", rows.length, created);
}

async function importItems(
  supabase: SupabaseClient,
  orgId: string,
  invCategories: NameMap,
  byName: NameMap,
  bySku: NameMap,
): Promise<void> {
  const rows = readCsv(FILES.inventory);
  let created = 0;
  for (const row of rows) {
    const input = mapItem(row);
    if (!input.name) {
      warn("inventory: skipped a row with no name.");
      continue;
    }
    if (byName.get(input.name) || (input.sku && bySku.get(input.sku))) continue; // idempotent
    const categoryId = await ensureCategory(
      supabase,
      "inventory_categories",
      orgId,
      input.categoryName,
      invCategories,
    );
    if (DRY_RUN) {
      byName.set(input.name, "(new)");
      if (input.sku) bySku.set(input.sku, "(new)");
      created++;
      continue;
    }
    const { categoryName: _ignored, ...fields } = input;
    void _ignored;
    const { data, error } = await supabase
      .from("inventory_items")
      .insert({ organization_id: orgId, category_id: categoryId, ...fields })
      .select("id")
      .single();
    if (error) {
      warn(`inventory "${input.name}": ${error.message}`);
      continue;
    }
    byName.set(input.name, data.id as string);
    if (input.sku) bySku.set(input.sku, data.id as string);
    created++;
  }
  report("inventory_items", rows.length, created);
}

/**
 * Build inventory items from the distinct PRODUCT + SKU pairs in the sales sheet
 * (when there is no products sheet). Selling price is taken from the sale prices;
 * cost and current stock default to 0 for the owner to fill in afterwards.
 */
async function importItemsFromSales(
  supabase: SupabaseClient,
  orgId: string,
  byName: NameMap,
  bySku: NameMap,
): Promise<void> {
  const rows = readCsv(FILES.sales);
  if (!rows.length) return;

  const derived = new Map<string, { name: string; sku: string; price: number }>();
  for (const line of rows.map(mapSaleLine)) {
    const name = line.itemName || line.sku;
    if (!name) continue;
    if (byName.get(line.itemName) || (line.sku && bySku.get(line.sku))) continue; // already exists
    const key = (line.sku || name).toLowerCase();
    const existing = derived.get(key);
    if (!existing) derived.set(key, { name, sku: line.sku, price: line.unitPrice });
    else if (line.unitPrice > existing.price) existing.price = line.unitPrice; // keep the highest seen
  }

  let created = 0;
  for (const it of derived.values()) {
    if (DRY_RUN) {
      byName.set(it.name, "(new)");
      if (it.sku) bySku.set(it.sku, "(new)");
      created++;
      continue;
    }
    const { data, error } = await supabase
      .from("inventory_items")
      .insert({
        organization_id: orgId,
        name: it.name,
        sku: it.sku || null,
        selling_price: it.price,
        cost_price: 0,
        quantity_in_stock: 0,
      })
      .select("id")
      .single();
    if (error) {
      warn(`derived item "${it.name}" (${it.sku || "no sku"}): ${error.message}`);
      continue;
    }
    byName.set(it.name, data.id as string);
    if (it.sku) bySku.set(it.sku, data.id as string);
    created++;
  }
  report("inventory (from sales)", derived.size, created);
}

async function importExpenses(
  supabase: SupabaseClient,
  orgId: string,
  recordedBy: string | null,
  expCategories: NameMap,
): Promise<void> {
  const rows = readCsv(FILES.expenses);
  let created = 0;
  for (const row of rows) {
    const input = mapExpense(row);
    if (input.amount === 0 && !input.description) {
      warn("expenses: skipped an empty row.");
      continue;
    }
    if (input.expense_number && (await exists(supabase, "expenses", orgId, "expense_number", input.expense_number))) {
      continue; // idempotent on the document number
    }
    const categoryId = await ensureCategory(
      supabase,
      "expense_categories",
      orgId,
      input.categoryName,
      expCategories,
    );
    if (DRY_RUN) {
      created++;
      continue;
    }
    const { error } = await supabase.from("expenses").insert({
      organization_id: orgId,
      recorded_by: recordedBy,
      category_id: categoryId,
      amount: input.amount,
      description: input.description,
      expense_date: input.expense_date,
      expense_number: input.expense_number,
    });
    if (error) {
      warn(`expenses (${input.expense_date}, ${input.amount}): ${error.message}`);
      continue;
    }
    created++;
  }
  report("expenses", rows.length, created);
}

async function importSales(
  supabase: SupabaseClient,
  orgId: string,
  recordedBy: string | null,
  customers: NameMap,
  items: NameMap,
  itemsBySku: NameMap,
): Promise<void> {
  const rows = readCsv(FILES.sales);
  const groups = groupLines(rows.map(mapSaleLine), (l) => l.number);
  let created = 0;
  for (const group of groups) {
    const head = group[0];
    if (head.number && (await exists(supabase, "sales", orgId, "sale_number", head.number))) {
      continue; // idempotent on the invoice number
    }
    const customerId = head.customerName ? customers.get(head.customerName) : null;
    if (head.customerName && !customerId && !DRY_RUN) {
      // Create a missing customer so the sale isn't lost.
      const { data } = await supabase
        .from("customers")
        .insert({ organization_id: orgId, name: head.customerName })
        .select("id")
        .single();
      if (data) customers.set(head.customerName, data.id as string);
    }
    const lines = group.filter((l) => l.itemName || l.sku);
    const subtotal = lines.reduce((sum, l) => sum + l.lineTotal, 0);
    if (DRY_RUN) {
      for (const l of lines) resolveItem(l.itemName, l.sku, items, itemsBySku, "sales");
      created++;
      continue;
    }
    const { data: sale, error } = await supabase
      .from("sales")
      .insert({
        organization_id: orgId,
        customer_id: customers.get(head.customerName),
        recorded_by: recordedBy,
        sale_number: head.number,
        sale_date: head.date,
        subtotal,
        discount: head.discount,
        total_amount: subtotal - head.discount,
        payment_method: head.paymentMethod,
        payment_status: head.paymentStatus,
        notes: head.notes,
      })
      .select("id")
      .single();
    if (error) {
      warn(`sales ${head.number ?? head.date}: ${error.message}`);
      continue;
    }
    await insertLineItems(
      supabase,
      "sale_items",
      "sale_id",
      sale.id as string,
      lines,
      (l) => ({
        inventory_item_id: resolveItem(l.itemName, l.sku, items, itemsBySku, "sales"),
        quantity: l.quantity,
        unit_price: l.unitPrice,
        total_price: l.lineTotal,
      }),
    );
    created++;
  }
  report("sales", groups.length, created);
}

async function importPurchases(
  supabase: SupabaseClient,
  orgId: string,
  recordedBy: string | null,
  suppliers: NameMap,
  items: NameMap,
  itemsBySku: NameMap,
): Promise<void> {
  const rows = readCsv(FILES.purchases);
  const groups = groupLines(rows.map(mapPurchaseLine), (l) => l.number);
  let created = 0;
  for (const group of groups) {
    const head = group[0];
    if (head.number && (await exists(supabase, "purchases", orgId, "purchase_number", head.number))) {
      continue;
    }
    if (head.supplierName && !suppliers.get(head.supplierName) && !DRY_RUN) {
      const { data } = await supabase
        .from("suppliers")
        .insert({ organization_id: orgId, name: head.supplierName })
        .select("id")
        .single();
      if (data) suppliers.set(head.supplierName, data.id as string);
    }
    const lines = group.filter((l) => l.itemName || l.sku);
    const total = lines.reduce((sum, l) => sum + l.lineTotal, 0);
    if (DRY_RUN) {
      for (const l of lines) resolveItem(l.itemName, l.sku, items, itemsBySku, "purchases");
      created++;
      continue;
    }
    const { data: purchase, error } = await supabase
      .from("purchases")
      .insert({
        organization_id: orgId,
        supplier_id: suppliers.get(head.supplierName),
        recorded_by: recordedBy,
        purchase_number: head.number,
        purchase_date: head.date,
        total_amount: total,
        payment_method: head.paymentMethod,
        payment_status: head.paymentStatus,
        notes: head.notes,
      })
      .select("id")
      .single();
    if (error) {
      warn(`purchases ${head.number ?? head.date}: ${error.message}`);
      continue;
    }
    await insertLineItems(
      supabase,
      "purchase_items",
      "purchase_id",
      purchase.id as string,
      lines,
      (l) => ({
        inventory_item_id: resolveItem(l.itemName, l.sku, items, itemsBySku, "purchases"),
        quantity: l.quantity,
        unit_cost: l.unitCost,
        total_cost: l.lineTotal,
      }),
    );
    created++;
  }
  report("purchases", groups.length, created);
}

/* -------------------------------- helpers --------------------------------- */

/** Group line rows into transactions by document number; numberless rows stand alone. */
function groupLines<T extends { number: string | null }>(
  lines: T[],
  key: (line: T) => string | null,
): T[][] {
  const groups: T[][] = [];
  const byNumber = new Map<string, T[]>();
  for (const line of lines) {
    const n = key(line);
    if (!n) {
      groups.push([line]); // its own single-line transaction
      continue;
    }
    const bucket = byNumber.get(n);
    if (bucket) bucket.push(line);
    else byNumber.set(n, [line]);
  }
  return [...groups, ...byNumber.values()];
}

function resolveItem(
  name: string,
  sku: string,
  byName: NameMap,
  bySku: NameMap,
  context: string,
): string | null {
  const id = (sku && bySku.get(sku)) || byName.get(name);
  if (id && id !== "(new)") return id; // resolved to a real inventory row
  if (id === "(new)") return null; // a dry-run placeholder: it will exist after a live run
  warn(`${context}: item "${name || sku}" not found in inventory — line item dropped.`);
  return null;
}

async function insertLineItems<T>(
  supabase: SupabaseClient,
  table: string,
  parentKey: string,
  parentId: string,
  lines: T[],
  toRow: (line: T) => Record<string, unknown>,
): Promise<void> {
  const payload = lines
    .map(toRow)
    .filter((r) => r.inventory_item_id) // drop unresolved items (already warned)
    .map((r) => ({ [parentKey]: parentId, ...r }));
  if (!payload.length) return;
  const { error } = await supabase.from(table).insert(payload);
  if (error) warn(`${table} for ${parentId}: ${error.message}`);
}

async function exists(
  supabase: SupabaseClient,
  table: string,
  orgId: string,
  column: string,
  value: string,
): Promise<boolean> {
  if (DRY_RUN) return false;
  const { data } = await supabase
    .from(table)
    .select("id")
    .eq("organization_id", orgId)
    .eq(column, value)
    .maybeSingle();
  return Boolean(data);
}

/** Toggle the side-effect triggers via the 0006_admin.sql helper. */
async function setTriggers(supabase: SupabaseClient, enabled: boolean): Promise<void> {
  const { error } = await supabase.rpc("set_transaction_triggers", { p_enabled: enabled });
  if (error) {
    throw new Error(
      `Could not ${enabled ? "re-enable" : "disable"} transaction triggers via ` +
        `set_transaction_triggers(). Did you run supabase/migrations/0006_admin.sql? ` +
        `Original error: ${error.message}`,
    );
  }
  console.log(`Triggers ${enabled ? "re-enabled" : "disabled"} for the transactional load.`);
}

function report(label: string, read: number, created: number): void {
  console.log(`  ${label.padEnd(18)} read ${read}, ${DRY_RUN ? "would create" : "created"} ${created}`);
}

main().catch((err: unknown) => {
  console.error("\nMigration failed:", err instanceof Error ? err.message : err);
  process.exit(1);
});

// Silence "unused" for the typed-but-structural Row import in strict mode.
export type { Row, SaleLineInput, PurchaseLineInput };
