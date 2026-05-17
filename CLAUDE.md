# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Branching Strategy

```
main                          ← production-ready; single source of truth
└── epic/N-short-name         ← created from main when an epic starts
    └── story/N.M-short-name  ← created from epic branch; merged back and deleted when story is done
```

**Starting an epic:**
```bash
git checkout main && git pull origin main
git checkout -b epic/1-foundation
git push -u origin epic/1-foundation
```

**Starting a story:**
```bash
git checkout epic/1-foundation
git checkout -b story/1.1-scaffold
```

**Finishing a story:**
```bash
git checkout epic/1-foundation
git merge story/1.1-scaffold
git push origin epic/1-foundation
git branch -d story/1.1-scaffold
git push origin --delete story/1.1-scaffold
```

**Finishing an epic** (after retro is complete):
```bash
git checkout main && git pull origin main
git merge epic/1-foundation
git push origin main
git branch -d epic/1-foundation
git push origin --delete epic/1-foundation
```

**Rule:** Never merge to `main` unless `npm run type-check`, `npm run test`, `npm run test:a11y`, and `npm run test:e2e` all pass.

## Project Status

Pre-scaffold. The repo currently contains only `CLAUDE.md`, `.gitignore`, and `_bmad-output/planning-artifacts/`. No application code, `package.json`, or Supabase config exists yet — Story 1.1 creates them.

Planning artifacts (read these before writing code):
- `_bmad-output/planning-artifacts/prd.md` — full product requirements (56 FRs, NFRs)
- `_bmad-output/planning-artifacts/architecture.md` — all architectural decisions, naming conventions, and the complete target directory tree
- `_bmad-output/planning-artifacts/ux-design-specification.md` — UX patterns, component specs, design tokens
- `_bmad-output/planning-artifacts/epics.md` — 9 epics, 44 stories; implementation sequence and acceptance criteria

Story 1.1 initialises the project: `npx create-next-app -e with-supabase puzzle-times-recorder`

Post-scaffold additions (per architecture.md): `framer-motion`, `serwist @serwist/next`, `next-intl`, `stripe @stripe/stripe-js`, `fuse.js`, `papaparse @types/papaparse`, `browser-image-compression`, `@zxing/browser @zxing/library`.

## Commands

```bash
# Local dev (both required simultaneously)
supabase start        # Local Postgres + Auth + Storage via Docker
npm run dev           # Next.js with Turbopack on localhost:3000

# After any schema change
supabase db push
supabase gen types typescript --local > lib/supabase/database.types.ts

# CI checks (all must pass before merge)
npm run type-check    # tsc --noEmit
npm run test          # Vitest
npm run test:a11y     # axe-core accessibility scan
npm run test:e2e      # Playwright

# Run a single Vitest test file
npm run test -- path/to/file.test.tsx

# Run a single Playwright spec
npx playwright test e2e/solve-log.spec.ts
```

## Architecture

**Stack:** Next.js App Router + TypeScript (strict) + Supabase (Auth, DB, Storage, Realtime) + Tailwind CSS + shadcn/ui + Framer Motion

**Rendering split:**
- `app/(public)/` — SSR/SSG/ISR routes (catalog, landing, marketing) — no auth required
- `app/(app)/` — Authenticated SPA routes (dashboard, logging, marketplace)
- `app/(admin)/` — Admin-only routes; role checked in middleware
- `app/api/` — Route Handlers only (not for general data fetching)

**Data fetching rule:** Use Supabase client directly in Server Components for all reads. Route Handlers only for: `POST /api/sync/solves`, `POST /api/import/msp`, `GET /api/barcode/[code]`, `POST /api/webhooks/stripe`, `GET /api/export`, `POST /api/admin/*`.

**Top-level project layout (target tree once scaffolded — see `architecture.md` §"Complete Project Directory Structure" for the full version):**
```
app/                  ← Routes, grouped by (public) / (app) / (admin) / api
components/
  ui/                 ← shadcn/ui primitives — never modify directly
  [feature]/          ← Feature-scoped components, co-located with their tests
lib/
  supabase/           ← The three Supabase clients + auto-generated database.types.ts
  schemas/            ← Zod schemas, shared client + server
  query-keys.ts       ← All TanStack Query key factories (single file)
  env.ts              ← Zod-validated env access (single source of process.env reads)
  [domain]/           ← barcode/, fuzzy-match/, gamification/, reputation/, stripe/, notifications/, i18n/
store/                ← Two Zustand stores only: timer.store.ts, offline.store.ts
hooks/                ← Custom React hooks (useTimer, useSolveQueue, useBarcodeScan, useRealtimeSwaps)
supabase/
  migrations/         ← Timestamped SQL: YYYYMMDDHHMMSS_{description}.sql — never rename after applying
  seed.sql            ← Dev seed data
messages/             ← next-intl JSON files (en.json only at launch)
e2e/                  ← Playwright specs + fixtures (only place tests live outside src)
middleware.ts         ← Auth + premium gating + admin role check (single middleware)
```

