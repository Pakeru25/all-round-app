import { type NextRequest } from "next/server";
import { updateSession } from "@/lib/supabase/middleware";

/**
 * Next.js 16 renamed `middleware.ts` to `proxy.ts` (the exported function is now
 * `proxy`, running on the Node.js runtime). This refreshes the Supabase session
 * cookie and redirects unauthenticated users away from protected routes.
 */
export async function proxy(request: NextRequest) {
  return await updateSession(request);
}

export const config = {
  matcher: [
    /*
     * Run on all paths except static assets and image files so the auth cookie
     * is kept fresh, while avoiding needless work on assets.
     */
    "/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp|ico)$).*)",
  ],
};
