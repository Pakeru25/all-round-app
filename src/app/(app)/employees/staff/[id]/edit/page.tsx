import { notFound } from "next/navigation";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card } from "@/components/ui/form";
import { SubmitButton } from "@/components/ui/SubmitButton";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import type { Employee } from "@/types/database";
import { EmployeeForm } from "../../../EmployeeForm";
import { updateEmployee, deleteEmployee } from "../../../actions";

export default async function EditEmployeePage({
  params,
  searchParams,
}: {
  params: Promise<{ id: string }>;
  searchParams: Promise<{ error?: string }>;
}) {
  await requireRole(["owner"]);
  const { id } = await params;
  const { error } = await searchParams;

  const supabase = await createClient();
  const { data } = await supabase.from("employees").select("*").eq("id", id).single();
  const employee = data as Employee | null;
  if (!employee) notFound();

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader title="Edit employee" description={employee.full_name} />
      <EmployeeForm
        action={updateEmployee.bind(null, employee.id)}
        defaults={employee}
        submitLabel="Save changes"
        error={error}
      />

      <div className="mt-4 max-w-xl">
        <Card>
          <form
            action={deleteEmployee.bind(null, employee.id)}
            className="flex items-center justify-between gap-4"
          >
            <span className="text-sm text-zinc-500">Permanently delete this employee.</span>
            <SubmitButton variant="danger">Delete</SubmitButton>
          </form>
        </Card>
      </div>
    </div>
  );
}
