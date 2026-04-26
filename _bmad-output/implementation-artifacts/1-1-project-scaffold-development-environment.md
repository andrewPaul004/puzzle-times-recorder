# Story 1.1: Project Scaffold & Development Environment

Status: ready-for-dev

## Story

As a developer,
I want the project scaffolded with all required tools, packages, and CI configured,
so that the team has a working development environment and automated quality gates from day one.

## Acceptance Criteria

1. **Given** a new machine with Node.js and Docker installed, **when** the developer follows the setup README, **then** `npm run dev` starts the Next.js app on localhost:3000 with Turbopack hot reload, **and** `supabase start` starts local Postgres, Auth, and Storage via Docker without errors.

2. **Given** the project is scaffolded, **when** the developer inspects the codebase, **then** all post-init packages are installed: `framer-motion`, `serwist`, `@serwist/next`, `next-intl`, `stripe`, `@stripe/stripe-js`, `fuse.js`, `papaparse`, `@types/papaparse`, `browser-image-compression`, `@zxing/browser`, `@zxing/library`, `idb`.

3. **Given** the scaffolded project, **when** a developer inspects `lib/env.ts`, **then** all required environment variables are validated at startup using Zod with a `safeParse` approach that fails fast on missing vars, **and** `.env.example` documents every required env var without real values, **and** all env var access throughout the codebase uses `import { env } from '@/lib/env'` — never `process.env.X` directly.

4. **Given** a developer opens a pull request, **when** the GitHub Actions CI pipeline runs, **then** `npm run type-check` (tsc --noEmit) passes with zero TypeScript errors, **and** `npm run test` (Vitest) passes, **and** `npm run test:a11y` (axe-core) reports zero critical or serious accessibility violations, **and** Vercel creates a preview deployment automatically.

5. **Given** the scaffolded project directory, **when** the developer inspects the file structure, **then** the directory structure matches the Architecture specification: `app/(public)/`, `app/(app)/`, `app/(admin)/`, `app/api/`, `components/ui/`, `components/[feature]/`, `lib/supabase/{client,server,middleware}.ts`, `lib/schemas/`, `lib/query-keys.ts`, `store/`, `hooks/`, `e2e/`, `supabase/migrations/`.

6. **Given** the scaffolded project, **when** a developer inspects `next.config.ts`, **then** Serwist is configured with a Service Worker entry point, **and** `public/manifest.json` is present with the correct PWA metadata (name, short_name, icons, display: standalone, theme_color matching `#C4603A` terracotta).

## Tasks / Subtasks

- [ ] Task 1: Initialize project from Supabase starter template (AC: 1)
  - [ ] Run `npx create-next-app -e with-supabase puzzle-times-recorder`
  - [ ] Run `npx supabase init` inside the project directory
  - [ ] Verify `npm run dev` starts cleanly on localhost:3000 with Turbopack

- [ ] Task 2: Install all post-init packages (AC: 2)
  - [ ] `npm install framer-motion`
  - [ ] `npm install serwist @serwist/next`
  - [ ] `npm install next-intl`
  - [ ] `npm install stripe @stripe/stripe-js`
  - [ ] `npm install fuse.js`
  - [ ] `npm install papaparse @types/papaparse`
  - [ ] `npm install browser-image-compression`
  - [ ] `npm install @zxing/browser @zxing/library`
  - [ ] `npm install idb`
  - [ ] Install dev tools: `npm install -D vitest @vitejs/plugin-react @testing-library/react @testing-library/user-event @axe-core/playwright @playwright/test`
  - [ ] `npm install @tanstack/react-query @tanstack/react-query-devtools`
  - [ ] `npm install zustand`
  - [ ] `npm install react-hook-form zod @hookform/resolvers`
  - [ ] Verify `npm run dev` still starts cleanly

