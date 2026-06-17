import { createBrowserClient } from "@supabase/ssr";

/**
 * Browser-side Supabase client.
 * Created inside event handlers / components at runtime — never at module load —
 * so `next build` never needs live credentials. Uses the public anon key, which
 * is safe to ship to the browser because Row-Level Security enforces access.
 */
export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
  );
}
