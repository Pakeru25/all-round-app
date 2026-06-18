/**
 * Minimal `.env.local` loader so the migration script needs no extra runtime
 * dependency. Values already present in `process.env` win (so you can override
 * on the command line). Mirrors the variables documented in `.env.example`.
 */
import { existsSync, readFileSync } from "node:fs";
import { resolve } from "node:path";

let loaded = false;

function loadDotEnv(): void {
  if (loaded) return;
  loaded = true;

  const path = resolve(process.cwd(), ".env.local");
  if (!existsSync(path)) return;

  for (const rawLine of readFileSync(path, "utf8").split("\n")) {
    const line = rawLine.trim();
    if (!line || line.startsWith("#")) continue;

    const eq = line.indexOf("=");
    if (eq === -1) continue;

    const key = line.slice(0, eq).trim();
    let value = line.slice(eq + 1).trim();
    if (
      (value.startsWith('"') && value.endsWith('"')) ||
      (value.startsWith("'") && value.endsWith("'"))
    ) {
      value = value.slice(1, -1);
    }
    if (!(key in process.env)) process.env[key] = value;
  }
}

export function requireEnv(name: string): string {
  loadDotEnv();
  const value = process.env[name];
  if (!value) {
    throw new Error(
      `Missing required env var ${name}. Set it in .env.local (see .env.example).`,
    );
  }
  return value;
}
