---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8]
lastStep: 8
status: 'complete'
completedAt: '2026-04-25'
inputDocuments:
  - "_bmad-output/planning-artifacts/prd.md"
  - "_bmad-output/planning-artifacts/ux-design-specification.md"
  - "_bmad-output/planning-artifacts/research/market-jigsaw-puzzle-tracking-community-platform-research-2026-04-25.md"
workflowType: 'architecture'
project_name: 'PuzzleTimesRecorder'
user_name: 'Andrew'
date: '2026-04-25'
---

# Architecture Decision Document

_This document builds collaboratively through step-by-step discovery. Sections are appended as we work through each architectural decision together._

## Project Context Analysis

### Requirements Overview

**Functional Requirements (56 total):**
- Solve Logging & Tracking (8): Timer, barcode scan, offline queuing, solve history
- Puzzle Catalog (6): Search, community ratings, catalog submission/moderation
- Data Import & Export (6): MSP CSV import, fuzzy matching, review queue, universal export
- Gamification & Personal Dashboard (9): Streaks, PBs, badges, retroactive awards, goals, Former Champion
- Swap Marketplace (9): Listings, condition grading, reputation scoring, swap request flow, disputes, ISO alerts
- User Accounts & Subscriptions (7): Auth, profiles, Stripe subscriptions, notification preferences, i18n
- Community & Social (6): Leaderboards, follows, activity feed, Puzzle of the Week, curated lists
- Platform Administration (5): Dispute queue, reputation adjustment, account restrictions, audit log, catalog moderation

**Non-Functional Requirements (driving architecture):**
- Performance: Core log flow ≤3s (3G); FCP ≤2.5s mobile; search ≤1s; barcode ≤1.5s; Lighthouse ≥85 mobile
- Offline: Solve log queues locally; syncs within 10s of reconnect; zero data loss
- Scalability: 0–1,000 concurrent at launch; supports 10× growth (10K MAU) without re-architecture; catalog ≥100K entries without query degradation
- Security: TLS 1.2+, Argon2 password hashing, refresh token rotation, Stripe PCI delegation, GDPR right-to-deletion within 30 days, tamper-evident audit log
- Accessibility: WCAG 2.1 AA; all UI strings externalized via i18n keys; RTL layout support in place at launch (not activated); touch targets ≥44×44px
- Integration: Barcode lookup ≥80% match rate; MSP CSV up to 10K rows; Stripe webhooks; CDN image delivery

**Scale & Complexity:**
- Primary domain: Full-stack web (Next.js PWA + REST/RPC API + background jobs)
- Complexity level: Medium-High
- User archetypes: 2 primary (speed puzzler / swap seeker) with divergent core loops
- Estimated architectural modules: ~17

### Technical Constraints & Dependencies

- **PWA mandate:** Service Worker required at launch for offline solve queuing (V1 success criterion)
- **Design system:** Next.js App Router + Tailwind CSS + shadcn/ui + Framer Motion (decided in UX spec)
- **Payment processor:** Stripe — PCI scope fully delegated; no card data on app servers
- **Rendering hybrid:** Public catalog/marketing pages → SSR/SSG (SEO); authenticated app → client-side SPA
- **No native app (V1):** PWA is the sole mobile delivery vehicle; Camera API for barcode scan
- **Solo/small team mandate (PRD):** Stack must minimize operational burden; prefer managed services over self-hosted infrastructure
- **Browser support:** Chrome/Safari on iOS + Android primary; ES2020+ minimum; no IE11
- **Cheapest viable hosting:** Drives managed service preference (Supabase, Vercel) over self-hosted Postgres/servers

### Cross-Cutting Concerns Identified

1. **Authentication & Authorization** — JWT/session model must support free vs. premium tier gating consistently across all features
2. **Offline/Sync** — Service Worker + IndexedDB queuing for solve logs; idempotent server-side sync endpoint; conflict resolution policy needed
3. **i18n** — All UI strings externalized at build time; `Intl.DateTimeFormat` for dates; RTL CSS architecture in Tailwind config from day one
4. **Image pipeline** — Client-side compression (≤1MB) before upload; CDN delivery with lazy loading; solve photos and swap listing photos have different retention/access policies
5. **Premium/Freemium gating** — Middleware-level authorization for premium features (streak shields, unlimited swap listings, enhanced analytics); consistent across API and UI layers
6. **Barcode catalog** — Shared lookup service used by both logging flow and swap listing creation; external barcode DB + internal catalog; fallback to manual search
7. **Audit log** — Tamper-evident, append-only log for all admin moderation actions; GDPR-compliant (log entries may reference deleted user IDs without PII)
8. **GDPR/Privacy** — Right-to-deletion with cascade policy defined per entity; data export endpoint; consent tracking for analytics
9. **Notification system** — In-app and (potentially) email notifications for swap activity, badge awards, community interactions; preference-gated
10. **SEO/Rendering boundary** — Clear separation between public SSR routes (catalog, landing) and private CSR routes (dashboard, logging, marketplace management)

## Starter Template Evaluation

### Primary Technology Domain

Full-stack web PWA — Next.js App Router with Supabase backend, mobile-first

### Starter Options Considered

| Option | Includes | Reason Rejected/Selected |
|---|---|---|
| `create-next-app` (official) | Next.js, TypeScript, Tailwind, ESLint | Too minimal — Auth, Supabase, shadcn/ui all manual |
| `create-t3-app` | Next.js, tRPC, Drizzle, Auth.js | Over-engineered — Drizzle/Prisma duplicates Supabase client; tRPC unnecessary complexity |
| `with-supabase` (Supabase official) | Next.js App Router, TypeScript, Tailwind, shadcn/ui, Supabase Auth | **Selected** — pre-wires Auth + shadcn/ui + SSR cookie handling |

### Selected Starter: Supabase Next.js Starter (`with-supabase`)

**Rationale for Selection:**
- Ships Supabase Auth with correct cookie-based session handling for SSR (non-trivial to set up manually)
- Includes shadcn/ui pre-integrated — eliminates one wiring step
- App Router + TypeScript + Tailwind out of the box
- Official Supabase maintained — kept current with Next.js releases
- Leanest path to a production-ready foundation for a solo developer

**Initialization Command:**

