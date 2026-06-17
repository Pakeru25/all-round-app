/**
 * CSV reading + header helpers. Drop exported sheet tabs into
 * `scripts/migrate/data/<name>.csv` and read them with `readCsv(name)`.
 */
import { existsSync, readFileSync } from "node:fs";
import { resolve } from "node:path";
import { parse } from "csv-parse/sync";

export type Row = Record<string, string>;

const DATA_DIR = resolve(process.cwd(), "scripts/migrate/data");

/**
 * Read `scripts/migrate/data/<name>.csv` into trimmed string records. Returns an
 * empty array (not an error) when the file is absent, so you can migrate only
 * the sheets you have.
 */
export function readCsv(name: string): Row[] {
  const path = resolve(DATA_DIR, `${name}.csv`);
  if (!existsSync(path)) return [];

  return parse(readFileSync(path, "utf8"), {
    columns: (header: string[]) => header.map((h) => h.trim()),
    skip_empty_lines: true,
    trim: true,
    bom: true,
  }) as Row[];
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
