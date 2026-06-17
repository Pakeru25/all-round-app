import { Card, CancelLink, Field, FormError, inputClassName } from "@/components/ui/form";
import { SubmitButton } from "@/components/ui/SubmitButton";
import type { Customer } from "@/types/database";

export function CustomerForm({
  action,
  defaults,
  submitLabel,
  error,
}: {
  action: (formData: FormData) => Promise<void>;
  defaults?: Partial<Customer>;
  submitLabel: string;
  error?: string;
}) {
  return (
    <Card>
      <form action={action} className="flex max-w-xl flex-col gap-4">
        <FormError message={error} />

        <Field label="Name">
          <input name="name" required defaultValue={defaults?.name ?? ""} className={inputClassName} />
        </Field>

        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
          <Field label="Email">
            <input name="email" type="email" defaultValue={defaults?.email ?? ""} className={inputClassName} />
          </Field>
          <Field label="Phone">
            <input name="phone" defaultValue={defaults?.phone ?? ""} className={inputClassName} />
          </Field>
        </div>

        <Field label="Address">
          <input name="address" defaultValue={defaults?.address ?? ""} className={inputClassName} />
        </Field>

        <Field label="Notes">
          <textarea name="notes" rows={3} defaultValue={defaults?.notes ?? ""} className={inputClassName} />
        </Field>

        <div className="flex items-center gap-3">
          <SubmitButton>{submitLabel}</SubmitButton>
          <CancelLink href="/customers" />
        </div>
      </form>
    </Card>
  );
}