```bash
npx create-next-app -e with-supabase puzzle-times-recorder
```

Then run Supabase project setup:

```bash
npx supabase init
npx supabase login
```

**Post-init additions (install after scaffolding):**

```bash
# Animation
npm install framer-motion

# PWA / Service Worker (offline solve queuing)
npm install serwist @serwist/next

# i18n (all UI strings externalized)
npm install next-intl

# Payments
npm install stripe @stripe/stripe-js

# Fuzzy matching (MSP import)
npm install fuse.js

# CSV parsing (MSP import)
npm install papaparse @types/papaparse

# Image compression (client-side before upload)
npm install browser-image-compression

# Barcode scanning
npm install @zxing/browser @zxing/library
```

**Architectural Decisions Provided by Starter:**

**Language & Runtime:**
TypeScript (strict mode), Node.js runtime. All new code in TypeScript; no `.js` files in app code.

**Styling Solution:**
Tailwind CSS v4 with shadcn/ui component primitives (Radix UI). Design tokens defined in `tailwind.config.ts` — single source of truth for color palette, typography, spacing.

**Authentication:**
Supabase Auth with `@supabase/ssr` — cookie-based sessions that work correctly across Server Components, Client Components, Route Handlers, and Middleware. No JWT management needed.

**Build Tooling:**
Turbopack (Next.js dev server), standard Next.js production build. No custom webpack configuration required.

**Testing Framework:**
Not included in starter — add Vitest + Testing Library post-scaffold. Playwright for E2E. axe-core for accessibility CI.

**Code Organization:**
Next.js App Router conventions:
- `app/(public)/` — SSR/SSG routes (catalog, landing, marketing)
- `app/(app)/` — Client-heavy authenticated routes (dashboard, logging, marketplace)
- `app/api/` — Route Handlers (webhooks, barcode lookup, CSV import, sync endpoint)
- `components/ui/` — shadcn/ui primitives
- `components/[feature]/` — Custom feature components
- `lib/supabase/` — Supabase client instances (server + client + middleware)
- `lib/[domain]/` — Domain logic (reputation, gamification, fuzzy-match, etc.)

**Development Experience:**
- Turbopack hot reload
- TypeScript strict mode with path aliases (`@/*`)
- ESLint + Prettier
- Supabase local development via Docker (`supabase start`)

**Note:** Project initialization using the above command should be the first implementation story.

## Core Architectural Decisions

### Decision Priority Analysis

**Critical Decisions (Block Implementation):**
- Data access pattern (Server Components vs. Route Handlers)
- Row Level Security strategy
- Premium gating implementation
- Offline sync endpoint + idempotency model
- Admin role system

**Important Decisions (Shape Architecture):**
- Barcode lookup tier strategy
- Client/server state split (TanStack Query + Zustand)
- GDPR deletion cascade policy
- Email provider
- Real-time strategy (Supabase Realtime vs. polling)

**Deferred Decisions (Post-MVP):**
- Dark mode (Tailwind `dark:` variant architected in, not activated)
- Native iOS/Android apps (PWA covers V1)
- WebSocket real-time for leaderboards (polling in V1)
- B2B manufacturer data API (schema ready, feature deferred)
- AI coach and recommendation engine (V1.5)

### Data Architecture

**Data access pattern:** Direct Supabase client calls in Server Components for all reads — no extra network hop, no boilerplate Route Handler per query. Next.js Route Handlers only for: Stripe webhooks, barcode lookup proxy (hides external API key), CSV import processing (streaming), offline solve sync (`POST /api/sync/solves`), and admin mutations (service role).

**Row Level Security (RLS):** Enabled on every table from day one. Users read/write only their own data by default. Public catalog, puzzle details, and community leaderboards have open read policies. All admin mutations use the Supabase service role key, only accessible server-side — never in client bundles.

**Schema migrations:** Supabase migration files in `supabase/migrations/`, committed to git, applied via `supabase db push`. Schema is version-controlled; no manual DB changes in production.

**Caching:** Next.js ISR for public catalog pages (puzzle detail, brand pages) — statically generated, revalidated on catalog update. No additional cache layer at V1 — Supabase connection pooling handles query throughput for target scale.

**B2B data readiness:** Manufacturer, brand, and puzzle metadata columns included in schema from V1. No migration required to activate V2 B2B features.

### Authentication & Security

**Auth flow:** Supabase Auth + `@supabase/ssr` for correct cookie-based session handling across Server Components, Client Components, Route Handlers, and Middleware. Next.js Middleware checks session on every request; public routes (`/catalog/*`, `/`, `/login`, `/signup`) bypass the check. All `/(app)/*` routes require a valid session.

**Premium gating:** `subscriptions` table stores Stripe customer ID, status, and tier. Middleware reads subscription status and sets it as a request header — Server Components and Route Handlers read the header without additional DB queries per request. Feature flags are consistent across API and UI layers.

**Admin roles:** `user_roles` table (`user_id`, `role: 'admin' | 'moderator'`). Middleware checks role for all `/admin/*` routes. Admin mutations use the Supabase service role key in Route Handlers only.

**Security standards:** TLS 1.2+ enforced by Vercel and Supabase. Passwords managed entirely by Supabase Auth (Argon2). Refresh token rotation on use. No card data on application servers — Stripe handles PCI scope. CSRF protection via Next.js built-in SameSite cookie defaults.

**GDPR deletion cascade policy:**
- Solve history → hard delete
- Swap records → anonymize (seller/buyer replaced with `deleted_user` sentinel UUID)
- Reputation scores → delete
- Badge awards → delete
- Audit log → retain with anonymized user ID (legally required for accountability)
- Auth account → hard delete via Supabase Admin API
Implemented as a queued Supabase Edge Function; 30-day SLA tracked per deletion request.

### API & Communication Patterns

**Route Handler surface (all others use Supabase client directly):**
- `POST /api/sync/solves` — offline solve queue sync; idempotent on client-generated UUID
- `POST /api/import/msp` — MSP CSV import; streamed row-by-row, per-row error reporting
- `GET /api/barcode/[code]` — proxies external barcode APIs; caches hits in internal catalog
- `POST /api/webhooks/stripe` — Stripe webhook handler; signature verified before processing
- `POST /api/admin/*` — admin mutations; service role only, role-checked in middleware

