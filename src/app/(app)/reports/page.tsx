import { ComingSoon } from "@/components/ui/ComingSoon";
import { requireRole } from "@/lib/auth/session";

export default async function ReportsPage() {
  await requireRole(["owner", "manager", "accountant"]);
  return (
    <ComingSoon
      title="Reports"
      description="Revenue vs expenses, top-selling items, sales by period, and stock value."
    />
  );
}
