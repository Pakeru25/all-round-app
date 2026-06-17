import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";

/**
 * Server-side Supabase client for Server Components, Server Actions and Route
 * Handlers. `cookies()` is async in Next.js 16, so this factory is async too.
 * Only the `getAll` / `setAll` cookie API is used (the older get/set/remove API
 * is deprecated in @supabase/ssr).
 */
export async function createClient() {
  const cookieStore = await cookies();

  return createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return cookieStore.getAll();
        },
        setAll(cookiesToSet) {
          try {
            cookiesToSet.forEach(({ name, value, options }) =>
              cookieStore.set(name, value, options),
            );
          } catch {
            // `setAll` was called from a Server Component. This can be ignored
            // when the proxy (src/proxy.ts) is refreshing user sessions.
          }
        },
      },
    },
  );
}
