import { ComingSoon } from "@/components/ui/ComingSoon";
import { requireRole } from "@/lib/auth/session";

export default async function SalesPage() {
  await requireRole(["owner", "manager", "staff"]);
  return (
    <ComingSoon
      title="Sales"
      description="Record sales, view receipts, and watch inventory adjust automatically."
    />
  );
}
