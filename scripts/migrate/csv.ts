/**
 * CSV reading + header helpers. Drop exported sheet tabs into
 * `scripts/migrate/data/<name>.csv` and read them with `readCsv(name)`.
 *
 * Sheets may be split into one file per year (e.g. `2025 Sales.csv` +
 * `2026 Sales.csv`); a single `readCsv("sales")` matches and **combines** every
 * file whose name contains the candidate token, so the full multi-year history
 * loads at once. Each returned row is tagged with `__source_year` (parsed from
 * the file name) so mappers can keep the years cleanly separated.
 */
import { existsSync, readdirSync, readFileSync } from "node:fs";
import { resolve } from "node:path";
import { parse } from "csv-parse/sync";

export type Row = Record<string, string>;

/** Synthetic column added to every row, holding the year parsed from the file name (or ""). */
export const SOURCE_YEAR_KEY = "__source_year";

const DATA_DIR = resolve(process.cwd(), "scripts/migrate/data");

/**
 * Find every data file matching any candidate token, matched case-insensitively
 * as a **substring** of the file name (so "sales" matches both "2025 Sales.csv"
 * and "2026 Sales.csv"). Returns the matches sorted by name, so year-split files
 * are read oldest-first for deterministic grouping.
 */
function resolveFiles(candidates: string[]): string[] {
  if (!existsSync(DATA_DIR)) return [];
  const tokens = candidates.map((c) => c.toLowerCase());
  return readdirSync(DATA_DIR)
    .filter((f) => f.toLowerCase().endsWith(".csv"))
    .filter((f) => {
      const name = f.toLowerCase();
      return tokens.some((t) => name.includes(t));
    })
    .sort()
    .map((f) => resolve(DATA_DIR, f));
}

/** Parse one CSV file's text into trimmed records, tagged with its source year. */
function parseFile(path: string): Row[] {
  const year = /(20\d{2})/.exec(path)?.[1] ?? "";

  const rows = parse(readFileSync(path, "utf8"), {
    // De-duplicate header names so the FIRST occurrence wins. Some exported
    // sheets glue a second table onto the right (repeating DATE/AMOUNT/…); left
    // as-is, the duplicate columns would overwrite the primary block's values.
    columns: (header: string[]) => {
      const seen = new Set<string>();
      return header.map((h, i) => {
        const name = h.trim();
        const key = name.toLowerCase();
        if (name === "" || seen.has(key)) return `__dup_${i}`;
        seen.add(key);
        return name;
      });
    },
    skip_empty_lines: true,
    trim: true,
    bom: true,
    relax_column_count: true, // your sheets have trailing empty columns
  }) as Row[];

  for (const row of rows) row[SOURCE_YEAR_KEY] = year;
  return rows;
}

/**
 * Read data CSV(s) into trimmed string records. Accepts one name or several
 * candidates (e.g. ["customers", "customer"]) and matches files
 * case-insensitively by substring, **concatenating** every match (so year-split
 * sheets load together). Returns an empty array (not an error) when none is
 * present, so you can migrate only the sheets you have.
 */
export function readCsv(name: string | string[]): Row[] {
  const paths = resolveFiles(Array.isArray(name) ? name : [name]);
  if (!paths.length) return [];

  const rows = paths.flatMap(parseFile);

  // Spreadsheets pad out to hundreds of blank rows — drop the fully-empty ones
  // so they don't show up as skipped-row warnings during the import. The
  // synthetic year tag doesn't count as content.
  return rows.filter((row) =>
    Object.entries(row).some(([k, v]) => k !== SOURCE_YEAR_KEY && (v ?? "").trim() !== ""),
  );
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