- [ ] Task 3: Create the full project directory scaffold (AC: 5)
  - [ ] Create `app/(public)/` route group with `layout.tsx`
  - [ ] Create `app/(app)/` route group with `layout.tsx`
  - [ ] Create `app/(admin)/` route group with `layout.tsx`
  - [ ] Create `app/api/` directory structure (placeholder files for: `sync/solves/route.ts`, `import/msp/route.ts`, `barcode/[code]/route.ts`, `webhooks/stripe/route.ts`, `admin/`)
  - [ ] Create `components/ui/` (shadcn/ui primitives — already from starter)
  - [ ] Create `components/` feature subdirectories: `solve-log/`, `catalog/`, `import/`, `dashboard/`, `gamification/`, `marketplace/`, `profile/`, `community/`, `admin/`, `shared/`
  - [ ] Create `lib/supabase/client.ts`, `lib/supabase/server.ts`, `lib/supabase/middleware.ts` (wire up from starter)
  - [ ] Create `lib/schemas/` directory with a `index.ts` barrel
  - [ ] Create `lib/query-keys.ts` with the full key factory structure
  - [ ] Create `lib/env.ts` with Zod schema validation
  - [ ] Create `lib/barcode/`, `lib/gamification/`, `lib/reputation/`, `lib/fuzzy-match/` domain directories (empty index files as placeholders)
  - [ ] Create `store/timer.store.ts` and `store/offline.store.ts` (initial empty Zustand store stubs)
  - [ ] Create `hooks/` with placeholder files: `useTimer.ts`, `useSolveQueue.ts`, `useBarcodeScan.ts`, `useRealtimeSwaps.ts`
  - [ ] Create `e2e/` with empty spec files and `fixtures/` dir
  - [ ] Create `supabase/migrations/` directory (empty — populated in Story 1.2)
  - [ ] Create `supabase/seed.sql` (empty placeholder)
  - [ ] Create `messages/en.json` with empty object `{}`

