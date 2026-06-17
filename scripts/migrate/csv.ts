/**
 * CSV reading + header helpers. Drop exported sheet tabs into
 * `scripts/migrate/data/<name>.csv` and read them with `readCsv(name)`.
 */
import { existsSync, readdirSync, readFileSync } from "node:fs";
import { resolve } from "node:path";
import { parse } from "csv-parse/sync";

export type Row = Record<string, string>;

const DATA_DIR = resolve(process.cwd(), "scripts/migrate/data");

/** Find a data file by any of several candidate base names, case-insensitively. */
function resolveFile(candidates: string[]): string | null {
  if (!existsSync(DATA_DIR)) return null;
  const files = readdirSync(DATA_DIR);
  for (const candidate of candidates) {
    const target = `${candidate}.csv`.toLowerCase();
    const match = files.find((f) => f.toLowerCase() === target);
    if (match) return resolve(DATA_DIR, match);
  }
  return null;
}

/**
 * Read a data CSV into trimmed string records. Accepts one name or several
 * candidates (e.g. ["customers", "customer"]) and matches the file
 * case-insensitively. Returns an empty array (not an error) when none is
 * present, so you can migrate only the sheets you have.
 */
export function readCsv(name: string | string[]): Row[] {
  const path = resolveFile(Array.isArray(name) ? name : [name]);
  if (!path) return [];

  const rows = parse(readFileSync(path, "utf8"), {
    columns: (header: string[]) => header.map((h) => h.trim()),
    skip_empty_lines: true,
    trim: true,
    bom: true,
    relax_column_count: true, // your sheets have trailing empty columns
  }) as Row[];

  // Spreadsheets pad out to hundreds of blank rows — drop the fully-empty ones
  // so they don't show up as skipped-row warnings during the import.
  return rows.filter((row) => Object.values(row).some((v) => (v ?? "").trim() !== ""));
}

/**
 * Case-insensitive lookup that accepts several possible header spellings, so the
 * mappers survive small differences between the sheet headers and what we
 * expect (e.g. "Phone", "phone number", "Tel"). Returns "" when none match.
 */
export function pick(row: Row, ...aliases: string[]): string {
  const keys = Object.keys(row);
  for (const alias of aliases) {
    const match = keys.find((k) => k.toLowerCase() === alias.toLowerCase());
    if (match) {
      const value = (row[match] ?? "").trim();
      if (value !== "") return value;
    }
  }
  return "";
}
