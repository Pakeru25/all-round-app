/**
 * Shared free-text search used by the per-section search bars.
 * A record matches when the trimmed, lower-cased query is a substring of any
 * of the supplied fields (each coerced to a string). An empty query matches
 * everything, so callers can pass the raw `?q=` param straight through.
 */
export function matchesQuery(
  query: string,
  ...fields: (string | number | null | undefined)[]
): boolean {
  const needle = query.trim().toLowerCase();
  if (!needle) return true;
  return fields.some((field) => {
    if (field === null || field === undefined) return false;
    return String(field).toLowerCase().includes(needle);
  });
}
