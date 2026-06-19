"use client";

import { Search } from "lucide-react";
import { usePathname, useRouter, useSearchParams } from "next/navigation";
import { useEffect, useState } from "react";

/**
 * A debounced free-text search box that drives the `?q=` URL param. The page's
 * server component reads `q` and filters its list, so search composes with the
 * existing sidebar filters (category / tier / low-stock) that also live in the URL.
 */
export function SearchBar({ placeholder }: { placeholder: string }) {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const current = searchParams.get("q") ?? "";
  const [value, setValue] = useState(current);

  // Adopt the URL's `q` when it changes from outside this component — e.g. a
  // sidebar filter link that drops the query, or back/forward navigation — so
  // the box always matches what's actually filtering the list. Adjusting state
  // during render (rather than in an effect) avoids an extra render pass and
  // never clobbers what the user is actively typing.
  const [syncedQ, setSyncedQ] = useState(current);
  if (current !== syncedQ) {
    setSyncedQ(current);
    setValue(current);
  }

  useEffect(() => {
    const trimmed = value.trim();
    if (trimmed === current) return; // nothing new to push (covers initial mount)
    const timer = setTimeout(() => {
      const params = new URLSearchParams(searchParams.toString());
      if (trimmed) params.set("q", trimmed);
      else params.delete("q");
      const qs = params.toString();
      router.replace(qs ? `${pathname}?${qs}` : pathname, { scroll: false });
    }, 300);
    return () => clearTimeout(timer);
  }, [value, current, pathname, router, searchParams]);

  return (
    <div className="relative w-full max-w-xs">
      <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-zinc-400" />
      <input
        type="search"
        value={value}
        onChange={(e) => setValue(e.target.value)}
        placeholder={placeholder}
        className="w-full rounded-md border border-zinc-200 bg-white py-2 pl-9 pr-3 text-sm text-zinc-900 outline-none placeholder:text-zinc-400 focus:border-zinc-400 dark:border-zinc-800 dark:bg-zinc-950 dark:text-zinc-50"
      />
    </div>
  );
}