**Barcode lookup (three-tier):**
1. Internal puzzle catalog (exact UPC match — fastest, no external call)
2. Open Food Facts API (free, open-source, broad UPC coverage)
3. UPC Item DB free tier (fallback)
Successful external lookups are cached in the internal catalog — repeat scans never hit external APIs. Manual search is always one tap away and never gated on barcode success.

**Email:** Resend with React Email templates. Free tier (3K emails/month) covers V1. Used for: swap activity notifications, dispute status updates, subscription receipts. Supabase Auth handles auth emails (magic link, password reset) independently.

**Real-time:** Supabase Realtime subscriptions for in-app swap notifications (request received, accepted, declined). Polling (on-load refresh) for leaderboards in V1 — matches PRD spec; revisit in V1.5 if engagement data shows demand.

**Error handling standard:** All Route Handlers return consistent JSON error shape `{ error: string, code: string }`. Zod validation errors surfaced as field-level messages in the UI, never as generic failures. Stripe webhook failures logged to Sentry and retried via Stripe's built-in retry logic.

### Frontend Architecture

**Server state:** TanStack Query (React Query) in Client Components — stale-while-revalidate, optimistic updates for solve log flow, background refetch for swap inbox and notification count. Server Components use Supabase client directly for initial page render (no TanStack Query on server).

**Client state:** Zustand with two stores:
- `timerStore` — active solve timer state (running, elapsed time, associated puzzle); persists across tab navigation; cleared on solve save or cancel
- `offlineStore` — queued solve count for UI indicator; synced from IndexedDB on app load

**Offline solve queue:**
- Serwist Service Worker intercepts `POST /api/sync/solves` when offline; queues the request
- `idb` library persists the queue in IndexedDB (survives browser close)
- On reconnect, Service Worker replays queue against the sync endpoint
- Each queued solve carries a client-generated UUID; sync endpoint is fully idempotent

**Forms:** React Hook Form + Zod across all forms. Zod schemas are the single source of truth — defined in `lib/schemas/` and imported by both client-side forms and Route Handler validation.

**Component architecture:** Feature-first co-location under `components/[feature]/`; shared primitives in `components/ui/` (shadcn/ui); 8 bespoke custom components (TimerScreen, SolveConfirmation, PostCompletionScreen, ConditionGradeSelector, ReputationBadge, PuzzlePassportCard, ImportReviewCard, SolveJournalEntry) built with Tailwind utilities as specified in UX design.

### Infrastructure & Deployment

**Hosting cost at launch:**

| Service | Plan | Monthly |
|---|---|---|
| Vercel | Hobby → Pro at launch | $0 → $20 |
| Supabase | Free → Pro at launch | $0 → $25 |
| Resend | Free tier | $0 |
| Sentry | Free tier | $0 |
| Stripe | Per-transaction | 2.9% + $0.30 |
| **Total** | | **~$45/month** |

**CI/CD:** Vercel auto-deploy on push to `main`. GitHub Actions for pre-merge checks: Vitest unit tests, TypeScript type check, axe-core accessibility scan. Vercel preview deployments on every PR at no additional cost.

**Environments:** `development` (local Supabase via Docker + `supabase start`), `preview` (Vercel preview deploy + Supabase staging project), `production` (Vercel Pro + Supabase Pro). Environment variables managed in Vercel dashboard; `.env.local` for local development (gitignored).

**Monitoring:** Sentry free tier for error tracking with source maps. Vercel Analytics for Core Web Vitals and Lighthouse scores. Supabase dashboard for DB metrics and slow query identification.

**Scaling path:** Stateless Next.js on Vercel scales horizontally by default. Supabase Pro adds connection pooling (PgBouncer) and read replicas when needed. No re-architecture required to reach 10K MAU — only tier upgrades.

### Decision Impact Analysis

**Implementation Sequence:**
1. Scaffold project (`with-supabase` starter + post-init packages)
2. Configure Supabase local dev + initial schema migrations + RLS policies
3. Configure Next.js Middleware (auth + premium gating + admin role check)
4. Implement Serwist Service Worker + offline solve queue
5. Build core logging flow (TimerScreen → SolveConfirmation → PostCompletionScreen)
6. Build puzzle catalog (SSG pages + barcode lookup Route Handler)
7. Build MSP CSV import (Route Handler + fuse.js fuzzy matching + ImportReviewCard)
8. Build swap marketplace (listings, condition grading, reputation scoring)
9. Integrate Stripe subscriptions + premium gating enforcement
10. Build admin panel (dispute queue, audit log, catalog moderation)

**Cross-Component Dependencies:**
- RLS policies must be in place before any user-facing feature is built
- Supabase `subscriptions` table + middleware must exist before any premium-gated UI is built
- Barcode lookup Route Handler is shared by logging flow and swap listing creation
- Zod schemas in `lib/schemas/` are shared between client forms and Route Handler validation
- `timerStore` (Zustand) must be initialized before TimerScreen and tab navigation interact
- Idempotency UUID pattern for offline sync must be consistent with solve logging schema from day one

## Implementation Patterns & Consistency Rules

### Pattern Categories Defined

**Critical conflict points identified:** 8 areas where AI agents could make incompatible choices without explicit rules — naming conventions, Supabase client instantiation, query key management, error response shape, image storage paths, env var access, date formatting, and Zustand store proliferation.

### Naming Patterns

**Database Naming Conventions (PostgreSQL/Supabase):**
- Tables: `snake_case` plural — `users`, `solve_logs`, `puzzle_catalog`, `swap_listings`, `user_roles`
- Columns: `snake_case` — `user_id`, `piece_count`, `created_at`, `condition_grade`
- Foreign keys: `{referenced_table_singular}_id` — `user_id`, `puzzle_id`, `listing_id`
- Indexes: `{table}_{columns}_idx` — `solve_logs_user_id_idx`, `puzzle_catalog_upc_idx`
- RLS policies: `{table}_{action}_{subject}` — `solve_logs_select_own`, `puzzle_catalog_select_public`
- Migrations: `YYYYMMDDHHMMSS_{description}.sql` — Supabase default; never rename after applying

