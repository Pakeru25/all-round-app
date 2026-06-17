import { ComingSoon } from "@/components/ui/ComingSoon";
import { requireRole } from "@/lib/auth/session";

export default async function ActivityPage() {
  await requireRole(["owner", "manager"]);
  return (
    <ComingSoon
      title="Activity Log"
      description="The accountability trail — every action by every user, in order, tamper-proof."
    />
  );
}
