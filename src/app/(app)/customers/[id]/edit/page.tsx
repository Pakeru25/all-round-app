import { notFound } from "next/navigation";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card } from "@/components/ui/form";
import { SubmitButton } from "@/components/ui/SubmitButton";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import type { Customer } from "@/types/database";
import { CustomerForm } from "../../CustomerForm";
import { updateCustomer, deleteCustomer } from "../../actions";

export default async function EditCustomerPage({
  params,
  searchParams,
}: {
  params: Promise<{ id: string }>;
  searchParams: Promise<{ error?: string }>;
}) {
  const { profile } = await requireRole(["owner", "manager"]);
  const { id } = await params;
  const { error } = await searchParams;

  const supabase = await createClient();
  const { data } = await supabase.from("customers").select("*").eq("id", id).single();
  const customer = data as Customer | null;
  if (!customer) notFound();

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader title="Edit customer" description={customer.name} />
      <CustomerForm
        action={updateCustomer.bind(null, customer.id)}
        defaults={customer}
        submitLabel="Save changes"
        error={error}
      />

      {profile.role === "owner" ? (
        <div className="mt-4 max-w-xl">
          <Card>
            <form action={deleteCustomer.bind(null, customer.id)} className="flex items-center justify-between gap-4">
              <span className="text-sm text-zinc-500">Permanently delete this customer.</span>
              <SubmitButton variant="danger">Delete</SubmitButton>
            </form>
          </Card>
        </div>
      ) : null}
    </div>
  );
}
