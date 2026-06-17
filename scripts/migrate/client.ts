/**
 * Service-role Supabase client for the one-time migration. Unlike the app's
 * clients in `src/lib/supabase/`, this uses the SERVICE ROLE key, which bypasses
 * Row-Level Security so a trusted bulk load isn't blocked by the owner/manager
 * write rules. NEVER ship this key to the browser — it stays in this Node script.
 */
import { createClient, type SupabaseClient } from "@supabase/supabase-js";
import { requireEnv } from "./env";

export function createServiceClient(): SupabaseClient {
  const url = requireEnv("NEXT_PUBLIC_SUPABASE_URL");
  const serviceKey = requireEnv("SUPABASE_SERVICE_ROLE_KEY");

  return createClient(url, serviceKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  });
}
