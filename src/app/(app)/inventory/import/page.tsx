import Link from "next/link";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card, CancelLink, Field, FormError, inputClassName } from "@/components/ui/form";
import { SubmitButton } from "@/components/ui/SubmitButton";
import { requireRole } from "@/lib/auth/session";
import { importInventory } from "./actions";

export default async function ImportInventoryPage({
  searchParams,
}: {
  searchParams: Promise<{
    error?: string;
    created?: string;
    updated?: string;
    skipped?: string;
    errors?: string;
  }>;
}) {
  await requireRole(["owner", "manager"]);
  const sp = await searchParams;

  const created = sp.created ? Number(sp.created) : null;
  const updated = sp.updated ? Number(sp.updated) : null;
  const skipped = sp.skipped ? Number(sp.skipped) : null;
  const rowErrors = sp.errors ? sp.errors.split("\n") : [];
  const ranImport = created !== null || updated !== null;

  return (
    <div className="mx-auto max-w-3xl">
      <PageHeader title="Import inventory" description="Bulk-load items from a CSV export of your stock sheet." />

      <div className="mb-4">
        <Link href="/inventory" className="text-sm text-zinc-500 underline">
          ← All inventory
        </Link>
      </div>

      {ranImport ? (
        <div className="mb-4 rounded-xl border border-zinc-200 bg-white p-5 dark:border-zinc-800 dark:bg-zinc-900">
          <h2 className="text-sm font-semibold text-zinc-900 dark:text-zinc-50">Import complete</h2>
          <p className="mt-1 text-sm text-zinc-600 dark:text-zinc-400">
            {created ?? 0} added · {updated ?? 0} updated
            {skipped ? ` · ${skipped} skipped` : ""}.
          </p>
          {rowErrors.length > 0 ? (
            <ul className="mt-3 space-y-1 border-t border-zinc-100 pt-3 text-xs text-amber-700 dark:border-zinc-800 dark:text-amber-400">
              {rowErrors.map((e, i) => (
                <li key={i}>{e}</li>
              ))}
            </ul>
          ) : null}
        </div>
      ) : null}

      <Card>
        <form action={importInventory} className="flex flex-col gap-4">
          <FormError message={sp.error} />

          <Field label="CSV file" hint="A .csv export from Excel or Google Sheets.">
            <input
              type="file"
              name="file"
              accept=".csv,text/csv"
              required
              className={`${inputClassName} file:mr-3 file:rounded file:border-0 file:bg-zinc-100 file:px-2 file:py-1 file:text-xs dark:file:bg-zinc-800 dark:file:text-zinc-200`}
            />
          </Field>

          <div className="flex items-center gap-3">
            <SubmitButton>Import items</SubmitButton>
            <CancelLink href="/inventory" />
          </div>
        </form>
      </Card>

      <div className="mt-4 rounded-xl border border-zinc-200 bg-white p-5 text-sm dark:border-zinc-800 dark:bg-zinc-900">
        <h2 className="mb-2 text-sm font-semibold text-zinc-900 dark:text-zinc-50">Expected columns</h2>
        <p className="text-zinc-600 dark:text-zinc-400">
          The first row must be a header row. <strong>Name</strong> and <strong>Type</strong> are required; the rest are
          optional. Headers are matched loosely (e.g. “Item”, “Qty”, “Cost price” all work).
        </p>
        <ul className="mt-3 space-y-1 text-zinc-600 dark:text-zinc-400">
          <li>
            <strong>Name</strong> — item name (or “Item”)
          </li>
          <li>
            <strong>Type</strong> — raw material, finished product, or packaging material
          </li>
          <li>
            <strong>Category</strong> — e.g. Fabric, T-shirt, Box (created automatically if new)
          </li>
          <li>
            <strong>Unit</strong> — pcs, yards, meters, kg… (defaults to “pieces”)
          </li>
          <li>
            <strong>Quantity</strong>, <strong>Cost</strong>, <strong>Price</strong> — numbers (currency symbols are
            ignored)
          </li>
          <li>
            <strong>SKU</strong>, <strong>Reorder</strong>, <strong>Description</strong> — optional
          </li>
        </ul>
        <p className="mt-3 text-xs text-zinc-400">
          Re-importing matches existing items by SKU (or name when there’s no SKU) and updates them, so you can fix your
          sheet and upload again without creating duplicates.
        </p>
      </div>
    </div>
  );
}
