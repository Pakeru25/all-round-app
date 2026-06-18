/**
 * CSV parsing + normalization for the inventory bulk importer. Pure functions
 * only (no DB) so the mapping rules are easy to reason about and test; the
 * server action in inventory/import/actions.ts handles persistence.
 *
 * Expected columns (header names are matched case-insensitively, with a few
 * aliases each). `name` and `type` are required; everything else is optional:
 *   name | type | category | unit | quantity | cost | price | sku | reorder | description
 */
import type { InventoryType } from "@/types/database";

export interface ParsedRow {
  line: number; // 1-based source line (including header) for error messages
  name: string;
  sku: string | null;
  description: string | null;
  category: string | null;
  inventory_type: InventoryType;
  unit: string;
  quantity_in_stock: number;
  cost_price: number;
  selling_price: number;
  reorder_level: number;
}

export interface ImportError {
  line: number;
  message: string;
}

export interface ParseResult {
  rows: ParsedRow[];
  errors: ImportError[];
  /** Set when the file can't be used at all (e.g. missing required columns). */
  fatal?: string;
}

/** Field name → accepted header aliases (compared after normalizeHeader). */
const FIELD_ALIASES: Record<string, string[]> = {
  name: ["name", "item", "itemname", "item name", "product", "productname"],
  inventory_type: ["type", "inventorytype", "inventory type", "stocktype", "stock type"],
  category: ["category", "categories", "categoryname"],
  unit: ["unit", "units", "uom", "measure"],
  quantity_in_stock: ["quantity", "qty", "quantityinstock", "instock", "in stock", "stock", "qtyinstock"],
  cost_price: ["cost", "costprice", "cost price", "unitcost", "buyprice", "buyingprice"],
  selling_price: ["price", "sell", "sellprice", "sellingprice", "selling price", "saleprice"],
  sku: ["sku", "code", "stockcode", "itemcode"],
  reorder_level: ["reorder", "reorderlevel", "reorder level", "reorderpoint", "minstock"],
  description: ["description", "desc", "notes", "details"],
};

function normalizeHeader(h: string): string {
  return h.trim().toLowerCase().replace(/[\s_-]+/g, " ").trim();
}

/** Map normalized headers; returns field → column index (first match wins). */
function buildHeaderMap(headers: string[]): Map<string, number> {
  const map = new Map<string, number>();
  headers.forEach((raw, idx) => {
    const norm = normalizeHeader(raw);
    const compact = norm.replace(/\s+/g, "");
    for (const [field, aliases] of Object.entries(FIELD_ALIASES)) {
      if (map.has(field)) continue;
      if (aliases.some((a) => a === norm || a.replace(/\s+/g, "") === compact)) {
        map.set(field, idx);
        break;
      }
    }
  });
  return map;
}

/** Normalize a free-text type cell to one of the three enum values, or null. */
export function normalizeInventoryType(raw: string): InventoryType | null {
  const v = raw.trim().toLowerCase();
  if (!v) return null;
  if (v.includes("raw")) return "raw_material";
  if (v.includes("packag") || v.includes("packing")) return "packaging_material";
  if (v.includes("finish") || v.includes("product")) return "finished_product";
  return null;
}

/** Parse a numeric cell, tolerating currency symbols, thousands separators, units. */
function parseNumber(raw: string | undefined): number {
  if (!raw) return 0;
  const cleaned = raw.replace(/[^0-9.\-]/g, "");
  const n = Number(cleaned);
  return Number.isFinite(n) ? n : 0;
}

/**
 * RFC-4180-ish CSV parser: handles quoted fields, embedded commas/newlines,
 * and "" escapes. Returns a matrix of cells (no header interpretation).
 */
export function parseCsv(text: string): string[][] {
  const rows: string[][] = [];
  let row: string[] = [];
  let field = "";
  let inQuotes = false;
  // Strip a leading UTF-8 BOM if present.
  const s = text.charCodeAt(0) === 0xfeff ? text.slice(1) : text;

  for (let i = 0; i < s.length; i++) {
    const c = s[i];
    if (inQuotes) {
      if (c === '"') {
        if (s[i + 1] === '"') {
          field += '"';
          i++;
        } else {
          inQuotes = false;
        }
      } else {
        field += c;
      }
    } else if (c === '"') {
      inQuotes = true;
    } else if (c === ",") {
      row.push(field);
      field = "";
    } else if (c === "\n" || c === "\r") {
      if (c === "\r" && s[i + 1] === "\n") i++;
      row.push(field);
      rows.push(row);
      row = [];
      field = "";
    } else {
      field += c;
    }
  }
  // Flush the trailing field/row if the file didn't end in a newline.
  if (field !== "" || row.length > 0) {
    row.push(field);
    rows.push(row);
  }
  return rows;
}

export function parseInventoryCsv(text: string): ParseResult {
  const matrix = parseCsv(text);
  if (matrix.length === 0) return { rows: [], errors: [], fatal: "The file is empty." };

  const headers = matrix[0];
  const headerMap = buildHeaderMap(headers);

  if (!headerMap.has("name")) {
    return {
      rows: [],
      errors: [],
      fatal: "Couldn't find a 'name' (or 'item') column. Add a header row with at least Name and Type columns.",
    };
  }
  if (!headerMap.has("inventory_type")) {
    return {
      rows: [],
      errors: [],
      fatal: "Couldn't find a 'type' column. It should hold raw material / finished product / packaging material.",
    };
  }

  const cell = (cols: string[], field: string): string => {
    const idx = headerMap.get(field);
    return idx === undefined ? "" : (cols[idx] ?? "").trim();
  };

  const rows: ParsedRow[] = [];
  const errors: ImportError[] = [];

  for (let r = 1; r < matrix.length; r++) {
    const cols = matrix[r];
    const line = r + 1; // 1-based, header is line 1
    // Skip fully blank lines.
    if (cols.every((c) => c.trim() === "")) continue;

    const name = cell(cols, "name");
    if (!name) {
      errors.push({ line, message: "Missing item name — row skipped." });
      continue;
    }

    const rawType = cell(cols, "inventory_type");
    const inventory_type = normalizeInventoryType(rawType);
    if (!inventory_type) {
      errors.push({
        line,
        message: `Unrecognised type "${rawType}" for "${name}" — use raw material, finished product, or packaging material.`,
      });
      continue;
    }

    const category = cell(cols, "category") || null;
    rows.push({
      line,
      name,
      sku: cell(cols, "sku") || null,
      description: cell(cols, "description") || null,
      category,
      inventory_type,
      unit: cell(cols, "unit") || "pieces",
      quantity_in_stock: parseNumber(cell(cols, "quantity_in_stock")),
      cost_price: parseNumber(cell(cols, "cost_price")),
      selling_price: parseNumber(cell(cols, "selling_price")),
      reorder_level: Math.trunc(parseNumber(cell(cols, "reorder_level"))),
    });
  }

  return { rows, errors };
}
