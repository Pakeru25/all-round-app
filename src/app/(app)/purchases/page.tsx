import { ComingSoon } from "@/components/ui/ComingSoon";
import { requireRole } from "@/lib/auth/session";

export default async function PurchasesPage() {
  await requireRole(["owner", "manager"]);
  return (
    <ComingSoon
      title="Purchases"
      description="Log restocks from suppliers; inventory increases automatically."
    />
  );
}