**API Naming Conventions:**
- Route Handlers: plural nouns, kebab-case path segments — `/api/solve-logs`, `/api/swap-listings`, `/api/barcode/[code]`
- HTTP verbs match intent: `GET` read, `POST` create/action, `PATCH` partial update, `DELETE` remove
- Query params: `snake_case` — `?user_id=`, `?piece_count=`, `?sort_by=`
- No verb-in-path patterns — never `/api/getUser` or `/api/doImport`

**TypeScript/Code Naming:**
- Components: PascalCase file and export — `TimerScreen.tsx`, `SolveJournalEntry.tsx`
- Hooks: `use` prefix, camelCase — `useTimer`, `useSolveQueue`, `useReputation`
- Types/Interfaces: PascalCase — `SolveLog`, `SwapListing`, `UserProfile`, `ConditionGrade`
- Zod schemas: camelCase + `Schema` suffix — `solveLogSchema`, `swapListingSchema`
- Supabase query functions: verb-noun, camelCase — `getSolvesByUser`, `createSwapListing`
- Zustand stores: camelCase + `Store` suffix in filename — `timer.store.ts`; exported hook is `useTimerStore`
- TanStack Query key factories: defined in `lib/query-keys.ts`, accessed as `queryKeys.solves.byUser(userId)`
- Constants/enums: `SCREAMING_SNAKE_CASE` — `CONDITION_GRADE.EXCELLENT`, `SUBSCRIPTION_TIER.PREMIUM`

### Structure Patterns

**Project Organization:**
```
app/
  (public)/          ← SSR/SSG routes — catalog, landing, marketing
  (app)/             ← Authenticated SPA routes — dashboard, logging, marketplace
  api/               ← Route Handlers only
components/
  ui/                ← shadcn/ui primitives (never modify directly)
  [feature]/         ← Feature-scoped components (solve-log/, marketplace/, import/, etc.)
lib/
  supabase/
    client.ts        ← Browser Supabase client (singleton)
    server.ts        ← Server Component / Route Handler client
    middleware.ts    ← Middleware client
  schemas/           ← Zod schemas (shared client + server)
  query-keys.ts      ← All TanStack Query key factories
  env.ts             ← Env var validation schema (Zod, run at startup)
  [domain]/          ← Domain logic: reputation/, gamification/, fuzzy-match/, barcode/
store/               ← Zustand stores only
hooks/               ← Custom React hooks
e2e/                 ← Playwright E2E tests (project root)
supabase/
  migrations/        ← SQL migration files
  seed.sql           ← Development seed data
```

**Tests:** Co-located with source — `TimerScreen.test.tsx` next to `TimerScreen.tsx`. E2E only in `e2e/`.

**Three Supabase client instances — always use the correct one:**
- `lib/supabase/client.ts` → Client Components only
- `lib/supabase/server.ts` → Server Components and Route Handlers
- `lib/supabase/middleware.ts` → `middleware.ts` only
Never instantiate a Supabase client inline. Never create a fourth pattern.

### Format Patterns

**API Response Format:**
```typescript
// Success — return data directly, no wrapper envelope
return NextResponse.json(data)

// Error — always exactly this shape
return NextResponse.json(
  { error: 'Human-readable message', code: 'kebab-case-code' },
  { status: 400 }
)
```
Error codes are kebab-case constants: `'not-found'`, `'unauthorized'`, `'validation-error'`, `'barcode-not-found'`, `'stripe-webhook-invalid'`

**Date/Time:** ISO 8601 strings in all API responses and DB storage (`2026-04-25T20:00:00Z`). Never Unix timestamps in JSON. Display via `Intl.DateTimeFormat` with locale — never `date.toLocaleDateString()`.

**DB vs TypeScript types:** Use Supabase-generated types (`database.types.ts`) directly — never manually re-type what Supabase generates. Run `supabase gen types typescript` after every migration and commit the output.

**Null vs undefined:** `null` in PostgreSQL/Supabase — handle it explicitly. `undefined` for optional TypeScript properties. Never silently coerce `null → undefined`.

### State Management Patterns

**Zustand — two stores only in V1:**
```typescript
// store/timer.store.ts
export const useTimerStore = create<TimerStore>()(...)

// store/offline.store.ts
export const useOfflineStore = create<OfflineStore>()(...)
```
Do not add new Zustand stores without architectural review. Most state belongs in TanStack Query (server state) or local component state (ephemeral UI state).

**TanStack Query key hierarchy — always import from `lib/query-keys.ts`:**
```typescript
export const queryKeys = {
  solves: {
    all: ['solves'] as const,
    byUser: (userId: string) => ['solves', userId] as const,
    detail: (solveId: string) => ['solves', 'detail', solveId] as const,
  },
  catalog: {
    search: (query: string) => ['catalog', 'search', query] as const,
    puzzle: (puzzleId: string) => ['catalog', puzzleId] as const,
  },
  // ... all other keys
}
```
Never inline query keys as strings — always use `queryKeys.*`.

**Optimistic updates:** Always implement rollback. On server error, restore previous data via `queryClient.setQueryData`. Never leave the UI in an inconsistent state after a failed mutation.

### Process Patterns

**Error handling — three layers:**
1. **Route Handler:** `try/catch` → log to Sentry → return `{ error, code }` JSON with appropriate HTTP status
2. **TanStack Query:** `onError` callback → display inline error state (never `console.error` only)
3. **React:** Error Boundary wraps each major feature section — prevents one broken component crashing the app

**Form validation:**
```typescript
// Always safeParse — never parse() which throws
const result = solveLogSchema.safeParse(formData)
if (!result.success) {
  return { fieldErrors: result.error.flatten().fieldErrors }
  // Surface inline below the field — never in a modal
}
```

**Loading states by context:**
- List/feed content → skeleton screens (`<Skeleton />` from shadcn/ui)
- Point operations (submit, barcode scan, save) → button spinner + disabled state
- Full page initial load → Next.js `loading.tsx` with skeleton layout
- Never: full-screen spinner overlay for progressively-loadable content

**Offline solve idempotency:** Every queued solve carries a `client_id` generated via `crypto.randomUUID()`. Sync endpoint uses `ON CONFLICT (client_id) DO NOTHING`. Safe to replay the queue multiple times.

