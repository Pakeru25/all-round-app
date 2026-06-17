import { ComingSoon } from "@/components/ui/ComingSoon";
import { requireRole } from "@/lib/auth/session";

export default async function CustomersPage() {
  await requireRole(["owner", "manager", "staff"]);
  return (
    <ComingSoon
      title="Customers"
      description="Your customer directory with purchase history and totals."
    />
  );
}