- [ ] Task 4: Configure environment variables (AC: 3)
  - [ ] Create `.env.example` listing all required vars:
    - `NEXT_PUBLIC_SUPABASE_URL`
    - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
    - `SUPABASE_SERVICE_ROLE_KEY`
    - `STRIPE_SECRET_KEY`
    - `NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY`
    - `STRIPE_WEBHOOK_SECRET`
    - `RESEND_API_KEY`
    - `SENTRY_DSN`
    - `OPEN_FOOD_FACTS_BASE_URL` (default: https://world.openfoodfacts.org)
    - `UPC_ITEM_DB_API_KEY`
  - [ ] Create `lib/env.ts` that Zod-validates all required vars at startup using `z.object({...}).parse(process.env)` — fails fast on missing; separate `NEXT_PUBLIC_` client vars from server-only vars
  - [ ] Verify the starter's existing `.env.local` template covers Supabase vars

- [ ] Task 5: Configure Serwist PWA Service Worker (AC: 6)
  - [ ] Configure `next.config.ts` with `@serwist/next` plugin, pointing to `app/sw.ts` as the Service Worker entry
  - [ ] Create `app/sw.ts` — minimal Serwist setup (cache app shell); offline solve sync logic is added in Epic 3 Story 3.6
  - [ ] Create `public/manifest.json` with: `name: "PuzzleTimesRecorder"`, `short_name: "PuzzleTime"`, `display: "standalone"`, `background_color: "#FAF7F2"`, `theme_color: "#C4603A"`, `icons` array (72, 96, 128, 144, 152, 192, 384, 512px)
  - [ ] Create `public/icons/` directory with placeholder PWA icon files (can be simple colored squares for now — real icons added in Story 1.3)

- [ ] Task 6: Configure TypeScript and build tooling (AC: 4)
  - [ ] Ensure `tsconfig.json` has `"strict": true` and path alias `"@/*": ["./*"]`
  - [ ] Add `npm run type-check` script: `"type-check": "tsc --noEmit"`
  - [ ] Configure `vitest.config.ts` with React plugin, jsdom environment, and path aliases matching tsconfig
  - [ ] Add `npm run test` script: `"test": "vitest"`
  - [ ] Add `npm run test:a11y` script (axe-core via Playwright): `"test:a11y": "playwright test e2e/a11y.spec.ts"`
  - [ ] Create `e2e/a11y.spec.ts` — axe-core scan of `/` and any scaffolded routes
  - [ ] Add `npm run test:e2e` script: `"test:e2e": "playwright test"`
  - [ ] Create `playwright.config.ts`

- [ ] Task 7: Set up GitHub Actions CI (AC: 4)
  - [ ] Create `.github/workflows/ci.yml`:
    - Trigger: `pull_request` to `main`, `push` to `main`
    - Jobs: `type-check` (`npm run type-check`), `test` (`npm run test`), `test:a11y` (`npm run test:a11y`)
    - Node version matrix: 20.x
    - Cache `node_modules` using `actions/cache`
  - [ ] Confirm Vercel GitHub integration is configured for preview deployments (manual step in Vercel dashboard — document in README)

- [ ] Task 8: Set up next-intl i18n foundation (AC: 5)
  - [ ] Configure `next-intl` in `next.config.ts`
  - [ ] Create `i18n.ts` (or `i18n/request.ts`) for next-intl server-side config
  - [ ] Update root `app/layout.tsx` to wrap with `NextIntlClientProvider`
  - [ ] Ensure `messages/en.json` is the single source of all UI strings (empty at this stage — strings added per feature story)

- [ ] Task 9: Create `lib/query-keys.ts` with full factory structure (AC: 5)
  - [ ] Define all anticipated query key namespaces: `solves`, `catalog`, `marketplace`, `user`, `gamification`, `community`, `admin`
  - [ ] Export as `queryKeys` object — every key function uses `as const`

- [ ] Task 10: Write setup README section (AC: 1)
  - [ ] Add "Getting Started" section to `README.md` covering: Node.js + Docker prereqs, `npm install`, `supabase start`, `npm run dev`, env var setup from `.env.example`
  - [ ] Verify the documented steps work end-to-end on a clean checkout

## Dev Notes

### Critical: Use the Official Supabase Starter

**Do not** run `npx create-next-app` bare. The starter command must be:
```bash
npx create-next-app -e with-supabase puzzle-times-recorder
```
This starter pre-wires: Supabase Auth cookie-based session handling (non-trivial to replicate), shadcn/ui, App Router, TypeScript strict mode, Tailwind, `@supabase/ssr`. Without it, auth SSR is brittle.

Post-init, immediately run:
```bash
npx supabase init
npx supabase login  # interactive — developer runs once
```

### Three Supabase Client Pattern — Non-Negotiable

The starter creates `lib/supabase/client.ts` and `lib/supabase/server.ts`. This story must:
1. Verify both exist and are correctly structured
2. Create `lib/supabase/middleware.ts` for `middleware.ts` usage
3. NEVER add a fourth client pattern anywhere

All three have distinct purposes and must NOT be cross-used:
- `client.ts` → `'use client'` components only
- `server.ts` → Server Components + Route Handlers
- `middleware.ts` → `middleware.ts` only

### `lib/env.ts` — Exact Implementation Pattern

```typescript
// lib/env.ts
import { z } from 'zod'

const envSchema = z.object({
  // Server-only (never NEXT_PUBLIC_)
  SUPABASE_SERVICE_ROLE_KEY: z.string().min(1),
  STRIPE_SECRET_KEY: z.string().min(1),
  STRIPE_WEBHOOK_SECRET: z.string().min(1),
  RESEND_API_KEY: z.string().min(1),
  SENTRY_DSN: z.string().url().optional(),
  UPC_ITEM_DB_API_KEY: z.string().optional(),
  OPEN_FOOD_FACTS_BASE_URL: z.string().url().default('https://world.openfoodfacts.org'),
  // Client-safe (NEXT_PUBLIC_ prefix required)
  NEXT_PUBLIC_SUPABASE_URL: z.string().url(),
  NEXT_PUBLIC_SUPABASE_ANON_KEY: z.string().min(1),
  NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY: z.string().min(1),
})

export const env = envSchema.parse(process.env)
```
`parse()` (not `safeParse()`) is correct here — this is a startup-time validation that SHOULD throw if misconfigured. `safeParse()` is for form validation only.

### Serwist Configuration

The `@serwist/next` integration wraps `next.config.ts`:

```typescript
// next.config.ts
import withSerwist from '@serwist/next'

const withSerwistConfig = withSerwist({
  swSrc: 'app/sw.ts',
  swDest: 'public/sw.js',
  disable: process.env.NODE_ENV === 'development', // avoid SW in dev
})

export default withSerwistConfig({
  // rest of Next.js config
})
```

The `app/sw.ts` file should be minimal at this stage — actual offline solve queue interception is implemented in Story 3.6. Install Serwist fundamentals now so the build pipeline works.

### `lib/query-keys.ts` — Full Factory Structure

Define ALL anticipated namespaces now so no story ever inlines a query key:

```typescript
// lib/query-keys.ts
export const queryKeys = {
  solves: {
    all: ['solves'] as const,
    byUser: (userId: string) => ['solves', userId] as const,
    detail: (solveId: string) => ['solves', 'detail', solveId] as const,
  },
  catalog: {
    all: ['catalog'] as const,
    search: (query: string) => ['catalog', 'search', query] as const,
    puzzle: (puzzleId: string) => ['catalog', puzzleId] as const,
  },
  marketplace: {
    all: ['marketplace'] as const,
    listings: (filters?: object) => ['marketplace', 'listings', filters] as const,
    listing: (listingId: string) => ['marketplace', listingId] as const,
    inbox: (userId: string) => ['marketplace', 'inbox', userId] as const,
  },
  user: {
    profile: (userId: string) => ['user', userId] as const,
    reputation: (userId: string) => ['user', userId, 'reputation'] as const,
  },
  gamification: {
    streak: (userId: string) => ['gamification', 'streak', userId] as const,
    badges: (userId: string) => ['gamification', 'badges', userId] as const,
    personalBests: (userId: string) => ['gamification', 'pbs', userId] as const,
  },
  community: {
    leaderboard: (puzzleId: string) => ['community', 'leaderboard', puzzleId] as const,
    feed: (userId: string) => ['community', 'feed', userId] as const,
  },
  admin: {
    disputes: ['admin', 'disputes'] as const,
    auditLog: ['admin', 'audit-log'] as const,
  },
} as const
```

### Zustand Store Stubs

Create minimal typed stubs. Real implementation in later stories:

```typescript
// store/timer.store.ts
import { create } from 'zustand'

interface TimerStore {
  isRunning: boolean
  elapsedMs: number
  associatedPuzzleId: string | null
  // Actions added in Story 3.1
}

export const useTimerStore = create<TimerStore>()(() => ({
  isRunning: false,
  elapsedMs: 0,
  associatedPuzzleId: null,
}))
```

```typescript
// store/offline.store.ts
import { create } from 'zustand'

interface OfflineStore {
  queuedCount: number
  // Actions added in Story 3.6
}

export const useOfflineStore = create<OfflineStore>()(() => ({
  queuedCount: 0,
}))
```

**IMPORTANT:** Do NOT add a third Zustand store. Two stores only for all of V1.

### GitHub Actions CI Structure

```yaml
# .github/workflows/ci.yml
name: CI
on:
  pull_request:
    branches: [main]
  push:
    branches: [main]
jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm run type-check
      - run: npm run test
      - name: Install Playwright browsers
        run: npx playwright install --with-deps chromium
      - run: npm run test:a11y
```

### next-intl Setup Notes

The `with-supabase` starter doesn't include next-intl. After installing, the minimal wiring needed at scaffold stage:

1. Add to `next.config.ts`: import and configure `createNextIntlPlugin`
2. Create `i18n/request.ts` (next-intl v3+ server config)
3. Wrap root `app/layout.tsx` with `NextIntlClientProvider`
4. `messages/en.json` stays as `{}` — all strings added in per-feature stories
5. Verify `npm run type-check` passes with the next-intl types

### Project Structure Notes

- The `with-supabase` starter ships some files that need renaming/moving to match our architecture. Specifically: the starter's auth-related pages (`/app/login`, `/app/signup`, `/protected`) should be reorganized into `app/(public)/login/` and `app/(public)/signup/`, and `app/(app)/` for authenticated routes.
- The starter's `utils/supabase/` path does NOT match our architecture (`lib/supabase/`). Rename/move these files as part of this story.
- Delete any starter example/demo pages that don't fit the architecture.
- The `components/ui/` directory from shadcn/ui is pre-populated by the starter — do not modify these files.

### Testing: What to Test in This Story

This story is infrastructure, not user-facing. Tests should be minimal and practical:

1. **`npm run type-check`** must pass zero errors — the primary quality gate.
2. **`npm run test`** — write a single smoke test confirming `lib/env.ts` exports the `env` object correctly (mock env vars in the test).
3. **`npm run test:a11y`** — axe-core scan of any rendered pages; the bare scaffold should produce zero violations.
4. Do NOT write unit tests for stub files (empty Zustand stores, empty hooks). Tests for those come with implementation in later stories.

### Critical Dependencies for Subsequent Stories

**Story 1.2 (DB Schema) REQUIRES from this story:**
- `supabase/migrations/` directory exists
- `lib/supabase/server.ts` is correctly configured
- `supabase gen types typescript` command works (produces `lib/supabase/database.types.ts`)

**Story 1.3 (Design System) REQUIRES from this story:**
- `tailwind.config.ts` is accessible and modifiable
- `public/fonts/` directory exists

**Story 1.4 (Auth) REQUIRES from this story:**
- All three Supabase client files exist
- `middleware.ts` is in place (starter provides a base version)
- `lib/env.ts` exports `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY`

**All subsequent stories REQUIRE:**
- `lib/query-keys.ts` exports `queryKeys`
- `lib/env.ts` validates and exports `env`
- `lib/schemas/` directory exists for Zod schemas

### Anti-Patterns This Story Must Not Introduce

- **Never** `process.env.ANYTHING` outside `lib/env.ts` — not even in `next.config.ts` (use `process.env` only in `lib/env.ts` itself)
- **Never** create a fourth Supabase client file
- **Never** add a third Zustand store
- **Never** inline a TanStack Query key as a string — always `queryKeys.*`
- **Never** `import { createClient } from '@supabase/supabase-js'` inline in a component or route handler
- **Never** modify files in `components/ui/` (shadcn/ui primitives)

### References

- Architecture: scaffold command, post-init packages [Source: `_bmad-output/planning-artifacts/architecture.md#Starter Template Evaluation`]
- Architecture: three Supabase client pattern [Source: `_bmad-output/planning-artifacts/architecture.md#Structure Patterns`]
- Architecture: `lib/env.ts` pattern [Source: `_bmad-output/planning-artifacts/architecture.md#Process Patterns`]
- Architecture: Serwist offline queue [Source: `_bmad-output/planning-artifacts/architecture.md#Frontend Architecture`]
- Architecture: query key factory [Source: `_bmad-output/planning-artifacts/architecture.md#State Management Patterns`]
- Architecture: full directory structure [Source: `_bmad-output/planning-artifacts/architecture.md#Complete Project Directory Structure`]
- Architecture: CI/CD [Source: `_bmad-output/planning-artifacts/architecture.md#Infrastructure & Deployment`]
- Epics: Story 1.1 AC [Source: `_bmad-output/planning-artifacts/epics.md#Story 1.1`]
- Epics: ARCH1, ARCH2 requirements [Source: `_bmad-output/planning-artifacts/epics.md#Additional Requirements`]
- CLAUDE.md: commands, branching strategy [Source: `CLAUDE.md`]

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List