**Image storage paths — always use defined structure:**
- Swap photos: `swap-photos/{listing_id}/{filename}`
- Solve photos: `solve-photos/{user_id}/{solve_id}/{filename}`
- Puzzle catalog: `puzzle-images/{puzzle_id}/cover.{ext}`
Never user-chosen paths — predictable structure enables RLS policies and CDN cache control.

**Environment variables — always via `lib/env.ts`:**
```typescript
// lib/env.ts — validated at startup with Zod
export const env = envSchema.parse(process.env)

// Everywhere else — import env, never process.env directly
import { env } from '@/lib/env'
```
Never `NEXT_PUBLIC_` prefix for secrets. Never `process.env.X` outside `lib/env.ts`.

### Enforcement Guidelines

**All AI agents MUST:**
- Import Supabase clients only from `lib/supabase/{client|server|middleware}.ts`
- Import all query keys from `lib/query-keys.ts` — never inline strings
- Import Zod schemas from `lib/schemas/` — never redefine validation in components or Route Handlers
- Return `NextResponse.json({ error, code })` for all Route Handler errors — no other shape
- Run `supabase gen types typescript` after every migration — never manually write DB types
- Use `next/image` for all images — never `<img>` tags
- Apply `prefers-reduced-motion` check on all Framer Motion animations

**Anti-patterns to reject in code review:**
- ❌ `createClient()` inside a Server Component body (use `lib/supabase/server.ts`)
- ❌ `process.env.STRIPE_SECRET_KEY` in a component (use `lib/env.ts`)
- ❌ `queryClient.invalidateQueries('solves')` with a raw string (use `queryKeys.solves.all`)
- ❌ `date.toLocaleDateString()` for display (use `Intl.DateTimeFormat`)
- ❌ Images stored at arbitrary user-chosen paths
- ❌ A third Zustand store added without architectural justification
- ❌ Manual TypeScript types that duplicate Supabase-generated types

## Project Structure & Boundaries

### Requirements to Structure Mapping

**FR Category → Location:**

| FR Category | Primary Location |
|---|---|
| Solve Logging & Tracking (FR1–7, FR49) | `app/(app)/log/`, `components/solve-log/`, `app/api/sync/` |
| Puzzle Catalog (FR8–13) | `app/(public)/catalog/`, `app/(app)/catalog/`, `app/api/barcode/` |
| Data Import & Export (FR14–19) | `app/(app)/import/`, `app/api/import/`, `lib/fuzzy-match/` |
| Gamification & Dashboard (FR20–25, FR50–52) | `app/(app)/dashboard/`, `components/dashboard/`, `lib/gamification/` |
| Swap Marketplace (FR26–33, FR53) | `app/(app)/marketplace/`, `components/marketplace/`, `lib/reputation/` |
| User Accounts & Subscriptions (FR34–40) | `app/(app)/settings/`, `app/api/webhooks/stripe/`, `lib/stripe/` |
| Community & Social (FR41–43, FR54–56) | `app/(app)/community/`, `components/community/` |
| Platform Administration (FR44–48) | `app/(admin)/`, `components/admin/`, `app/api/admin/` |

### Complete Project Directory Structure