**Test layout:** Unit tests are co-located alongside source (e.g. `TimerScreen.test.tsx` next to `TimerScreen.tsx`). Only Playwright E2E specs live in `e2e/`.

**Naming conventions** (enforced — see `architecture.md` §"Naming Patterns" for the full list):
- DB: tables `snake_case` plural, FKs `{table_singular}_id`, RLS policies `{table}_{action}_{subject}`
- API: kebab-case plural-noun paths (`/api/swap-listings`), no verb-in-path (`/api/getUser` is wrong)
- Code: PascalCase components, `use*` hooks, Zod schemas `*Schema`, Zustand stores `*Store` (file `*.store.ts`), constants `SCREAMING_SNAKE_CASE`

**Deployment:** Vercel (Next.js) + Supabase Pro + Resend (email) + Sentry (errors) + Stripe (payments). Vercel auto-deploys on push to `main`; preview deploys on every PR. GitHub Actions runs Vitest + tsc + axe-core pre-merge.

## Critical Patterns (Enforced)

**Supabase clients — always use the correct one, never instantiate inline:**
```typescript
lib/supabase/client.ts      // Client Components only
lib/supabase/server.ts      // Server Components + Route Handlers
lib/supabase/middleware.ts  // middleware.ts only
```

**Environment variables — always via `lib/env.ts`, never `process.env.X` directly:**
```typescript
import { env } from '@/lib/env'
```

**TanStack Query keys — always from `lib/query-keys.ts`, never inline strings:**
```typescript
import { queryKeys } from '@/lib/query-keys'
// queryKeys.solves.byUser(userId), queryKeys.catalog.puzzle(puzzleId), etc.
```

**Zod schemas — defined in `lib/schemas/`, shared between client forms and Route Handler validation:**
```typescript
// Always safeParse — never parse() which throws
const result = solveLogSchema.safeParse(formData)
```

**Route Handler error shape — exactly this, nothing else:**
```typescript
return NextResponse.json(
  { error: 'Human-readable message', code: 'kebab-case-code' },
  { status: 400 }
)
```

**Zustand — two stores only in V1:** `store/timer.store.ts` and `store/offline.store.ts`. Do not add a third store without architectural justification.

**Images — always `next/image`, never `<img>`. Storage paths are fixed:**
- Solve photos: `solve-photos/{user_id}/{solve_id}/{filename}`
- Swap photos: `swap-photos/{listing_id}/{filename}`
- Puzzle catalog: `puzzle-images/{puzzle_id}/cover.{ext}`

**Dates — always `Intl.DateTimeFormat`, never `date.toLocaleDateString()`**

**DB types — always from `lib/supabase/database.types.ts` (auto-generated). Never manually re-type what Supabase generates.**

## Key Architectural Decisions

**Offline solve logging:** Serwist Service Worker intercepts `POST /api/sync/solves` when offline. Solves queue in IndexedDB via `idb`. Each solve carries a `crypto.randomUUID()` client ID. Sync endpoint uses `ON CONFLICT (client_id) DO NOTHING` — queue replay is always safe.

**Premium gating:** Middleware reads `subscriptions` table, sets subscription status as a request header. Server Components and Route Handlers read the header — no per-component DB query. The `PremiumGate` wrapper component handles UI gating.

**Barcode lookup:** Three-tier in `lib/barcode/` — internal catalog → Open Food Facts → UPC Item DB. External hits are cached in internal catalog. External API keys are server-side only via `lib/env.ts`.

**RLS:** Enabled on every table. Users can only read/write their own data via the anon key. Admin mutations use the service role key in Route Handlers only — never in client bundles.

**i18n:** All UI strings via next-intl translation keys. No hardcoded copy in components. `messages/en.json` is the only launch language. Dates via `Intl.DateTimeFormat`.

**Animations:** All Framer Motion animations must check `prefers-reduced-motion` and provide instant-transition fallbacks.

**Migrations:** Each schema change is a new timestamped SQL file in `supabase/migrations/`. Never rename a migration after it has been applied (locally or remotely) — Supabase tracks them by filename. After `supabase db push`, always regenerate types: `supabase gen types typescript --local > lib/supabase/database.types.ts`.

**RLS read policies split:** Public catalog, puzzle details, and community leaderboards have open read policies. Everything user-scoped (solves, listings, profiles, subscriptions) is restricted to the owner's rows via the anon key. Plan RLS for any new table from day one.

## Anti-Patterns (Reject in Code Review)

- `createClient()` inside a component body
- `process.env.STRIPE_SECRET_KEY` outside `lib/env.ts`
- `queryClient.invalidateQueries('solves')` with a raw string
- `date.toLocaleDateString()`
- `<img>` instead of `next/image`
- Images stored at arbitrary/user-chosen paths
- A third Zustand store added without justification
- Manually written TypeScript types that duplicate Supabase-generated types
- `parse()` instead of `safeParse()` in Zod validation
- Route Handler error response in any shape other than `{ error, code }`
