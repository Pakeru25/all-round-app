import { Card, CancelLink, Field, FormError, inputClassName } from "@/components/ui/form";
import { SubmitButton } from "@/components/ui/SubmitButton";
import type { Expense, ExpenseCategory } from "@/types/database";

export function ExpenseForm({
  action,
  categories,
  defaults,
  submitLabel,
  error,
}: {
  action: (formData: FormData) => Promise<void>;
  categories: ExpenseCategory[];
  defaults?: Partial<Expense>;
  submitLabel: string;
  error?: string;
}) {
  const today = new Date().toISOString().slice(0, 10);

  return (
    <Card>
      <form action={action} className="flex max-w-xl flex-col gap-4">
        <FormError message={error} />

        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
          <Field label="Amount (GH₵)">
            <input
              name="amount"
              type="number"
              step="0.01"
              required
              defaultValue={defaults?.amount ?? ""}
              className={inputClassName}
            />
          </Field>
          <Field label="Date">
            <input
              name="expense_date"
              type="date"
              defaultValue={defaults?.expense_date ?? today}
              className={inputClassName}
            />
          </Field>
        </div>

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

        <Field label="Description" hint="What was this expense for?">
          <textarea name="description" rows={3} defaultValue={defaults?.description ?? ""} className={inputClassName} />
        </Field>

        <div className="flex items-center gap-3">
          <SubmitButton>{submitLabel}</SubmitButton>
          <CancelLink href="/expenses" />
        </div>
      </form>
    </Card>
  );
}
