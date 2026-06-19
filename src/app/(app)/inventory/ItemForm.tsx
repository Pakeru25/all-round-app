import Link from "next/link";
import { Card, CancelLink, Field, FormError, inputClassName } from "@/components/ui/form";
import { SubmitButton } from "@/components/ui/SubmitButton";
import { INVENTORY_TYPES } from "@/lib/inventory";
import type { InventoryCategory, InventoryItem } from "@/types/database";

export function ItemForm({
  action,
  categories,
  defaults,
  submitLabel,
  error,
}: {
  action: (formData: FormData) => Promise<void>;
  categories: InventoryCategory[];
  defaults?: Partial<InventoryItem>;
  submitLabel: string;
  error?: string;
}) {
  return (
    <Card>
      <form action={action} className="flex max-w-2xl flex-col gap-4">
        <FormError message={error} />

        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
          <Field label="Name">
            <input name="name" required defaultValue={defaults?.name ?? ""} className={inputClassName} />
          </Field>
          <Field label="SKU" hint="Optional stock code (unique).">
            <input name="sku" defaultValue={defaults?.sku ?? ""} className={inputClassName} />
          </Field>
        </div>

        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
          <Field label="Type" hint="Where this sits in your stock.">
            <select
              name="inventory_type"
              required
              defaultValue={defaults?.inventory_type ?? "raw_material"}
              className={inputClassName}
            >
              {INVENTORY_TYPES.map((t) => (
                <option key={t.value} value={t.value}>
                  {t.label}
                </option>
              ))}
            </select>
          </Field>
          <Field label="Category">
            <select name="category_id" defaultValue={defaults?.category_id ?? ""} className={inputClassName}>
              <option value="">— None —</option>
              {categories.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.name}
                </option>
              ))}
            </select>
          </Field>
        </div>

        <Field label="Unit" hint="e.g. pieces, meters, rolls, kg">
          <input
            name="unit"
            defaultValue={defaults?.unit ?? "pieces"}
            className={`${inputClassName} sm:max-w-xs`}
          />
        </Field>

        <div className="grid grid-cols-1 gap-4 sm:grid-cols-3">
          <Field label="Quantity in stock">
            <input
              name="quantity_in_stock"
              type="number"
              step="0.01"
              defaultValue={defaults?.quantity_in_stock ?? 0}
              className={inputClassName}
            />
          </Field>
          <Field label="Cost price (GH₵)">
            <input
              name="cost_price"
              type="number"
              step="0.01"
              defaultValue={defaults?.cost_price ?? 0}
              className={inputClassName}
            />
          </Field>
          <Field label="Selling price (GH₵)">
            <input
              name="selling_price"
              type="number"
              step="0.01"
              defaultValue={defaults?.selling_price ?? 0}
              className={inputClassName}
            />
          </Field>
        </div>

        <Field label="Reorder level" hint="Alert when stock drops to or below this.">
          <input
            name="reorder_level"
            type="number"
            step="1"
            defaultValue={defaults?.reorder_level ?? 0}
            className={`${inputClassName} sm:max-w-xs`}
          />
        </Field>

        <Field label="Description">
          <textarea name="description" rows={3} defaultValue={defaults?.description ?? ""} className={inputClassName} />
        </Field>

        <label className="flex items-center gap-2 text-sm text-zinc-700 dark:text-zinc-300">
          <input
            type="checkbox"
            name="is_active"
            defaultChecked={defaults?.is_active ?? true}
            className="h-4 w-4 rounded border-zinc-300"
          />
          Active (uncheck to hide without deleting)
        </label>

        <div className="flex items-center gap-3">
          <SubmitButton>{submitLabel}</SubmitButton>
          <CancelLink href="/inventory" />
        </div>

        <p className="text-xs text-zinc-400">
          Need a new category first?{" "}
          <Link href="/inventory/categories" className="underline">
            Manage categories
          </Link>
          .
        </p>
      </form>
    </Card>
  );
}