```
puzzle-times-recorder/
├── .env.local                          ← Local dev secrets (gitignored)
├── .env.example                        ← Template for all required env vars
├── .gitignore
├── next.config.ts                      ← Serwist PWA plugin configured here
├── tailwind.config.ts                  ← Design tokens: color, typography, spacing
├── tsconfig.json
├── middleware.ts                       ← Auth check + premium gating + admin role
├── package.json
│
├── .github/
│   └── workflows/
│       └── ci.yml                      ← Vitest + tsc + axe-core on PR
│
├── public/
│   ├── manifest.json                   ← PWA manifest
│   ├── icons/                          ← PWA app icons (all sizes)
│   └── fonts/                          ← Plus Jakarta Sans + Fraunces (self-hosted)
│
├── messages/                           ← next-intl translation files
│   └── en.json                         ← English (launch language)
│
├── e2e/                                ← Playwright E2E tests
│   ├── solve-log.spec.ts               ← 3-tap log flow, offline queue
│   ├── import.spec.ts                  ← MSP CSV import happy + partial path
│   ├── marketplace.spec.ts             ← Listing creation + swap flow
│   └── fixtures/
│       └── msp-export.csv              ← Test fixture for import tests
│
├── supabase/
│   ├── config.toml
│   ├── seed.sql                        ← Dev seed: sample puzzles, users, solves
│   └── migrations/
│       ├── 20260425000001_users.sql
│       ├── 20260425000002_puzzle_catalog.sql
│       ├── 20260425000003_solve_logs.sql
│       ├── 20260425000004_gamification.sql
│       ├── 20260425000005_swap_marketplace.sql
│       ├── 20260425000006_subscriptions.sql
│       ├── 20260425000007_community.sql
│       └── 20260425000008_admin_audit.sql
│
├── store/                              ← Zustand stores (two only)
│   ├── timer.store.ts                  ← Active solve timer state
│   └── offline.store.ts                ← Queued solve count indicator
│
├── hooks/                              ← Custom React hooks
│   ├── useTimer.ts                     ← Timer start/stop/elapsed logic
│   ├── useSolveQueue.ts                ← IndexedDB offline queue interaction
│   ├── useBarcodeScan.ts               ← @zxing/browser camera API wrapper
│   └── useRealtimeSwaps.ts             ← Supabase Realtime swap notifications
│
├── components/
│   ├── ui/                             ← shadcn/ui primitives (never modify)
│   │   ├── button.tsx
│   │   ├── card.tsx
│   │   ├── dialog.tsx
│   │   ├── skeleton.tsx
│   │   ├── progress.tsx
│   │   └── ...
│   │
│   ├── solve-log/                      ← FR1–7, FR49
│   │   ├── TimerScreen.tsx             ← Full-screen dark timer (custom component)
│   │   ├── TimerScreen.test.tsx
│   │   ├── SolveConfirmation.tsx       ← Pre-save: puzzle ID + optional enrichment
│   │   ├── PostCompletionScreen.tsx    ← Emotional peak: PB, streak, rank, share
│   │   ├── PostCompletionScreen.test.tsx
│   │   └── SolveJournalEntry.tsx       ← Atomic unit of the home journal
│   │
│   ├── catalog/                        ← FR8–13
│   │   ├── PuzzleCard.tsx              ← Grid/list item for catalog browse
│   │   ├── PuzzleDetail.tsx            ← Full puzzle detail view
│   │   ├── RatingForm.tsx              ← Community rating + micro-review
│   │   ├── CatalogSearch.tsx           ← Command-palette search overlay
│   │   └── BarcodeScanOverlay.tsx      ← Camera viewfinder + scan feedback
│   │
│   ├── import/                         ← FR14–19
│   │   ├── ImportUploader.tsx          ← CSV file drop/select
│   │   ├── ImportProgress.tsx          ← Progress bar + matched/unmatched counts
│   │   ├── ImportReviewCard.tsx        ← Card-stack unmatched solve resolver (custom)
│   │   └── ImportCompletionCard.tsx    ← Shareable Pioneer Migrator milestone card
│   │
│   ├── dashboard/                      ← FR20–25, FR50–52
│   │   ├── StatsHeader.tsx             ← Streak, solve count, global rank
│   │   ├── PersonalBestGrid.tsx        ← PBs by piece count category
│   │   ├── SolveTrendChart.tsx         ← Improvement trend over time
│   │   ├── StreakDisplay.tsx           ← Streak counter + shield status
│   │   └── GoalProgressMeter.tsx       ← FR50: annual/monthly goal tracker
│   │
│   ├── gamification/                   ← FR22–23, FR51–52
│   │   ├── BadgeDisplay.tsx            ← Badge grid with stamp animations
│   │   ├── BadgeUnlockAnimation.tsx    ← Per-badge-type Framer Motion animation
│   │   └── FormerChampionBadge.tsx     ← FR52: permanent displaced record badge
│   │
│   ├── marketplace/                    ← FR26–33, FR53
│   │   ├── ConditionGradeSelector.tsx  ← Trust-teaching grade picker (custom)
│   │   ├── ConditionGradeSelector.test.tsx
│   │   ├── ReputationBadge.tsx         ← Trust score + history expander (custom)
│   │   ├── ListingCard.tsx             ← Marketplace grid item
│   │   ├── ListingDetail.tsx           ← Full listing view + swap request
│   │   ├── SwapInbox.tsx               ← Incoming/outgoing swap requests
│   │   ├── SwapConfirmation.tsx        ← Post-swap rating + receipt flow
│   │   ├── DisputeReportForm.tsx       ← FR32: buyer dispute submission
│   │   └── ISOAlertForm.tsx            ← FR53: "In Search Of" alert setup
│   │
│   ├── profile/                        ← FR34–35, FR39–40
│   │   ├── PuzzlePassportCard.tsx      ← Shareable identity artifact (custom)
│   │   ├── ProfileForm.tsx             ← Display name, avatar, location
│   │   └── NotificationPreferences.tsx ← FR39: per-channel notification toggles
│   │
│   ├── community/                      ← FR41–43, FR54–56
│   │   ├── LeaderboardTable.tsx        ← Contextual rank display
│   │   ├── ActivityFeed.tsx            ← Friend solve activity
│   │   ├── PuzzleOfTheWeek.tsx         ← FR54: weekly featured puzzle card
│   │   └── CuratedListCard.tsx         ← FR55: user-created puzzle lists
│   │
│   ├── admin/                          ← FR44–48
│   │   ├── DisputeQueue.tsx            ← Dispute list + detail view
│   │   ├── AuditLog.tsx                ← Tamper-evident action log
│   │   ├── CatalogMerger.tsx           ← FR48: duplicate puzzle merge tool
│   │   └── AccountRestrictionPanel.tsx ← FR45: tiered seller restrictions
│   │
│   └── shared/                         ← Cross-feature shared components
│       ├── ShareButton.tsx             ← Web Share API + clipboard fallback
│       ├── OfflineIndicator.tsx        ← Queued solve count banner
│       ├── PremiumGate.tsx             ← Wrapper: upsell prompt for free users
│       └── EmptyState.tsx              ← Consistent empty state template
│
├── app/
│   ├── globals.css
│   ├── layout.tsx                      ← Root layout: fonts, providers, i18n
│   │
│   ├── (public)/                       ← SSR/SSG — no auth required
│   │   ├── layout.tsx                  ← Public nav (no tab bar)
│   │   ├── page.tsx                    ← Landing/marketing page
│   │   ├── login/page.tsx
│   │   ├── signup/page.tsx
│   │   └── catalog/
│   │       ├── page.tsx                ← Catalog browse (SSG, SEO)
│   │       └── [slug]/
│   │           └── page.tsx            ← Puzzle detail (ISR, SEO)
│   │
│   ├── (app)/                          ← Authenticated SPA — middleware-protected
│   │   ├── layout.tsx                  ← Tab bar + FAB + PWA install prompt
│   │   ├── home/page.tsx               ← Stats header + journal entries
│   │   ├── log/
│   │   │   └── page.tsx                ← Timer initiation
│   │   ├── import/
│   │   │   ├── page.tsx                ← Upload step
│   │   │   ├── review/page.tsx         ← Unmatched solve review queue
│   │   │   └── complete/page.tsx       ← Pioneer Migrator celebration
│   │   ├── dashboard/page.tsx          ← Personal analytics
│   │   ├── collection/page.tsx         ← Puzzle collection manager
│   │   ├── marketplace/
│   │   │   ├── page.tsx                ← Browse listings
│   │   │   ├── new/page.tsx            ← Create listing
│   │   │   ├── [id]/page.tsx           ← Listing detail
│   │   │   ├── my-listings/page.tsx    ← Manage own listings
│   │   │   └── swaps/page.tsx          ← Active swaps inbox
│   │   ├── community/
│   │   │   ├── page.tsx                ← Activity feed
│   │   │   └── leaderboards/page.tsx
│   │   ├── profile/
│   │   │   ├── page.tsx                ← Puzzle Passport view
│   │   │   └── [username]/page.tsx     ← Other user's public profile
│   │   └── settings/
│   │       ├── page.tsx                ← Account settings
│   │       ├── subscription/page.tsx   ← Plan management
│   │       └── notifications/page.tsx
│   │
│   ├── (admin)/                        ← Admin panel — role-checked in middleware
│   │   ├── layout.tsx
│   │   ├── page.tsx                    ← Admin dashboard
│   │   ├── disputes/page.tsx           ← FR44: dispute queue
│   │   ├── catalog/page.tsx            ← FR48: catalog moderation
│   │   └── users/[id]/page.tsx         ← FR45: user restriction management
│   │
│   └── api/
│       ├── sync/
│       │   └── solves/route.ts         ← POST: offline solve sync (idempotent)
│       ├── import/
│       │   └── msp/route.ts            ← POST: MSP CSV import processor
│       ├── barcode/
│       │   └── [code]/route.ts         ← GET: three-tier barcode lookup proxy
│       ├── webhooks/
│       │   └── stripe/route.ts         ← POST: Stripe webhook handler
│       └── admin/
│           ├── disputes/route.ts       ← PATCH: dispute resolution actions
│           ├── catalog/route.ts        ← PATCH/DELETE: catalog moderation
│           └── users/[id]/route.ts     ← PATCH: account restrictions
│
└── lib/
    ├── supabase/
    │   ├── client.ts                   ← Browser client (Client Components)
    │   ├── server.ts                   ← Server client (Server Components + Route Handlers)
    │   ├── middleware.ts               ← Middleware client
    │   └── database.types.ts           ← Auto-generated — run after every migration
    │
    ├── schemas/                        ← Zod schemas (shared client + server)
    │   ├── solve-log.schema.ts
    │   ├── import.schema.ts
    │   ├── marketplace.schema.ts
    │   ├── profile.schema.ts
    │   └── admin.schema.ts
    │
    ├── query-keys.ts                   ← All TanStack Query key factories
    ├── env.ts                          ← Env var validation (Zod, startup)
    │
    ├── barcode/
    │   ├── index.ts                    ← Three-tier lookup orchestrator
    │   ├── open-food-facts.ts          ← Open Food Facts API client
    │   └── upc-item-db.ts              ← UPC Item DB fallback client
    │
    ├── fuzzy-match/
    │   └── index.ts                    ← fuse.js config + MSP title matching
    │
    ├── gamification/
    │   ├── badges.ts                   ← Badge definitions + evaluation logic
    │   ├── streaks.ts                  ← Streak calculation + shield logic
    │   └── personal-bests.ts           ← PB detection + Former Champion trigger
    │
    ├── reputation/
    │   ├── score.ts                    ← Reputation score calculation
    │   └── disputes.ts                 ← Dispute state machine
    │
    ├── stripe/
    │   ├── client.ts                   ← Stripe server-side client
    │   └── subscriptions.ts            ← Plan management helpers
    │
    ├── notifications/
    │   ├── email.ts                    ← Resend client + send helpers
    │   └── realtime.ts                 ← Supabase Realtime subscription helpers
    │
    └── i18n/
        ├── config.ts                   ← next-intl configuration
        └── request.ts                  ← Server-side locale resolution
```

