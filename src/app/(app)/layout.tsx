import { redirect } from "next/navigation";
import { Sidebar } from "@/components/shell/Sidebar";
import { TopBar } from "@/components/shell/TopBar";
import { getSessionContext } from "@/lib/auth/session";

export default async function AppLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const ctx = await getSessionContext();
  // Defense in depth: the proxy already guards these routes, but never render
  // the shell without a confirmed profile.
  if (!ctx) redirect("/login");

  const { profile, organization } = ctx;

  return (
    <div className="flex h-screen overflow-hidden">
      <Sidebar role={profile.role} />
      <div className="flex flex-1 flex-col overflow-hidden">
        <TopBar
          orgName={organization?.name ?? "All Round App"}
          fullName={profile.full_name ?? profile.email ?? "User"}
          role={profile.role}
        />
        <main className="flex-1 overflow-y-auto bg-zinc-50 p-6 dark:bg-zinc-950">
          {children}
        </main>
      </div>
    </div>
  );
}
