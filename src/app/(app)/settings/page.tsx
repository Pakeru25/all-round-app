import { ComingSoon } from "@/components/ui/ComingSoon";
import { requireRole } from "@/lib/auth/session";

export default async function SettingsPage() {
  await requireRole(["owner"]);
  return (
    <ComingSoon
      title="Settings"
      description="Manage users and roles, categories, and business details. Owner-only."
    />
  );
}
