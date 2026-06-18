"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { getSessionContext } from "@/lib/auth/session";
import { parseInventoryCsv, type ImportError } from "@/lib/inventory-import";

const CAN_WRITE = ["owner", "manager"];
const MAX_REPORTED_ERRORS = 15;

function back(params: Record<string, string | number>): never {
  const qs = new URLSearchParams();
  for (const [k, v] of Object.entries(params)) qs.set(k, String(v));
  redirect(`/inventory/import?${qs.toString()}`);
}

export async function importInventory(formData: FormData) {
  const ctx = await getSessionContext();
  if (!ctx) redirect("/login");
  if (!CAN_WRITE.includes(ctx.profile.role)) redirect("/inventory");
  const orgId = ctx.profile.organization_id;

  const file = formData.get("file");
  if (!(file instanceof File) || file.size === 0) {
    back({ error: "Choose a CSV file to upload." });
  }
  const text = await (file as File).text();

  const { rows, errors, fatal } = parseInventoryCsv(text);
  if (fatal) back({ error: fatal });

  const supabase = await createClient();

  // --- Auto-create any categories the sheet references but we don't have yet -
  const { data: existingCats } = await supabase.from("inventory_categories").select("id,name");
  const catByName = new Map<string, string>();
  for (const c of (existingCats as { id: string; name: string }[] | null) ?? []) {
    catByName.set(c.name.trim().toLowerCase(), c.id);
  }
  // Distinct needed names, keeping first-seen original casing.
  const neededCats = new Map<string, string>();
  for (const row of rows) {
    if (!row.category) continue;
    const key = row.category.toLowerCase();
    if (!catByName.has(key) && !neededCats.has(key)) neededCats.set(key, row.category);
  }
  if (neededCats.size > 0) {
    const { data: inserted, error } = await supabase
      .from("inventory_categories")
      .insert([...neededCats.values()].map((name) => ({ organization_id: orgId, name })))
      .select("id,name");
    if (error) back({ error: `Couldn't create categories: ${error.message}` });
    for (const c of (inserted as { id: string; name: string }[] | null) ?? []) {
      catByName.set(c.name.trim().toLowerCase(), c.id);
    }
  }

  // --- Decide insert vs update against existing items (by SKU, then name) ----
  const { data: existingItems } = await supabase.from("inventory_items").select("id,sku,name");
  const idBySku = new Map<string, string>();
  const idByName = new Map<string, string>();
  for (const it of (existingItems as { id: string; sku: string | null; name: string }[] | null) ?? []) {
    if (it.sku) idBySku.set(it.sku.trim().toLowerCase(), it.id);
    const nameKey = it.name.trim().toLowerCase();
    if (!idByName.has(nameKey)) idByName.set(nameKey, it.id);
  }

  const rowErrors: ImportError[] = [...errors];
  const updates: { id: string; payload: Record<string, unknown> }[] = [];
  const inserts: Record<string, unknown>[] = [];
  const insertSkus = new Set<string>();

  for (const row of rows) {
    const payload = {
      name: row.name,
      sku: row.sku,
      description: row.description,
      category_id: row.category ? catByName.get(row.category.toLowerCase()) ?? null : null,
      inventory_type: row.inventory_type,
      unit: row.unit,
      quantity_in_stock: row.quantity_in_stock,
      cost_price: row.cost_price,
      selling_price: row.selling_price,
      reorder_level: row.reorder_level,
      is_active: true,
    };

    const skuKey = row.sku?.trim().toLowerCase();
    const matchId = (skuKey && idBySku.get(skuKey)) || idByName.get(row.name.trim().toLowerCase());

    if (matchId) {
      updates.push({ id: matchId, payload });
      continue;
    }
    // New item. Guard against duplicate SKUs within the same file (the DB has a
    // unique (organization_id, sku) constraint that would otherwise fail the batch).
    if (skuKey) {
      if (insertSkus.has(skuKey)) {
        rowErrors.push({ line: row.line, message: `Duplicate SKU "${row.sku}" in file — row skipped.` });
        continue;
      }
      insertSkus.add(skuKey);
    }
    inserts.push({ organization_id: orgId, ...payload });
  }

  // --- Persist ---------------------------------------------------------------
  let created = 0;
  let updated = 0;

  if (inserts.length > 0) {
    const { error, count } = await supabase.from("inventory_items").insert(inserts, { count: "exact" });
    if (error) back({ error: `Import failed while adding items: ${error.message}` });
    created = count ?? inserts.length;
  }

  for (const u of updates) {
    const { error } = await supabase.from("inventory_items").update(u.payload).eq("id", u.id);
    if (error) {
      rowErrors.push({ line: 0, message: `Couldn't update "${u.payload.name}": ${error.message}` });
    } else {
      updated++;
    }
  }

  revalidatePath("/inventory");

  const reported = rowErrors
    .slice(0, MAX_REPORTED_ERRORS)
    .map((e) => (e.line ? `Line ${e.line}: ${e.message}` : e.message));
  if (rowErrors.length > MAX_REPORTED_ERRORS) {
    reported.push(`…and ${rowErrors.length - MAX_REPORTED_ERRORS} more.`);
  }

  back({
    created,
    updated,
    skipped: rowErrors.length,
    ...(reported.length > 0 ? { errors: reported.join("\n") } : {}),
  });
}