### Architectural Boundaries

**API Boundaries — Route Handler contracts:**
- `POST /api/sync/solves` — accepts `{ client_id, puzzle_id, duration_ms, logged_at, photo_url?, note? }[]`; returns `{ synced: number, skipped: number }`
- `POST /api/import/msp` — accepts `multipart/form-data` with CSV; returns `{ matched_count, unmatched_count, error_count }`
- `GET /api/barcode/[code]` — returns `{ puzzle_id?, title?, brand?, piece_count?, found: boolean }`
- `POST /api/webhooks/stripe` — Stripe signature verified; updates `subscriptions` table; returns `{ received: true }`
- `POST /api/admin/*` — all require service role + admin role header; return audit log entry on success

**Component Boundaries:**
- `TimerScreen` → writes to `timerStore` only; reads nothing from server during active solve
- `PostCompletionScreen` → receives solve result as props; triggers badge evaluation query on mount
- `ConditionGradeSelector` → fully self-contained; outputs a `ConditionGrade` enum value via `onChange`
- `ReputationBadge` → fetches full swap history via TanStack Query on user expansion tap
- `ImportReviewCard` → card-stack pattern; parent manages queue array; card signals resolution upward via callback; never manages its own queue position

**Data Boundaries:**
- All user data behind RLS — Supabase anon key + user session restricts to own rows automatically
- Puzzle catalog + leaderboards — open read policy; authenticated write only
- Admin operations — Supabase service role key, server-side only, never in client bundle
- Stripe — app stores only `stripe_customer_id`, `subscription_status`, `tier`; no card data ever
- Images — never proxy through Next.js server; client uploads directly to Supabase Storage via presigned URL

### Integration Points

**External Services:**

| Service | Integration Point | Auth |
|---|---|---|
| Supabase DB + Auth | `lib/supabase/*.ts` | Anon key (client) / Service role (server) |
| Supabase Storage | Presigned URL — client direct upload | RLS policy |
| Supabase Realtime | `hooks/useRealtimeSwaps.ts` | User session |
| Stripe | `lib/stripe/client.ts` + `/api/webhooks/stripe` | Secret key (server only) |
| Resend | `lib/notifications/email.ts` | API key (server only) |
| Open Food Facts | `lib/barcode/open-food-facts.ts` | None (public API) |
| Sentry | `instrumentation.ts` | DSN (server + client) |

**Critical Data Flow — solve logging:**
```
User taps Stop
  → timerStore.stop()
  → SolveConfirmation renders with elapsed time
  → User confirms puzzle (barcode hit or manual search)
  → User taps Save
    → Online:  POST /api/sync/solves → Supabase insert → badge eval → PostCompletionScreen
    → Offline: idb queue push → offlineStore.increment() → PostCompletionScreen (optimistic)
               On reconnect: Serwist replays queue → same online path
```

**Critical Data Flow — MSP import:**
```
CSV upload → POST /api/import/msp
  → papaparse streams rows
  → fuse.js fuzzy match per row against puzzle_catalog
  → Matched: insert to solve_logs (import_batch_id tagged)
  → Unmatched: insert to import_unmatched_queue
  → Client receives counts → renders ImportReviewCard stack
  → Each card resolution → PATCH solve_logs or mark custom_puzzle
  → 100% complete → badge evaluation → Pioneer Migrator awarded
```

### Development Workflow

