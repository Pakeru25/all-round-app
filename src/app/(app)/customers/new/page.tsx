import { PageHeader } from "@/components/ui/PageHeader";
import { requireRole } from "@/lib/auth/session";
import { CustomerForm } from "../CustomerForm";
import { createCustomer } from "../actions";

export default async function NewCustomerPage({
  searchParams,
}: {
  searchParams: Promise<{ error?: string }>;
}) {
  await requireRole(["owner", "manager"]);
  const { error } = await searchParams;

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader title="Add customer" />
      <CustomerForm action={createCustomer} submitLabel="Create customer" error={error} />
    </div>
  );
}
