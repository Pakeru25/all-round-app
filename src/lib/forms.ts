/** Helpers for reading values out of a submitted FormData in server actions. */

export function str(v: FormDataEntryValue | null): string {
  return typeof v === "string" ? v.trim() : "";
}

export function strOrNull(v: FormDataEntryValue | null): string | null {
  const s = str(v);
  return s === "" ? null : s;
}

export function num(v: FormDataEntryValue | null): number {
  const n = Number(str(v));
  return Number.isFinite(n) ? n : 0;
}

export function intOrZero(v: FormDataEntryValue | null): number {
  const n = parseInt(str(v), 10);
  return Number.isFinite(n) ? n : 0;
}