**Local dev startup:**
```bash
supabase start    # Local Postgres + Auth + Storage via Docker
npm run dev       # Next.js with Turbopack
```

**After any schema change:**
```bash
supabase db push
supabase gen types typescript --local > lib/supabase/database.types.ts
```

**Before any PR merge (CI enforces):**
```bash
npm run type-check    # tsc --noEmit
npm run test          # Vitest
npm run test:a11y     # axe-core accessibility scan
```

## Architecture Validation Results

### Coherence Validation ✅

All 13 technology choices are mutually compatible. Next.js App Router + Supabase SSR, Serwist PWA, next-intl, TanStack Query (client only), shadcn/ui, Framer Motion, React Hook Form + Zod — all have official or well-established App Router integration paths with no version conflicts as of April 2026.

Patterns are internally consistent: three Supabase client instances match Supabase's official App Router guidance; RLS at DB layer + middleware role checks at routing layer are defense-in-depth, not contradiction; Zod schemas in `lib/schemas/` shared between forms and Route Handlers eliminate validation drift; query key factory aligns with TanStack Query v5 conventions.

### Requirements Coverage Validation ✅

All 56 functional requirements are architecturally supported. All 8 FR categories have dedicated directories, components, and domain logic modules. Every NFR is addressed:

| NFR | Architecture Response |
|---|---|
| FCP ≤2.5s mobile | Next.js ISR + self-hosted fonts + Lighthouse CI gate |
| Offline zero data loss | Serwist + idb + UUID-idempotent sync endpoint |
| 10× growth without re-arch | Stateless Vercel + Supabase PgBouncer horizontal scale |
| WCAG 2.1 AA | Radix UI primitives + axe-core CI + manual pre-launch checklist |
| GDPR right-to-deletion | Cascade policy per entity + Supabase Edge Function + 30-day SLA |
| Barcode ≥80% match | Three-tier lookup + internal catalog cache |
| Stripe PCI | No card data on app servers — fully delegated |

### Gap Analysis Results

**Minor gaps (not blocking — all fit within defined structure):**

1. **FR11 + FR12** — "Report missing puzzle" and "Submit new puzzle" forms not explicitly named in components. Add `ReportMissingPuzzleForm.tsx` and `SubmitPuzzleForm.tsx` to `components/catalog/`.

2. **FR18** — Universal spreadsheet import is a format-detection variation of the MSP import Route Handler. Add format auto-detection to `lib/fuzzy-match/`; no new Route Handler needed.

3. **FR19** — Data export needs `app/api/export/route.ts` (streams ZIP of user data) and a trigger in `settings/page.tsx`. Fits the defined structure without architectural change.

4. **FR56** — Admin-designated sponsored Puzzle of the Week needs a toggle in `admin/catalog/page.tsx`. Minor UI addition, no new components or patterns.

No critical gaps. No architectural changes required to implement any of the above.

### Architecture Completeness Checklist

**✅ Requirements Analysis**
- [x] 56 functional requirements analyzed and categorized
- [x] Scale and complexity assessed (Medium-High, 0–10K MAU target)
- [x] Technical constraints identified (PWA mandate, offline-first, SEO hybrid)
- [x] 10 cross-cutting concerns mapped

**✅ Architectural Decisions**
- [x] Data access pattern (Server Components + targeted Route Handlers)
- [x] Row Level Security strategy (all tables, policy naming convention)
- [x] Authentication + premium gating + admin roles
- [x] Offline sync (Serwist + idb + idempotent UUID)
- [x] Barcode lookup (three-tier with internal caching)
- [x] GDPR deletion cascade policy (per-entity)
- [x] Infrastructure + hosting cost (~$45/month at launch)

**✅ Implementation Patterns**
- [x] Database, API, and code naming conventions with examples
- [x] Three Supabase client instances — when to use each
- [x] API error response shape — single enforced format
- [x] Query key factory pattern
- [x] Zustand — two stores only, justified
- [x] Form validation (safeParse + field-level errors)
- [x] Loading state patterns by context
- [x] Image storage path structure
- [x] Env var access via `lib/env.ts` only
- [x] Anti-patterns list for code review

**✅ Project Structure**
- [x] Complete directory tree with all files annotated
- [x] All 56 FRs mapped to specific directories
- [x] All 8 bespoke custom components (UX spec) located
- [x] Route Handler API contracts defined
- [x] Component boundaries documented
- [x] Data flow diagrams for critical paths (solve log, MSP import)
- [x] External service integration points mapped

### Architecture Readiness Assessment

**Overall Status: READY FOR IMPLEMENTATION**

**Confidence Level: High**

**Key Strengths:**
- Cheapest viable production stack (~$45/month) with clear upgrade path to 10K MAU
- Every V1 success criterion (offline solve, 3-tap log, MSP import, swap marketplace) has explicit architectural support
- Implementation patterns prevent the most common AI agent conflict points
- Supabase RLS eliminates an entire class of data leakage bugs by default
- ISR catalog pages + authenticated SPA coexist cleanly in Next.js App Router route groups

**Areas for Future Enhancement (post-V1):**
- WebSocket real-time for leaderboards (currently polling)
- Dark mode activation (Tailwind `dark:` architected, not activated)
- Native iOS/Android apps (PWA covers V1; revisit if adoption data demands it)
- AI coach + recommendation engine (V1.5 — data model ready from V1)
- B2B manufacturer data API (schema ready, feature deferred to V2)

### Implementation Handoff

**First implementation command:**
```bash
npx create-next-app -e with-supabase puzzle-times-recorder
```

**Immediate next steps after scaffolding:**
1. Install post-init packages (framer-motion, serwist, next-intl, stripe, fuse.js, papaparse, browser-image-compression, @zxing/browser, idb)
2. Configure `lib/env.ts` with all required env var validation
3. Run first migration: `users` table + RLS policies
4. Configure Next.js Middleware (auth + premium gating + admin role check)
5. Configure Serwist in `next.config.ts`

**AI Agent Guidelines:**
- Follow all architectural decisions exactly as documented
- Use implementation patterns — especially Supabase client instances, query keys, error shapes, and image paths — consistently across all components
- Refer to this document when any implementation question arises about structure, naming, or patterns
- Run `supabase gen types typescript` after every migration; never write DB types manually
