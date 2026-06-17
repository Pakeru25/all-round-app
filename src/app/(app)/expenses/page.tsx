import { ComingSoon } from "@/components/ui/ComingSoon";
import { requireRole } from "@/lib/auth/session";

export default async function ExpensesPage() {
  await requireRole(["owner", "manager", "accountant"]);
  return (
    <ComingSoon
      title="Expenses"
      description="Record business expenses by category, with receipts attached."
    />
  );
}
