import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

export async function POST(request: Request) {
  const supabase = await createClient();
  await supabase.auth.signOut();

  const { origin } = new URL(request.url);
  // 303 so the browser follows with a GET after the POST.
  return NextResponse.redirect(`${origin}/login`, { status: 303 });
}
