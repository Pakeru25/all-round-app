# All Round App

An all-in-one business management web app for **Pakeru** — inventory, sales,
purchases, expenses, customers, suppliers and employees, with strong
**accountability** (a tamper-proof activity trail and owner notifications).

> **Status: Foundation (Phase 1).** Authentication, the role-based app shell,
> and the complete database with security and accountability are in place. The
> feature screens (inventory/sales/expenses CRUD, dashboard figures, reports)
> arrive in later phases — their tables and security rules already exist.

## Tech stack

- **Next.js 16** (App Router, TypeScript) + **Tailwind CSS v4** — UI and backend
  logic together; deploy on **Vercel**. No separate backend server.
- **Supabase** (PostgreSQL) — database, authentication, Row-Level Security,
  Realtime and Storage.
- **CI**: GitHub Actions runs lint + typecheck + build on every push/PR.
- **Cost**: runs on free tiers to start.

## How it fits together

```
GitHub  ──►  Vercel (Next.js: pages + server actions)  ──►  Supabase (Postgres + Auth + RLS)
```

## Roles & permissions

Access is enforced in the database itself (Row-Level Security), not just the UI.

| Capability            | Owner | Manager | Staff       | Accountant |
| --------------------- | :---: | :-----: | :---------: | :--------: |
| Dashboard             |  ✅   |   ✅    |     ✅      |     ✅     |
| Create/edit sales     |  ✅   |   ✅    |     ✅      |     ❌     |
| Create/edit purchases |  ✅   |   ✅    |     ❌      |     ❌     |
| Log expenses          |  ✅   |   ✅    |     ❌      |     ❌     |
| View expenses         |  ✅   |   ✅    |     ❌      |     ✅     |
| Manage inventory      |  ✅   |   ✅    |  view only  |     ❌     |
| View customers        |  ✅   |   ✅    |     ✅      |     ❌     |
| View activity log     |  ✅   |   ✅    |     ❌      |     ❌     |
| Manage employees      |  ✅   |   ❌    |     ❌      |     ❌     |
| Manage users/roles    |  ✅   |   ❌    |     ❌      |     ❌     |
| View reports          |  ✅   |   ✅    |     ❌      |     ✅     |
| Delete records        |  ✅   |   ❌    |     ❌      |     ❌     |

The business supports **two owners**; multiple users can hold the `owner` role.

## Setting up Supabase (one time, ~10 minutes)

1. Create a free project at [supabase.com](https://supabase.com).
2. In the dashboard, open **SQL Editor → New query**.
3. Open [`supabase/schema.sql`](supabase/schema.sql) from this repo, copy the
   **entire** file, paste it into the editor, and click **Run**. This creates
   all tables, security rules, triggers and the seed "Pakeru" organization.
4. Get your keys from **Project Settings → API**: the **Project URL** and the
   **anon/public** key.

### Promote your owners

Everyone who signs up starts as `staff` and joins the seeded organization.
After your two owners have signed up once, run this in the SQL Editor:

```sql
update profiles set role = 'owner'
where email in ('owner1@example.com', 'owner2@example.com');
```

## Environment variables

Copy `.env.example` to `.env.local` and fill in:

| Variable                        | Where        | Notes                                              |
| ------------------------------- | ------------ | -------------------------------------------------- |
| `NEXT_PUBLIC_SUPABASE_URL`      | public       | Project URL                                        |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | public       | Anon key — safe in the browser; RLS enforces access |
| `SUPABASE_SERVICE_ROLE_KEY`     | **secret**   | Server-only. Never prefix with `NEXT_PUBLIC`, never commit |

## Local development

```bash
npm install
cp .env.example .env.local   # then fill in your Supabase values
npm run dev                  # http://localhost:3000
```

Other scripts: `npm run build`, `npm run lint`, `npm run typecheck`.

## Deploy to Vercel

1. Import this GitHub repo at [vercel.com](https://vercel.com).
2. Add the three environment variables above in **Settings → Environment
   Variables**.
3. Deploy. Every push to a branch gets a preview URL; merges to `main` go to
   production.
4. In Supabase, add your Vercel URLs under **Authentication → URL
   Configuration** (Site URL + redirect URLs, including `/auth/callback`).

> **Tip for first testing:** Supabase requires email confirmation by default.
> For quick trials you can disable it under **Authentication → Providers →
> Email**, or configure SMTP to send real confirmation emails.

## Project structure

```
src/
  app/
    (auth)/         login & signup (server actions in actions.ts)
    (app)/          protected shell + dashboard + section stubs
    auth/           callback (email confirm) + signout route handlers
    page.tsx        redirects to /dashboard or /login
  components/shell/ Sidebar (role-aware) + TopBar
  lib/supabase/     browser / server / session-refresh clients
  lib/auth/roles.ts roles, nav permissions, requireRole(), getSessionContext()
  lib/format.ts     GH₵ currency + date formatting
  proxy.ts          Next.js 16 proxy (session refresh + route guard)
supabase/
  schema.sql        full schema for copy-paste setup
  migrations/       the same, split into ordered files for the Supabase CLI
```

## Accountability (built into the database)

- **Auto-numbering:** sales/purchases/expenses get `SAL-`/`PUR-`/`EXP-` numbers
  via a race-safe per-org counter.
- **Automatic stock + audit:** recording a sale/purchase adjusts stock and writes
  an `inventory_movements` row automatically (database triggers, so app bugs
  can't skip it).
- **Tamper-proof trail:** every create writes to `activity_log`, which has **no
  update or delete policy** — not even an owner can alter history.
- **Owner notifications:** owners get a `notifications` row whenever a sale,
  purchase or expense is recorded, and a low-stock alert when items hit their
  reorder level (ready for the Realtime bell UI in a later phase).
