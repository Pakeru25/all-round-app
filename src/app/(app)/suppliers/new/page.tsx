import { PageHeader } from "@/components/ui/PageHeader";
import { requireRole } from "@/lib/auth/session";
import { SupplierForm } from "../SupplierForm";
import { createSupplier } from "../actions";

export default async function NewSupplierPage({
  searchParams,
}: {
  searchParams: Promise<{ error?: string }>;
}) {
  await requireRole(["owner", "manager"]);
  const { error } = await searchParams;

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader title="Add supplier" />
      <SupplierForm action={createSupplier} submitLabel="Create supplier" error={error} />
    </div>
  );
}
