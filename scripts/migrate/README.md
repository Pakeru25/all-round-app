# Google Sheets → All Round App migration

A one-time script that loads your exported Google Sheets into the Supabase
database, routing each kind of record to the right table (customers, suppliers,
employees, inventory, expenses, and full sales/purchases with line items).

It runs with the **service-role key**, so it bypasses Row-Level Security, and it
**disables the stock/audit/notification triggers** during the historical load so
your imported history doesn't double-count stock or generate a notification per
row. Current stock is taken straight from your inventory sheet.

## 1. One-time database setup

In the Supabase **SQL Editor**, run [`supabase/migrations/0006_admin.sql`](../../supabase/migrations/0006_admin.sql)
once. It adds the `set_transaction_triggers()` helper the script uses to toggle
those triggers. (You already ran `supabase/schema.sql` when you set up the app.)

## 2. Export your sheets as CSV

In Google Sheets: **File → Download → Comma-separated values (.csv)** for each
tab. Save them into `scripts/migrate/data/` using these names (omit any you
don't have — they're simply skipped):

| File              | One row per…        | Columns it looks for (any of these names) |
| ----------------- | ------------------- | ----------------------------------------- |
| `customers.csv`   | customer            | name, email, phone, address, notes, preferences |
| `suppliers.csv`   | supplier            | name, contact person, email, phone, address, notes |
| `employees.csv`   | employee            | full name, position, phone, email, salary, hire date, notes |
| `inventory.csv`   | product             | name, sku, description, category, unit, quantity in stock, cost price, selling price, reorder level |
| `expenses.csv`    | expense             | date, category, amount, description, (optional) expense number |
| `sales.csv`       | **sale line item**  | sale number/invoice, date, customer, item (or sku), quantity, unit price, total, payment method, payment status, discount, notes |
| `purchases.csv`   | **purchase line item** | purchase number/invoice, date, supplier, item (or sku), quantity, unit cost, total, payment method, payment status, notes |

Header matching is **case-insensitive** and accepts common aliases (e.g. "Qty",
"Phone Number", "Selling Price"). If your headers differ, either rename the
column in the sheet or add the alias in
[`mappers.ts`](./mappers.ts) — each field's `pick(...)` lists the names it accepts.

### How sales & purchases are grouped

These sheets are expected to have **one row per line item**. Rows sharing the
same invoice/sale number are combined into a single sale/purchase with multiple
line items; the header fields (date, customer, payment) are read from the first
row of each group. Rows **without** a number become single-line transactions.
Line items are matched to inventory by **SKU first, then name** — items must
already exist in `inventory.csv`/the inventory table or the line is dropped (with
a warning).

### Dates & money

Money cells may include symbols/commas (`GH₵1,200.50`). Dates are normalized to
`YYYY-MM-DD`; ambiguous `DD/MM` vs `MM/DD` follows JavaScript's (US-first)
parsing — prefer `YYYY-MM-DD` in your sheets to be safe.

## 3. Configure credentials

In `.env.local` (same file the app uses) make sure these are set:

```
NEXT_PUBLIC_SUPABASE_URL=...
SUPABASE_SERVICE_ROLE_KEY=...      # Project Settings → API → service_role (secret)
```

Optional:

- `OWNER_EMAIL=you@example.com` — attribute imported records to this owner
  (`recorded_by`). Defaults to null.
- `ORG_ID=...` — override the target organization (defaults to the seeded one).

## 4. Run it

```bash
npm install                 # first time only (adds tsx + csv-parse)
npm run migrate -- --dry-run   # validate & preview counts, writes NOTHING
npm run migrate                # perform the load
```

Always do the **dry run first**. It maps every row and prints per-table counts
plus warnings (e.g. "item X not found in inventory"). Fix the sheets/mappings,
then run for real.

## Safe to re-run

The script is idempotent on natural keys: inventory by SKU, and
sales/purchases/expenses by their document number. Customers/suppliers/employees
are de-duplicated by name. **Caveat:** transaction rows with **no** document
number can't be de-duplicated, so a second run would re-insert them — give those
rows numbers, or start from a clean database, if you plan to re-run.
