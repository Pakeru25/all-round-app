import "server-only";

import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import type { Organization, Profile, Role } from "@/types/database";

export interface SessionContext {
  profile: Profile;
  organization: Organization | null;
}

/**
 * Loads the signed-in user's profile (and org). Returns null when there is no
 * session or no profile row yet. Server Components / actions only.
 */
export async function getSessionContext(): Promise<SessionContext | null> {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return null;

  const { data: profileData } = await supabase
    .from("profiles")
    .select("*")
    .eq("id", user.id)
    .single();
  const profile = profileData as Profile | null;
  if (!profile) return null;

  const { data: orgData } = await supabase
    .from("organizations")
    .select("*")
    .eq("id", profile.organization_id)
    .single();
  const organization = (orgData as Organization | null) ?? null;

  return { profile, organization };
}

/**
 * Server-side guard for pages/actions. Redirects to /login when signed out, and
 * to /dashboard when the role is not permitted. Returns the session on success.
 */
export async function requireRole(allowed: Role[]): Promise<SessionContext> {
  const ctx = await getSessionContext();
  if (!ctx) redirect("/login");
  if (!allowed.includes(ctx.profile.role)) redirect("/dashboard");
  return ctx;
}
