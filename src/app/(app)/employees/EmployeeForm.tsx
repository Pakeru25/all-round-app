import { Card, CancelLink, Field, FormError, inputClassName } from "@/components/ui/form";
import { SubmitButton } from "@/components/ui/SubmitButton";
import type { Employee } from "@/types/database";

export function EmployeeForm({
  action,
  defaults,
  submitLabel,
  error,
}: {
  action: (formData: FormData) => Promise<void>;
  defaults?: Partial<Employee>;
  submitLabel: string;
  error?: string;
}) {
  return (
    <Card>
      <form action={action} className="flex max-w-xl flex-col gap-4">
        <FormError message={error} />

        <Field label="Full name">
          <input
            name="full_name"
            required
            defaultValue={defaults?.full_name ?? ""}
            className={inputClassName}
          />
        </Field>

        <Field label="Position">
          <input
            name="position"
            defaultValue={defaults?.position ?? ""}
            className={inputClassName}
          />
        </Field>

        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
          <Field label="Email">
            <input
              name="email"
              type="email"
              defaultValue={defaults?.email ?? ""}
              className={inputClassName}
            />
          </Field>
          <Field label="Phone">
            <input
              name="phone"
              defaultValue={defaults?.phone ?? ""}
              className={inputClassName}
            />
          </Field>
        </div>

        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
          <Field label="Salary (GH₵)">
            <input
              name="salary"
              type="number"
              min="0"
              step="0.01"
              defaultValue={defaults?.salary ?? ""}
              className={inputClassName}
            />
          </Field>
          <Field label="Hire date">
            <input
              name="hire_date"
              type="date"
              defaultValue={defaults?.hire_date ?? ""}
              className={inputClassName}
            />
          </Field>
        </div>

        <Field label="Status">
          <select
            name="status"
            defaultValue={defaults?.status ?? "active"}
            className={inputClassName}
          >
            <option value="active">Active</option>
            <option value="inactive">Inactive</option>
          </select>
        </Field>

        <Field label="Notes">
          <textarea
            name="notes"
            rows={3}
            defaultValue={defaults?.notes ?? ""}
            className={inputClassName}
          />
        </Field>

        <div className="flex items-center gap-3">
          <SubmitButton>{submitLabel}</SubmitButton>
          <CancelLink href="/employees" />
        </div>
      </form>
    </Card>
  );
}
