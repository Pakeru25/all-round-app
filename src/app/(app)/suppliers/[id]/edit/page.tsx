import { notFound } from "next/navigation";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card } from "@/components/ui/form";
import { SubmitButton } from "@/components/ui/SubmitButton";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/lib/auth/session";
import type { Supplier } from "@/types/database";
import { SupplierForm } from "../../SupplierForm";
import { updateSupplier, deleteSupplier } from "../../actions";

export default async function EditSupplierPage({
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
  const { data } = await supabase.from("suppliers").select("*").eq("id", id).single();
  const supplier = data as Supplier | null;
  if (!supplier) notFound();

  return (
    <div className="mx-auto max-w-6xl">
      <PageHeader title="Edit supplier" description={supplier.name} />
      <SupplierForm
        action={updateSupplier.bind(null, supplier.id)}
        defaults={supplier}
        submitLabel="Save changes"
        error={error}
      />

      {profile.role === "owner" ? (
        <div className="mt-4 max-w-xl">
          <Card>
            <form action={deleteSupplier.bind(null, supplier.id)} className="flex items-center justify-between gap-4">
              <span className="text-sm text-zinc-500">Permanently delete this supplier.</span>
              <SubmitButton variant="danger">Delete</SubmitButton>
            </form>
          </Card>
        </div>
      ) : null}
    </div>
  );
}
