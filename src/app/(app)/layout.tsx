import { Suspense } from "react";
import { redirect } from "next/navigation";
import { Sidebar } from "@/components/shell/Sidebar";
import { TopBar } from "@/components/shell/TopBar";
import { getSessionContext } from "@/lib/auth/session";
import { getNavSections } from "@/lib/nav";
import { createClient } from "@/lib/supabase/server";

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

  const supabase = await createClient();
  const { count } = await supabase
    .from("notifications")
    .select("*", { count: "exact", head: true })
    .eq("recipient_id", profile.id)
    .eq("is_read", false);

  const sections = await getNavSections(profile);

  return (
    <div className="flex h-screen overflow-hidden">
      <Suspense
        fallback={<aside className="hidden w-64 shrink-0 border-r border-zinc-200 md:block dark:border-zinc-800" />}
      >
        <Sidebar role={profile.role} sections={sections} />
      </Suspense>
      <div className="flex flex-1 flex-col overflow-hidden">
        <TopBar
          orgName={organization?.name ?? "All Round App"}
          fullName={profile.full_name ?? profile.email ?? "User"}
          role={profile.role}
          unreadCount={count ?? 0}
        />
        <main className="flex-1 overflow-y-auto bg-zinc-50 p-6 dark:bg-zinc-950">
          {children}
        </main>
      </div>
    </div>
  );
}
