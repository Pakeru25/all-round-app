import { ComingSoon } from "@/components/ui/ComingSoon";
import { requireRole } from "@/lib/auth/session";

export default async function SuppliersPage() {
  await requireRole(["owner", "manager"]);
  return (
    <ComingSoon
      title="Suppliers"
      description="Your supplier directory with contacts and purchase history."
    />
  );
}
