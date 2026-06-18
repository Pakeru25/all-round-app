import { PageHeader } from "@/components/ui/PageHeader";
import { requireRole } from "@/lib/auth/session";
import { EmployeeForm } from "../EmployeeForm";
import { createEmployee } from "../actions";

export default async function NewEmployeePage({
  searchParams,
}: {
  searchParams: Promise<{ error?: string }>;
}) {
  await requireRole(["owner"]);
  const { error } = await searchParams;

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader title="Add employee" />
      <EmployeeForm action={createEmployee} submitLabel="Create employee" error={error} />
    </div>
  );
}
