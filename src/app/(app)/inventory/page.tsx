import { ComingSoon } from "@/components/ui/ComingSoon";
import { requireRole } from "@/lib/auth/session";

export default async function InventoryPage() {
  await requireRole(["owner", "manager", "staff"]);
  return (
    <ComingSoon
      title="Inventory"
      description="Track boxes, poly bags, fabrics and every item you stock — quantities, prices and reorder alerts."
    />
  );
}
