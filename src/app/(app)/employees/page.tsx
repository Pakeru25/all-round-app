import { ComingSoon } from "@/components/ui/ComingSoon";
import { requireRole } from "@/lib/auth/session";

export default async function EmployeesPage() {
  await requireRole(["owner"]);
  return (
    <ComingSoon
      title="Employees"
      description="Staff records — positions, salaries, hire dates and status. Owner-only."
    />
  );
}
