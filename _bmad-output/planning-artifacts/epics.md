---
stepsCompleted: ["step-01-validate-prerequisites", "step-02-design-epics", "step-03-create-stories", "step-04-final-validation", "epic-2-stories-added-2026-04-25", "readiness-review-fixes-2026-04-25", "fr57-fr58-added-2026-04-26"]
inputDocuments:
  - "_bmad-output/planning-artifacts/prd.md"
  - "_bmad-output/planning-artifacts/architecture.md"
  - "_bmad-output/planning-artifacts/ux-design-specification.md"
---

# PuzzleTimesRecorder - Epic Breakdown

## Overview

This document provides the complete epic and story breakdown for PuzzleTimesRecorder, decomposing the requirements from the PRD, UX Design, and Architecture requirements into implementable stories.

## Requirements Inventory

### Functional Requirements

**Solve Logging & Tracking**
- FR1: Users can start and stop a puzzle solve timer
- FR2: Users can associate a completed solve with a puzzle via barcode scan
- FR3: Users can associate a completed solve with a puzzle via manual catalog search
- FR4: Users can attach a photo to a completed solve
- FR5: Users can record a solve while offline; the solve syncs automatically when connectivity is restored
- FR6: Users can view their complete solve history with timestamps, times, and puzzle details
- FR7: Users can add a puzzle to their collection without logging a solve
- FR49: Users can attach an optional personal note or journal entry to a completed solve (context, mood, companions)

**Puzzle Catalog**
- FR8: Users can search the puzzle catalog by title, brand, piece count, and theme
- FR9: Users can view a puzzle's details including title, brand, piece count, difficulty, and aggregated community rating
- FR10: Users can submit a rating and micro-review for a puzzle they have solved
- FR11: Users can report a puzzle missing from the catalog
- FR12: Users can submit a new puzzle to the catalog via manual entry or barcode scan result
- FR13: Unauthenticated visitors can discover puzzles through publicly accessible catalog pages

**Data Import & Export**
- FR14: Users can import their solve history from a myspeedpuzzling.com CSV export
- FR15: The system matches imported solves to catalog puzzles using fuzzy title matching with confidence scores
- FR16: Users can review unmatched solves from an import and manually assign them to catalog puzzles
- FR17: Users can mark unmatched solves as custom/uncatalogued puzzles
- FR18: Users can import solve history from a universal spreadsheet template (non-MSP users)
- FR19: Users can export their complete solve history and profile data at any time

**Gamification & Personal Dashboard**
- FR20: Users can view their current solve streak and streak history
- FR21: Users can view their personal best times by puzzle and by piece count category
- FR22: Users can earn badges based on solve milestones, import completion, and platform activity
- FR23: The system awards retroactive badges to solve history (including imported history) when badge criteria are met
- FR24: Users can view a personal analytics dashboard showing solve trends, improvement over time, and solve statistics
- FR25: Premium users can apply a streak shield to protect their streak from breaking during an inactive period
- FR50: Users can set personal puzzling goals (annual or monthly targets: puzzle count, total piece count, or time-based) and track progress with a visual meter
- FR51: The system notifies both the new record holder and the displaced record holder when a personal best is surpassed by another user
- FR52: Users who are displaced from a record receive a permanent "Former Champion" badge on their profile

**Swap Marketplace**
- FR26: Users can create a swap listing with puzzle details, condition grade, photos, and description
- FR27: Users can browse and filter swap listings by puzzle title, condition grade, and location
- FR28: Users can send a swap request to a listing owner
- FR29: Listing owners can accept, decline, or counter an incoming swap request
- FR30: Users can confirm receipt of a swapped puzzle and rate the transaction and counterparty
- FR31: Users can view another user's reputation score and full swap transaction history
- FR32: Users can report a dispute on a swap transaction
- FR33: Free-tier users are limited to a set number of active swap listings; Premium Individual users have unlimited active listings
- FR53: Premium users can set "In Search Of" (ISO) alerts for specific puzzles and receive a notification when a matching swap listing is created

**User Accounts & Subscriptions**
- FR34: Users can register for an account and complete onboarding with a first solve logged within 5 minutes
- FR35: Users can manage their profile including display name, avatar, location, and puzzling preferences
- FR36: Users can upgrade to a Premium Individual subscription
- FR37: Premium Individual subscribers can access streak shields, unlimited swap listings, and enhanced analytics
- FR38: Users can manage, pause, or cancel their subscription
- FR39: Users can configure notification preferences for swap activity, badge awards, and community interactions
- FR40: Users can access the platform interface in their preferred language

**Community & Social**
- FR41: Users can view community leaderboards for solve times segmented by puzzle and piece count
- FR42: Users can follow other users and view their recent solve activity in a feed
- FR43: Users can share a completed solve to external platforms via the Web Share API
- FR54: The platform designates a weekly featured puzzle (Puzzle of the Week); users who log a solve that week appear on a time-limited special leaderboard
- FR55: Users can create, name, publish, and follow curated puzzle lists (e.g., "Best Puzzles for Beginners," "My 2026 Bucket List")
- FR56: Administrators can designate and mark the Puzzle of the Week as sponsored for manufacturer brand placement
- FR57: Users can submit, view, and upvote feature requests on a public board; each request displays vote count and a platform-managed status tag; the platform publishes a public response at a configurable vote threshold; voters are notified when a request ships
- FR58: Users can submit feedback from any page via a persistent in-app affordance; submissions are automatically tagged with originating page and feature context; optional screenshot attachment

**Platform Administration**
- FR44: Administrators can view, investigate, and resolve reported swap disputes
- FR45: Administrators can adjust user reputation scores and apply tiered account restrictions
- FR46: Administrators can place listings under enhanced review (photo-required, hold before visible)
- FR47: Administrators can view a full audit log of all moderation actions
- FR48: Administrators can manage the puzzle catalog including merging duplicate entries and correcting metadata

### NonFunctional Requirements

**Performance**
- NFR1: Core solve log flow (start timer → stop → confirm puzzle → save) completes in ≤ 3 seconds on a mid-range Android device on 3G
- NFR2: Barcode scan resolves to a catalog puzzle match in ≤ 1.5 seconds
- NFR3: Offline solve logs sync within 10 seconds of connectivity restoration; zero data loss on reconnect
- NFR4: First Contentful Paint on mobile (3G): ≤ 2.5 seconds for all authenticated views
- NFR5: Puzzle catalog search returns results in ≤ 1 second for queries against the full catalog
- NFR6: Swap listing creation (photo upload + form submit): completes in ≤ 5 seconds on WiFi
- NFR7: Lighthouse performance score ≥ 85 on mobile for core app views

**Security**
- NFR8: All user data encrypted at rest and in transit (TLS 1.2+ for all API communication)
- NFR9: Passwords hashed using Argon2 (via Supabase Auth); no plaintext passwords stored anywhere
- NFR10: Authentication via secure session tokens with appropriate expiry; refresh token rotation on use
- NFR11: Payment processing delegated entirely to Stripe; no card data stored or transmitted through application servers (PCI-DSS scope handled by processor)
- NFR12: User data access scoped by authentication and Supabase RLS — no cross-account data leakage possible by design
- NFR13: Swap dispute evidence and admin actions stored in tamper-evident audit log
- NFR14: GDPR compliance: explicit consent for analytics tracking; right-to-deletion honoured within 30 days; data export available at any time (FR19)

**Scalability**
- NFR15: System handles 0–1,000 concurrent users without performance degradation at V1 launch
- NFR16: Architecture supports 10× user growth (to ~10,000 MAU) through horizontal scaling of stateless application layer without re-architecture
- NFR17: Puzzle catalog designed to support ≥ 100,000 puzzle entries without query degradation (indexed from day one)
- NFR18: Image storage and CDN architecture chosen to scale independently of application servers
- NFR19: B2B manufacturer data model designed into schema from V1 — no migration required to activate V2 B2B features

**Accessibility**
- NFR20: WCAG 2.1 AA compliance across all authenticated and public-facing views
- NFR21: All UI strings externalized via i18n translation keys at build time; adding a new language requires no code changes
- NFR22: RTL layout support architecturally in place from V1 (not necessarily activated, but not requiring rework to enable)
- NFR23: Touch targets ≥ 44×44px on all interactive elements; primary actions ≥ 52×52px
- NFR24: Colour contrast ratio ≥ 4.5:1 for all body text; ≥ 3:1 for large text and UI components
- NFR25: Core flows (solve log, swap listing creation, marketplace browsing) operable without visual reliance on colour alone
- NFR26: Screen reader compatibility for primary user flows (solve log, dashboard, marketplace)

**Integration**
- NFR27: Barcode catalog lookup: ≥ 80% match rate at launch; fallback to manual search is always available and surfaced immediately on miss
- NFR28: MSP CSV import: processes files up to 10,000 rows without timeout; handles malformed CSVs gracefully with per-row error reporting rather than full-import failure
- NFR29: Stripe subscription integration: payment failures surface actionable messaging to users within the same request cycle; webhook processing handles retry logic for delayed confirmations
- NFR30: Image storage: client-side compression to ≤ 1MB before upload; CDN delivery with lazy loading in all list/feed views
- NFR31: External sharing (FR43): Web Share API with graceful fallback to clipboard copy on unsupported browsers

### Additional Requirements

**Project Scaffolding (Architecture — CRITICAL: drives Epic 1, Story 1)**
- ARCH1: Project initialized using `npx create-next-app -e with-supabase puzzle-times-recorder` (Supabase official Next.js starter) — pre-wires Supabase Auth, shadcn/ui, SSR cookie handling, App Router, TypeScript, Tailwind. This MUST be the first implementation story.
- ARCH2: Post-init package installations required immediately after scaffold: `framer-motion`, `serwist`, `@serwist/next`, `next-intl`, `stripe`, `@stripe/stripe-js`, `fuse.js`, `papaparse`, `@types/papaparse`, `browser-image-compression`, `@zxing/browser`, `@zxing/library`, `idb`

**Data Layer & Security**
- ARCH3: Three Supabase client instances enforced — `lib/supabase/client.ts` (Client Components), `lib/supabase/server.ts` (Server Components + Route Handlers), `lib/supabase/middleware.ts` (middleware.ts only) — never instantiate inline; never create a fourth pattern
- ARCH4: Row Level Security (RLS) enabled on every table from day one — must be in place before any user-facing feature is built
- ARCH5: Supabase Auth + `@supabase/ssr` for cookie-based session handling across Server Components, Client Components, Route Handlers, and Middleware; Next.js Middleware checks session on every request

**Premium & Admin Architecture**
- ARCH6: Premium gating via `subscriptions` table — Middleware reads subscription status and sets it as a request header; all premium checks read the header without additional DB queries per request; must exist before any premium-gated UI is built
- ARCH7: Admin roles via `user_roles` table (`user_id`, `role: 'admin' | 'moderator'`) — admin mutations use Supabase service role key in Route Handlers only; Middleware checks role for all `/admin/*` routes

**Offline & Sync**
- ARCH8: Serwist Service Worker intercepts `POST /api/sync/solves` when offline; `idb` library persists the queue in IndexedDB (survives browser close); each queued solve carries a `crypto.randomUUID()` client ID; sync endpoint uses `ON CONFLICT (client_id) DO NOTHING` — fully idempotent and safe to replay

**Barcode Lookup**
- ARCH9: Three-tier barcode lookup: (1) internal puzzle catalog (exact UPC match), (2) Open Food Facts API, (3) UPC Item DB free tier; successful external lookups cached in internal catalog — repeat scans never hit external APIs

**Frontend State**
- ARCH10: TanStack Query (React Query) for all server state in Client Components; Zustand with exactly two stores only in V1: `timer.store.ts` (active solve timer) and `offline.store.ts` (queued solve count); do not add new Zustand stores without architectural justification
- ARCH11: All TanStack Query keys imported from `lib/query-keys.ts` — never inline string keys; all Zod schemas defined in `lib/schemas/` and shared between client forms and Route Handler validation

**Real-time & Notifications**
- ARCH12: Supabase Realtime subscriptions for in-app swap notifications (request received, accepted, declined); polling on-load refresh for leaderboards in V1; Resend (React Email) for email notifications; Sentry free tier for error tracking

**Infrastructure & CI**
- ARCH13: Vercel auto-deploy on push to `main`; GitHub Actions CI runs Vitest + TypeScript type check + axe-core accessibility scan on every PR; Playwright E2E tests for core flows
- ARCH14: Supabase migration files in `supabase/migrations/`, committed to git, applied via `supabase db push`; run `supabase gen types typescript` after every migration — never manually write DB types
- ARCH15: GDPR deletion cascade implemented as queued Supabase Edge Function with 30-day SLA tracked per deletion request; cascade policy: solve history → hard delete; swap records → anonymize; reputation scores → delete; badge awards → delete; audit log → retain with anonymized user ID

**API Conventions**
- ARCH16: All Route Handlers return consistent JSON error shape `{ error: string, code: string }` — no other shape permitted; Route Handler surface limited to: `/api/sync/solves`, `/api/import/msp`, `/api/barcode/[code]`, `/api/webhooks/stripe`, `/api/export`, `/api/admin/*`
- ARCH17: Environment variables accessed only via `lib/env.ts` (Zod-validated at startup) — never `process.env.X` directly in components or route handlers

### UX Design Requirements

**Design Token Implementation**
- UX-DR1: Implement color token system in `tailwind.config.ts` as single source of truth — warm parchment base (#FAF7F2), terracotta primary (#C4603A), sage secondary (#6B8F71), and all 13 semantic tokens defined in the UX spec
- UX-DR2: Implement self-hosted typography — Plus Jakarta Sans (UI typeface) and Fraunces (display typeface) — loaded from `public/fonts/`; full 9-step type scale defined in Tailwind config with correct sizes, weights, and typeface assignments

**Navigation & Shell**
- UX-DR3: Implement 5-tab tab bar: Home / Catalog / [FAB] / Swap / Profile — centred FAB, tab labels always visible (no icon-only), terracotta active state; at ≥1024px replace with left-anchored sidebar navigation
- UX-DR4: Implement the FAB (Floating Action Button) exclusively for "Start timer / Log a solve" — terracotta, 52×52px, centred above tab bar, visible from any authenticated screen, `aria-label` required

**Custom Component — TimerScreen**
- UX-DR5: Build `TimerScreen` component — full-screen dark overlay suppressing tab bar; Fraunces display-lg elapsed time; 80×80px Stop circular button; cancel confirmation bottom sheet (confirm-to-cancel required, no accidental exit); timer value announced to screen readers via `aria-live="polite"` every 30s; all Framer Motion transitions respect `prefers-reduced-motion`

**Custom Component — SolveConfirmation**
- UX-DR6: Build `SolveConfirmation` component — barcode-matched state (pre-filled, one-tap save) and manual search state; optional photo and note fields (collapsed by default, never gate Save); "Save solve" primary CTA is NEVER disabled regardless of optional field state; offline indicator shown when applicable

**Custom Component — PostCompletionScreen**
- UX-DR7: Build `PostCompletionScreen` component — full-screen destination (not modal/toast/redirect); PB delta, streak status, community rank in category, shareable card thumbnail all visible without scrolling on standard mobile; milestone animations (PB terracotta celebration, badge stamp, streak flame) play 1.5–2s before stats appear; Web Share API integration; `prefers-reduced-motion` fallback; `aria-live="polite"` on container

**Custom Component — ConditionGradeSelector**
- UX-DR8: Build `ConditionGradeSelector` component — 5 grade options (Excellent / Very Good / Good / Fair / Poor) each with color indicator, one-line description, and example condition note; selection pre-populates listing description template; implemented as accessible radio group; teaches the trust system through design at first encounter (no tutorial modal)

**Custom Component — ReputationBadge**
- UX-DR9: Build `ReputationBadge` component — numeric score + star visual + swap count; 4 states: high trust (≥4.0, sage), medium trust (3.0–3.9, neutral), low trust (<3.0, amber warning), new trader ("New trader" label — never "0 swaps"); tap expands to full swap history bottom sheet; announced as "[score] out of 5, [N] completed swaps"

**Custom Component — PuzzlePassportCard**
- UX-DR10: Build `PuzzlePassportCard` component — display name (Fraunces), avatar, solve count, streak, global rank, top 8 badge stamps, Pioneer Migrator status; compact variant (post-completion share preview) and full variant (Profile tab hero); Web Share API generates shareable image with descriptive alt text

**Custom Component — ImportReviewCard**
- UX-DR11: Build `ImportReviewCard` component — card-stack flow auto-advancing on resolution; original MSP title + time + date; top catalog suggestion with confidence %; accept/search/mark-custom/skip actions; high confidence (≥80%), low confidence (<80%), no match states; each card is an accessible labelled radio form group

**Custom Component — SolveJournalEntry**
- UX-DR12: Build `SolveJournalEntry` component — Fraunces day numeral + time display; terracotta PB marker; photo thumbnail if attached; note preview if added; long-press quick actions (share, edit note, delete); full accessible label "[Puzzle name], [time], [piece count], [date]"

**Home Screen & Core Layout**
- UX-DR13: Implement Activity Dashboard home screen — terracotta stats header (streak count, solve count, global rank), prominent "Start a solve" CTA card, recent solves section using Warm Journal entry aesthetic (Fraunces dated entries) below the header
- UX-DR14: Implement the active solve tonal shift — when timer is running, full-screen dark TimerScreen overlay persists across navigation; cannot be accidentally dismissed; tab bar suppressed during active solve

**Import Flow**
- UX-DR15: Implement three-screen import flow — upload step, review queue, completion/Pioneer Migrator celebration; partial dashboard unlocks IMMEDIATELY after matched-solves phase without waiting for queue completion; review queue described as "72 solves need a quick look" (never "errors" or "incomplete")

**Empty States**
- UX-DR16: Implement warm empty states for all views — Journal: illustration + "Your puzzle journey starts here." + "Start timer" CTA; Marketplace cold-start: "Staff picks" editorial grid (never an empty room); Catalog search no results: "Add it to the catalog" CTA; Activity feed no follows: "Explore community" CTA; import queue complete: replaced by Pioneer Migrator completion card (no queue UI)

**Search & Filtering**
- UX-DR17: Implement command-palette puzzle catalog search — full-screen overlay, debounced 200ms instant results, no results → "Add this puzzle" CTA
- UX-DR18: Implement marketplace filter bottom sheet — condition grade chips, piece count slider, location radius; active filter count badge on button; clear all in one tap; filters persist within a session, reset on tab switch

**Responsive Layout**
- UX-DR19: Implement responsive breakpoints using Tailwind defaults — mobile (375px+): single-column, 16px margin, tab bar; tablet (768px+): 2-column marketplace/catalog grids, wider bottom sheets; desktop (1024px+): sidebar nav, 3-column marketplace, content max-width 680px (journal/profile) / 960px (data-heavy views)

**Animation & Motion**
- UX-DR20: All Framer Motion animations: respect `prefers-reduced-motion: reduce` (instant transitions fallback); no animation exceeds 2 seconds; distinct per-badge-type animations referencing physical puzzle experience (no generic confetti); animation tokens (duration, easing, delay) defined as Tailwind custom values shared across all components

**Accessibility Implementation**
- UX-DR21: Implement full keyboard navigation — all interactive elements reachable; `focus-visible:ring-2 focus-visible:ring-primary` on all interactive elements; skip-to-content link at top of each page; TimerScreen: Space to start/stop, Escape to open cancel confirmation
- UX-DR22: Implement focus management for bottom sheets — open: focus moves to first interactive element; close: focus returns to trigger element
- UX-DR23: Implement `aria-live="polite"` regions on: timer display (every 30s), import progress bar, post-completion screen container; all icon-only buttons must have `aria-label`; never use `<div>` or `<span>` for interactive elements
- UX-DR24: Implement barcode scan overlay — camera viewfinder, haptic feedback + visual highlight on successful read (<1.5s); "Search manually" fallback always visible below viewfinder; never a dead end

**Puzzle of the Week**
- UX-DR25: Implement `PuzzleOfTheWeek` component as a visually distinct, beautifully designed weekly featured card (not a list item) — administrator-designatable, optionally sponsorable (FR56); time-limited special leaderboard surfaced on the card

### FR Coverage Map

| FR | Epic | Description |
|---|---|---|
| FR1 | Epic 3 | Start/stop solve timer |
| FR2 | Epic 3 | Barcode scan puzzle association |
| FR3 | Epic 3 | Manual catalog search puzzle association |
| FR4 | Epic 3 | Photo attachment to solve |
| FR5 | Epic 3 | Offline solve recording + sync |
| FR6 | Epic 3 | View complete solve history |
| FR7 | Epic 3 | Add puzzle to collection (no solve) |
| FR8 | Epic 2 | Catalog search (title, brand, piece count, theme) |
| FR9 | Epic 2 | View puzzle detail with community rating |
| FR10 | Epic 2 | Submit rating + micro-review |
| FR11 | Epic 2 | Report missing puzzle |
| FR12 | Epic 2 | Submit new puzzle (manual entry or barcode) |
| FR13 | Epic 2 | Public unauthenticated catalog discovery (SEO) |
| FR14 | Epic 5 | MSP CSV import |
| FR15 | Epic 5 | Fuzzy title matching with confidence scores |
| FR16 | Epic 5 | Unmatched solve review queue (manual assign) |
| FR17 | Epic 5 | Mark unmatched solve as custom puzzle |
| FR18 | Epic 5 | Universal spreadsheet import |
| FR19 | Epic 5 | Full data export |
| FR20 | Epic 4 | View solve streak + streak history |
| FR21 | Epic 4 | View personal best times by puzzle + piece count |
| FR22 | Epic 4 | Earn badges (milestones, import, activity) |
| FR23 | Epic 4 | Retroactive badge awards on imported history |
| FR24 | Epic 4 | Personal analytics dashboard |
| FR25 | Epic 4 | Premium streak shield |
| FR26 | Epic 6 | Create swap listing (condition grade, photos, description) |
| FR27 | Epic 6 | Browse + filter swap listings |
| FR28 | Epic 6 | Send swap request |
| FR29 | Epic 6 | Accept / decline / counter swap request |
| FR30 | Epic 6 | Confirm receipt + rate transaction |
| FR31 | Epic 6 | View reputation score + full swap history |
| FR32 | Epic 6 | Report swap dispute |
| FR33 | Epic 6 | Free-tier listing cap / Premium unlimited listings |
| FR34 | Epic 1 | Registration + onboarding (first solve ≤5 min) |
| FR35 | Epic 1 | Profile management (display name, avatar, location, prefs) |
| FR36 | Epic 7 | Upgrade to Premium Individual |
| FR37 | Epic 7 | Access Premium features (streak shields, unlimited swaps, enhanced analytics) |
| FR38 | Epic 7 | Manage / pause / cancel subscription |
| FR39 | Epic 1 | Notification preferences |
| FR40 | Epic 1 | i18n — preferred language interface |
| FR41 | Epic 8 | Community leaderboards (puzzle + piece count segments) |
| FR42 | Epic 8 | Follow users + activity feed |
| FR43 | Epic 8 | Share solve via Web Share API |
| FR44 | Epic 9 | Admin dispute queue + investigation |
| FR45 | Epic 9 | Admin reputation score adjustment + account restrictions |
| FR46 | Epic 9 | Admin enhanced review (photo-required, listing hold) |
| FR47 | Epic 9 | Admin audit log |
| FR48 | Epic 9 | Catalog moderation (merge duplicates, correct metadata) |
| FR49 | Epic 3 | Personal note / journal entry on solve |
| FR50 | Epic 4 | Personal puzzling goals + visual progress meter |
| FR51 | Epic 4 | Notify record holder + displaced holder on PB surpass |
| FR52 | Epic 4 | Former Champion badge on profile |
| FR53 | Epic 6 | ISO (In Search Of) alerts for specific puzzles |
| FR54 | Epic 8 (consumer: Story 8.4), Epic 9 (admin: Story 9.7) | Puzzle of the Week + time-limited special leaderboard |
| FR55 | Epic 8 | Create + follow curated puzzle lists |
| FR56 | Epic 8 (display: Story 8.4), Epic 9 (admin designation: Story 9.7) | Admin designates + sponsors Puzzle of the Week |

## Epic List

### Epic 1: Project Foundation, Authentication & Platform Shell
Users can sign up, sign in, manage their profile, configure notification and language preferences, and use a correctly branded, accessible, installable PWA with full tab navigation and responsive layout.
**FRs covered:** FR34, FR35, FR39, FR40
**Also covers:** ARCH1–ARCH17 (scaffold, RLS, auth, premium gating table, admin roles table, CI, GDPR deletion Edge Function, env validation, all 8 DB schema migrations), UX-DR1–UX-DR4, UX-DR19–UX-DR23 (design tokens, typography, nav shell, animation tokens, accessibility foundation), NFR8–NFR15, NFR20–NFR26

### Epic 2: Puzzle Catalog & Public Discovery
Users can browse the puzzle catalog, view detailed puzzle pages with community ratings, submit ratings and micro-reviews, report missing puzzles, and add new puzzles. Unauthenticated visitors can discover puzzles via SEO-optimized public pages.
**FRs covered:** FR8, FR9, FR10, FR11, FR12, FR13
**Also covers:** ARCH9 (three-tier barcode lookup Route Handler), UX-DR17 (command-palette search), UX-DR25 (Puzzle of the Week card), NFR5 (catalog search ≤1s), NFR27 (≥80% barcode match rate)

### Epic 3: Solve Logging & Offline
Users can log complete solve times via the 3-tap flow (timer start/stop, barcode scan or manual search, optional photo and note), view their full solve history, add puzzles to their collection, and log solves while offline with automatic sync on reconnect.
**FRs covered:** FR1, FR2, FR3, FR4, FR5, FR6, FR7, FR49
**Also covers:** ARCH8 (Serwist + idb offline queue + idempotent sync), ARCH10–ARCH11 (TanStack Query + Zustand stores), UX-DR5 (TimerScreen), UX-DR6 (SolveConfirmation), UX-DR7 (PostCompletionScreen), UX-DR12 (SolveJournalEntry), UX-DR13–UX-DR14 (Activity Dashboard home, active solve tonal shift), UX-DR24 (barcode scan overlay), NFR1–NFR4 (performance targets for log flow)

### Epic 4: Gamification & Personal Analytics
Users earn badges, track solve streaks with streak shields (Premium), view personal best times by puzzle and piece count, see improvement trends over time, set annual/monthly puzzling goals, and experience distinct milestone celebrations on the post-completion screen. Displaced record holders receive a permanent Former Champion badge.
**FRs covered:** FR20, FR21, FR22, FR23, FR24, FR25, FR50, FR51, FR52
**Also covers:** UX-DR10 (PuzzlePassportCard), UX-DR20 (distinct per-badge-type milestone animations enriching PostCompletionScreen)

### Epic 5: MSP Import & Data Portability
Users can import their solve history from a myspeedpuzzling.com CSV export (or universal spreadsheet), immediately access value from matched solves while progressively resolving unmatched ones via a card-stack review queue, and export all their data at any time.
**FRs covered:** FR14, FR15, FR16, FR17, FR18, FR19
**Also covers:** UX-DR11 (ImportReviewCard), UX-DR15 (three-screen import flow), UX-DR16 (import completion / Pioneer Migrator celebration card), NFR28 (MSP CSV up to 10K rows, per-row error reporting)

### Epic 6: Swap Marketplace
Users can create swap listings with condition grading and photos, browse and filter marketplace listings, send and manage swap requests, confirm receipt and rate transactions, build a visible reputation score, and report disputes. Free-tier users have a listing cap; Premium users have unlimited listings and ISO alerts.
**FRs covered:** FR26, FR27, FR28, FR29, FR30, FR31, FR32, FR33, FR53
**Also covers:** UX-DR8 (ConditionGradeSelector), UX-DR9 (ReputationBadge), UX-DR18 (marketplace filter bottom sheet), UX-DR16 (cold-start Staff picks empty state), NFR6 (listing creation ≤5s), NFR30 (image compression + CDN)

### Epic 7: Premium Subscriptions & Freemium Gating
Users can upgrade to a Premium Individual subscription via Stripe, access premium features (streak shields, unlimited swap listings, enhanced analytics), and manage, pause, or cancel their plan. All freemium gates enforced consistently across API and UI layers.
**FRs covered:** FR36, FR37, FR38
**Also covers:** ARCH6 (premium gating middleware enforcement), NFR11 (Stripe PCI delegation), NFR29 (Stripe webhook + retry handling)

### Epic 8: Community & Social
Users can follow other puzzlers, view a friend activity feed, browse contextually framed leaderboards, share solves via the Web Share API, participate in the weekly Puzzle of the Week with its special leaderboard, create or follow curated puzzle lists, submit and upvote feature requests on a public board, and send contextual in-app feedback.
**FRs covered:** FR41, FR42, FR43, FR54, FR55, FR56, FR57, FR58
**Also covers:** UX-DR25 (Puzzle of the Week featured card), UX-DR16 (activity feed empty state), NFR31 (Web Share API + clipboard fallback)

### Epic 9: Platform Administration & Trust Infrastructure
Administrators can investigate and resolve swap disputes, adjust reputation scores, apply tiered account restrictions, view a tamper-evident audit log of all moderation actions, moderate the puzzle catalog (merge duplicates, correct metadata), designate the weekly Puzzle of the Week with optional sponsorship, and manage the public feature request board (status updates, public responses, vote-threshold alerts).
**FRs covered:** FR44, FR45, FR46, FR47, FR48, FR54 (admin designation side), FR56 (admin sponsorship side), FR57 (admin side)
**Also covers:** ARCH7 (admin role enforcement in middleware and Route Handlers), ARCH15 (GDPR deletion cascade Edge Function + 30-day SLA)

---

## Epic 1: Project Foundation, Authentication & Platform Shell

Users can sign up, sign in, manage their profile, configure notification and language preferences, and use a correctly branded, accessible, installable PWA with full tab navigation and responsive layout.

### Story 1.1: Project Scaffold & Development Environment

As a developer,
I want the project scaffolded with all required tools, packages, and CI configured,
So that the team has a working development environment and automated quality gates from day one.

**Acceptance Criteria:**

**Given** a new machine with Node.js and Docker installed
**When** the developer follows the setup README
**Then** `npm run dev` starts the Next.js app on localhost:3000 with Turbopack hot reload
**And** `supabase start` starts local Postgres, Auth, and Storage via Docker without errors

**Given** the project is scaffolded
**When** the developer inspects the codebase
**Then** all post-init packages are installed: framer-motion, serwist, @serwist/next, next-intl, stripe, @stripe/stripe-js, fuse.js, papaparse, @types/papaparse, browser-image-compression, @zxing/browser, @zxing/library, idb
**And** `lib/env.ts` validates all required environment variables at startup using Zod, failing fast if any are missing
**And** `.env.example` documents every required env var without real values
**And** all env vars throughout the codebase are accessed via `import { env } from '@/lib/env'` — never `process.env.X` directly

**Given** a developer opens a pull request
**When** the GitHub Actions CI pipeline runs
**Then** `npm run type-check` (tsc --noEmit) passes with zero TypeScript errors
**And** `npm run test` (Vitest) passes with no failing tests
**And** `npm run test:a11y` (axe-core) reports zero critical or serious accessibility violations
**And** Vercel creates a preview deployment automatically

**Given** the scaffolded project directory
**When** the developer inspects the file structure
**Then** the directory structure matches the Architecture specification: app/(public)/, app/(app)/, app/(admin)/, app/api/, components/ui/, components/[feature]/, lib/supabase/{client,server,middleware}.ts, lib/schemas/, lib/query-keys.ts, store/, hooks/, e2e/, supabase/migrations/
**And** Serwist is configured in next.config.ts with a Service Worker entry point and PWA manifest at public/manifest.json

---

### Story 1.2: Database Schema & Row Level Security Foundation

As a developer,
I want all database tables created with Row Level Security policies enforced from day one,
So that every subsequent feature is built on a secure, policy-controlled data foundation with no cross-account leakage possible.

**Acceptance Criteria:**

**Given** the Supabase local dev instance is running
**When** `supabase db push` is executed
**Then** all 8 migration files apply without error in sequence: 20260425000001_users.sql through 20260425000008_admin_audit.sql
**And** every table uses snake_case plural naming (users, puzzle_catalog, solve_logs, gamification, swap_listings, subscriptions, community_follows, admin_audit)
**And** all foreign keys follow the `{referenced_table_singular}_id` convention

**Given** all migrations have been applied
**When** the developer inspects RLS policies
**Then** RLS is enabled on every table — zero tables have RLS disabled
**And** the users table allows users to read and write only their own row; no cross-account access is possible via the anon key
**And** puzzle_catalog has an open read policy (unauthenticated and authenticated) with authenticated-only write
**And** solve_logs, swap_listings, subscriptions have own-data read/write policies scoped by user_id
**And** admin_audit is append-only for the service role; readable only with the admin role
**And** user_roles table exists (user_id, role: 'admin' | 'moderator') with service-role-only write

**Given** migrations are applied
**When** `supabase gen types typescript --local` is run
**Then** `lib/supabase/database.types.ts` is generated and committed to the repository
**And** no manually written TypeScript types duplicate what Supabase has generated

**Given** the development seed file
**When** `supabase db seed` is run in the local environment
**Then** a representative set of puzzle catalog entries, test user accounts, and sample solve logs are seeded for development use

---

### Story 1.3: Design System & Brand Tokens

As a user,
I want the app to have a warm, cozy visual identity consistent across every screen,
So that PuzzleTimesRecorder feels like a crafted, intentional product from the very first interaction.

**Acceptance Criteria:**

**Given** the developer inspects tailwind.config.ts
**When** reviewing the design tokens
**Then** all 13 color tokens are defined: --color-base (#FAF7F2), --color-surface (#FFFFFF), --color-surface-raised (#F5F0E8), --color-primary (#C4603A), --color-primary-light (#E8B5A0), --color-primary-subtle (#FAF0EB), --color-secondary (#6B8F71), --color-secondary-subtle (#EEF4EF), --color-text-primary (#1C1917), --color-text-secondary (#78716C), --color-border (#E7E0D8), --color-warning (#D97706), --color-error (#B91C1C)
**And** Plus Jakarta Sans and Fraunces are self-hosted in public/fonts/ and loaded via next/font (no external font requests)
**And** the 9-step type scale is fully defined: display-lg (48px/700/Fraunces) through caption (12px/400/Plus Jakarta Sans)
**And** animation tokens (duration, easing, delay) are defined as Tailwind custom values shared across all components

**Given** any shadcn/ui component is rendered in the browser
**When** a user views it
**Then** it uses the brand color tokens rather than shadcn defaults
**And** all body text (--color-text-primary on --color-base) meets WCAG 2.1 AA contrast ratio (≥4.5:1)
**And** terracotta primary text on parchment base meets AA (≥4.5:1)

**Given** a user whose OS has `prefers-reduced-motion: reduce` set
**When** any Framer Motion animation would normally play
**Then** it is replaced with an instant transition — no motion occurs
**And** all Framer Motion components implement this check via the `useReducedMotion` hook or equivalent pattern

**Given** the Tailwind configuration
**When** a developer inspects the layout CSS
**Then** logical CSS properties are used throughout (padding-inline-start, margin-block-end etc.) ensuring RTL support requires no rework when activated
**And** colour is never the sole means of communicating state — state variants always combine colour with a label or icon

---

### Story 1.4: User Registration, Login & Authentication

As a new visitor,
I want to create an account with my email and password,
So that my data is secure, personal, and accessible from any device.

**Acceptance Criteria:**

**Given** an unauthenticated visitor on /signup
**When** they enter a valid email and password (≥8 characters) and submit
**Then** Supabase Auth creates their account and sends a confirmation email
**And** a corresponding row is inserted in the users table with their user_id
**And** they are redirected to the home screen

**Given** a registered user on /login
**When** they enter correct credentials and submit
**Then** a session cookie is set via @supabase/ssr, valid across Server Components, Client Components, Route Handlers, and Middleware
**And** they are redirected to the return URL (if preserved) or /home

**Given** a user entering incorrect credentials on /login
**When** they submit
**Then** an inline error message appears below the form ("Incorrect email or password")
**And** the message does not reveal whether the email address exists in the system

**Given** an unauthenticated user attempting to access any /(app)/* route
**When** Next.js Middleware processes the request
**Then** they are redirected to /login with the original URL preserved as a `return` query parameter
**And** public routes (/catalog/*, /, /login, /signup) bypass the auth check and load without redirection

**Given** a logged-in user clicking "Sign out"
**When** the action completes
**Then** the session cookie is cleared and they are redirected to /
**And** subsequent attempts to access /(app)/* routes redirect to /login

**Given** any Supabase client usage throughout the codebase
**When** a developer inspects the imports
**Then** clients are only imported from lib/supabase/client.ts, lib/supabase/server.ts, or lib/supabase/middleware.ts — never instantiated inline

---

### Story 1.5: User Profile Management

As a registered user,
I want to set my display name, avatar, location, and puzzling preferences,
So that my profile reflects who I am and other users can recognise me.

**Acceptance Criteria:**

**Given** a logged-in user navigating to /settings
**When** the page loads
**Then** all current profile values are pre-filled in the form fields (display name, avatar, location, preferences)
**And** the form uses React Hook Form with the Zod schema from lib/schemas/profile.schema.ts

**Given** a user updating their profile and submitting valid data
**When** the form is submitted
**Then** the users table row is updated with the new values
**And** a success toast appears ("Profile updated") — auto-dismisses after 3 seconds
**And** no page reload is required

**Given** a user uploading an avatar image
**When** they select a file
**Then** the image is compressed client-side to ≤1MB before upload (browser-image-compression)
**And** the file is stored in Supabase Storage at a predictable, structured path (not user-chosen)
**And** the stored URL is saved to the users table and the avatar updates immediately in the UI via next/image

**Given** a user submitting invalid form data
**When** Zod's safeParse runs
**Then** field-level errors appear inline below each affected field — never in a modal, never as a generic "something went wrong" message
**And** the save button remains accessible and is not disabled due to validation errors in other fields

---

### Story 1.6: Application Shell, Navigation & PWA Foundation

As a mobile user,
I want a persistent tab bar with a prominent "Start a solve" button and the ability to install the app,
So that I can reach any primary feature in one tap and use the platform like a native app.

**Acceptance Criteria:**

**Given** a logged-in user on any authenticated screen on mobile (375px–1023px)
**When** they view the screen
**Then** the tab bar shows: Home / Catalog / [FAB] / Swap / Profile with labels always visible (no icon-only tabs)
**And** the active tab is highlighted in terracotta (--color-primary)
**And** the FAB (52×52px, terracotta) is centred above the tab bar with `aria-label="Start a solve"`

**Given** a user on a screen ≥1024px wide
**When** they view the app
**Then** the tab bar is replaced by a left-anchored persistent sidebar navigation
**And** the FAB remains accessible as a persistent element within the sidebar

**Given** a mobile user who has completed their first solve log (trigger wired; fires as no-op until Epic 3)
**When** the PWA install prompt event fires
**Then** the browser's native "Add to Home Screen" prompt is presented

**Given** a user who installs the PWA
**When** they launch from their home screen
**Then** the app opens in standalone mode (no browser chrome)
**And** the PWA manifest includes: name ("PuzzleTimesRecorder"), short_name, theme_color (#C4603A), background_color (#FAF7F2), display: "standalone", start_url, and icons in all required sizes (192×192 and 512×512 minimum)

**Given** any page in the authenticated shell
**When** the page loads
**Then** a "Skip to main content" link is the first focusable element in the DOM
**And** all interactive elements display a visible focus ring on keyboard focus (focus-visible:ring-2 focus-visible:ring-primary)
**And** tab bar items are keyboard-navigable

**Given** a developer inspects `components/shared/PremiumGate.tsx`
**When** reviewing the component implementation
**Then** it accepts a `children` prop and a `feature` label string
**And** it reads the subscription status from the request header set by Middleware (via a context or server prop — never an independent DB query)
**And** for Premium subscribers it renders `children` transparently
**And** for free-tier users it renders a contained upsell card with the `feature` label and a "Upgrade to Premium" CTA linking to /settings/subscription

---

### Story 1.7: i18n Architecture & Notification Preferences

As a user who puzzles internationally,
I want the app to be available in my preferred language and to control which notifications I receive,
So that the experience is localised and I only hear about things that matter to me.

**Acceptance Criteria:**

**Given** any component in the codebase
**When** a developer inspects the rendered text
**Then** no hardcoded UI strings exist — all copy is referenced via next-intl translation keys
**And** messages/en.json contains all English strings as the sole launch language
**And** adding a new locale requires only adding messages/{locale}.json and updating next-intl config — zero code changes in components

**Given** a user on /settings/notifications
**When** they toggle notification channels (swap activity, badge awards, community interactions) and save
**Then** their preferences are stored in the users table as a JSON notification_preferences field
**And** a success toast confirms the save ("Notification preferences updated")
**And** each preference stores: { channel: string, enabled: boolean } — ready for future notification-sending features to read

**Given** a user selecting a preferred language
**When** the selection is saved and the page is navigated
**Then** the UI renders in the selected language if a translation file exists, falling back gracefully to English
**And** all dates and times across the app render in the locale-appropriate format via Intl.DateTimeFormat — never via date.toLocaleDateString()

**Given** the app rendered with dir="rtl" set on the html element
**When** a developer inspects the layout
**Then** the layout does not catastrophically break (logical CSS properties handle mirroring)
**And** this is verified via a visual inspection test — full RTL activation is not required at launch but needs no rework to enable

---

## Epic 2: Puzzle Catalog & Public Discovery

Users can browse the puzzle catalog, view detailed puzzle pages with community ratings, submit ratings and micro-reviews, report missing puzzles, and add new puzzles. Unauthenticated visitors can discover puzzles via SEO-optimized public pages.

### Story 2.1: Command-Palette Catalog Search

As a puzzler looking for a specific puzzle,
I want to search the catalog instantly using a command-palette overlay,
So that I can find any puzzle by title, brand, piece count, or theme without leaving my current screen.

**Acceptance Criteria:**

**Given** a logged-in user on any authenticated screen
**When** they tap the search icon or "Search catalog" entry point
**Then** a full-screen overlay opens immediately with a focused text input

**Given** the catalog search overlay is open
**When** the user types a query
**Then** results appear within 200ms of the user stopping typing (debounced), showing puzzle image, title, brand, and piece count for each match

**Given** a search query that returns results
**When** the results render
**Then** they appear in ≤1 second for any query against the full catalog (NFR5)
**And** the query key used is imported from `lib/query-keys.ts` (e.g., `queryKeys.catalog.search(query)`) — never an inline string

**Given** a search query that returns no results
**When** the empty state renders
**Then** a warm illustration appears with the headline "We don't have that one yet" and two recovery CTAs: "Submit this puzzle" (primary) and "Search differently" (secondary)
**And** "Submit this puzzle" navigates to the puzzle submission form (Story 2.5) with the search query pre-filled in the title field

**Given** a user who opens the catalog search overlay
**When** they press Escape or tap outside the overlay
**Then** the overlay closes and focus returns to the element that triggered it (UX-DR22 focus management)

**Given** any screen reader user accessing the search overlay
**When** the overlay opens
**Then** focus moves to the search input automatically and results are announced via an `aria-live="polite"` region

---

### Story 2.2: Public Puzzle Discovery & SEO

As an unauthenticated visitor arriving from a search engine,
I want to browse puzzle catalog pages without needing an account,
So that I can discover the platform organically and decide whether to join.

**Acceptance Criteria:**

**Given** an unauthenticated visitor navigating to `/catalog` or `/catalog/[slug]`
**When** their request is handled
**Then** the page loads without redirecting to `/login` — no authentication check is applied to these routes in Middleware

**Given** the public catalog browse page at `/catalog`
**When** it is rendered at build time or on revalidation
**Then** it is served as SSG/ISR from `app/(public)/catalog/page.tsx`
**And** it shows browsable puzzle listings with title, brand, piece count, difficulty, and aggregated community rating visible without login

**Given** a specific puzzle detail page at `/catalog/[slug]`
**When** it is rendered
**Then** it is served as ISR (Next.js ISR, revalidated on catalog update)
**And** the page includes structured data (JSON-LD) with puzzle name, brand, piece count, and aggregated rating for search engine indexing

**Given** an unauthenticated visitor viewing a puzzle detail page
**When** they see the "Log a solve" CTA
**Then** tapping it redirects to `/login?return=/catalog/[slug]` so they are returned to the puzzle page after signing up or signing in

**Given** the `app/(public)/` route group
**When** a developer inspects the Middleware configuration
**Then** all routes under `(public)/` bypass the authenticated session check — they are accessible via the anon key with public RLS policies

---

### Story 2.3: Puzzle Detail Page

As a puzzler viewing a puzzle,
I want to see all the details — title, brand, piece count, difficulty, and what the community thinks of it,
So that I can decide whether it's worth solving or swapping for.

**Acceptance Criteria:**

**Given** a user (authenticated or unauthenticated) on `/catalog/[slug]`
**When** the page loads
**Then** the following are all visible: puzzle title, brand, piece count, difficulty (displayed as a 1–5 scale), aggregated community rating (shown as a numeric average and star visual), and number of community ratings

**Given** a puzzle with no community ratings yet
**When** the rating section renders
**Then** a warm empty prompt appears ("Be the first to rate this puzzle") rather than a blank or zero-star display

**Given** a logged-in user who has previously solved this puzzle
**When** they view the puzzle detail page
**Then** their own recorded solve times for this puzzle are shown ("Your best: 1h 23m") if available
**And** a "Rate this puzzle" / "Edit your rating" CTA is visible

**Given** the puzzle detail page
**When** a developer inspects the data-fetching code
**Then** puzzle data is read directly in a Server Component using `lib/supabase/server.ts` — not via a Route Handler or client-side fetch

**Given** a puzzle with the "Unverified" status (newly submitted via Story 2.5)
**When** the detail page renders
**Then** an "Unverified — pending admin review" badge is visible on the puzzle title
**And** the puzzle is still browsable and linkable before admin approval

---

### Story 2.4: Community Ratings & Micro-Reviews

As a puzzler who has completed a puzzle,
I want to rate it and leave a short review,
So that the community benefits from my experience and the catalog becomes more useful over time.

**Acceptance Criteria:**

**Given** a logged-in user on a puzzle detail page
**When** they tap "Rate this puzzle"
**Then** a rating form opens (inline or bottom sheet) with a 1–5 star selector and an optional micro-review text field (≤250 characters)

**Given** a user submitting a rating
**When** the form is submitted
**Then** `safeParse` is called against the rating Zod schema in `lib/schemas/rating.schema.ts` before any DB write — never `parse()`
**And** on success the aggregated community rating on the puzzle detail page updates to reflect the new submission without a full page reload

**Given** a user who has already submitted a rating for a puzzle
**When** they return to the puzzle detail page
**Then** their existing rating and review are pre-filled in the form with the CTA now reading "Edit your rating"

**Given** a user editing an existing rating
**When** they submit the updated form
**Then** the existing rating row is updated (not a duplicate inserted) and the aggregate recalculates

**Given** the rating form
**When** a user submits with the star selector at zero (no star selected)
**Then** an inline field-level error appears ("Please select a star rating") — the form never submits with a zero rating
**And** the submit button is never disabled for optional field state — only the missing required star rating prevents submission

**Given** the ratings data on a puzzle detail page
**When** the page is rendered for an unauthenticated visitor
**Then** the aggregated rating and all existing reviews are visible — login is only required to submit a new rating

---

### Story 2.5: Submit New Puzzle, Report Missing & Puzzle of the Week Card

As a puzzler who can't find a puzzle in the catalog,
I want to submit it myself or report it as missing,
So that the community catalog grows to cover every puzzle that exists.

**Acceptance Criteria:**

**Given** a user who reached the catalog search empty state (Story 2.1)
**When** they tap "Submit this puzzle"
**Then** the `SubmitPuzzleForm` component opens with the search query pre-filled in the title field

**Given** the `SubmitPuzzleForm`
**When** a user views it
**Then** fields are: title (required), brand (searchable dropdown against existing brands in catalog), piece count (required), difficulty (optional 1–5 scale), photo (optional)

**Given** a user on the submission form who wants to use a barcode instead of typing
**When** they tap "Scan barcode"
**Then** the `BarcodeScanOverlay` opens (the same overlay used in solve logging); on a successful scan, title and brand are pre-filled from the three-tier barcode lookup (`GET /api/barcode/[code]`)

**Given** a user submitting a complete puzzle form
**When** the form is submitted
**Then** `safeParse` runs against `lib/schemas/puzzle-submit.schema.ts` before any write
**And** on success a row is inserted in `puzzle_catalog` with `verified: false` and `status: 'pending_review'`
**And** a success toast appears ("Puzzle submitted — thanks for helping!")
**And** the puzzle is immediately searchable with an "Unverified" badge (Story 2.3 renders it)

**Given** a user who wants to report a missing puzzle without submitting full details
**When** they tap "Report missing puzzle" (available on the catalog search empty state and on the submission form)
**Then** a lightweight report form opens: puzzle title (pre-filled if available), brief description of the issue
**And** on submission a record is created for admin review (visible in Story 9.5's catalog moderation queue)
**And** a success toast appears ("Thank you — we'll review this")

**Given** an admin who has designated a Puzzle of the Week (administered in Story 9.x)
**When** the `PuzzleOfTheWeek` component is included on `/community` (wired in Story 8.4)
**Then** this story delivers the component itself: `components/community/PuzzleOfTheWeek.tsx` — a visually distinct editorial card (not a list item) using Fraunces for the heading, showing puzzle name, brand, piece count, "Solve this week" CTA, and a link to the time-limited special leaderboard

**Given** the Puzzle of the Week is designated as sponsored (FR56)
**When** the card renders
**Then** a tasteful "Sponsored by [Brand]" label appears without dominating the card design

**Given** a user who has already logged a solve for the active Puzzle of the Week
**When** they view the `PuzzleOfTheWeek` card
**Then** the CTA reads "You solved this — see your time" with their recorded time visible on the card

---

## Epic 3: Solve Logging & Offline

Users can log complete solve times via the 3-tap flow (timer start/stop, barcode scan or manual search, optional photo and note), view their full solve history, add puzzles to their collection, and log solves while offline with automatic sync on reconnect.

### Story 3.1: Activity Dashboard Home & Timer Initiation

As a puzzler,
I want a home screen showing my stats and a prominent "Start a solve" button,
So that I can begin logging in one tap and immediately see what I've been doing.

**Acceptance Criteria:**

**Given** a logged-in user on /home
**When** the page loads
**Then** a terracotta stats header shows current streak count, total solve count, and global rank (placeholders until Epic 4 populates gamification data)

**Given** the home screen
**When** a user views recent activity
**Then** solved puzzles appear as SolveJournalEntry rows (Fraunces day numeral, puzzle name, recorded time, piece count) below the stats header

**Given** no solves logged yet
**When** the journal section renders
**Then** a warm empty state appears: illustration + "Your puzzle journey starts here." + "Start timer" CTA — never a blank screen

**Given** a user tapping the FAB
**When** the timer screen loads
**Then** the TimerScreen full-screen dark overlay opens immediately with no intermediate screen

**Given** the home screen
**When** TanStack Query fetches recent solves
**Then** the query key is imported from lib/query-keys.ts (never an inline string)

---

### Story 3.2: TimerScreen — Full-Screen Solve Timer

As a puzzler,
I want a focused, distraction-free timer screen while I'm solving,
So that I can concentrate on the puzzle without the app getting in the way.

**Acceptance Criteria:**

**Given** the user has tapped the FAB
**When** the TimerScreen renders
**Then** the full screen is dark (no tab bar, no header), showing the elapsed time in Fraunces display-lg and a single circular Stop button (80×80px)

**Given** the timer is running
**When** the user attempts to navigate away (back gesture or tab tap)
**Then** a cancel confirmation bottom sheet appears asking "Stop this solve?" with destructive confirm and ghost cancel — the timer cannot be accidentally dismissed

**Given** the timer is running
**When** 30 seconds have elapsed
**Then** the elapsed time value is announced via aria-live="polite" to screen readers

**Given** the user taps Stop
**When** the action fires
**Then** haptic feedback + a brief visual pulse plays, then the SolveConfirmation screen opens immediately

**Given** prefers-reduced-motion: reduce is set
**When** the stop animation plays
**Then** it is replaced with an instant transition

**Given** the timerStore (Zustand)
**When** the user navigates between tabs while a solve is active
**Then** the timer state persists across navigation — the solve is not lost

---

### Story 3.3: SolveConfirmation — Puzzle Identification via Barcode Scan

As a puzzler who has stopped the timer,
I want to scan the puzzle box barcode to instantly identify it,
So that I don't have to type the puzzle name after completing a solve.

**Acceptance Criteria:**

**Given** the SolveConfirmation screen has opened
**When** it renders
**Then** the camera viewfinder (BarcodeScanOverlay) opens automatically for barcode scanning

**Given** a barcode is successfully scanned
**When** the result resolves in ≤1.5 seconds
**Then** haptic feedback fires + the puzzle name and image pre-fill the confirmation screen

**Given** a barcode scan that finds no match (after three-tier lookup)
**When** the result returns `{ found: false }`
**Then** "Search manually" becomes the primary CTA immediately — never a dead end, never an error state that blocks the user

**Given** a user tapping "Search manually"
**When** the catalog search overlay opens
**Then** they can search by title and select a puzzle to pre-fill the confirmation

**Given** an identified puzzle on the SolveConfirmation screen
**When** the user views it
**Then** the puzzle name, image, piece count, and recorded time are all visible before saving

**Given** the confirmation screen
**When** the user has identified the puzzle
**Then** "Save solve" is the primary CTA and is never disabled regardless of whether optional fields are filled

---

### Story 3.4: PostCompletionScreen & Solve Save

As a puzzler who has confirmed their solve,
I want a rich completion screen immediately after saving,
So that the accomplishment feels real and I can share it.

**Acceptance Criteria:**

**Given** a user tapping "Save solve" on the SolveConfirmation screen
**When** they are online
**Then** the solve is POSTed to POST /api/sync/solves and on success the PostCompletionScreen renders immediately (no navigation, no redirect)

**Given** the PostCompletionScreen
**When** it renders
**Then** the puzzle name, recorded time (Fraunces display-lg), and a standard set of stats (streak status, community rank in piece count category) are all visible without scrolling on a standard mobile screen

**Given** this is the user's first ever solve
**When** PostCompletionScreen renders
**Then** encouraging copy appears instead of PB delta context ("Your first solve! Every great collection starts here.")

**Given** the PostCompletionScreen
**When** a user taps "Share"
**Then** the Web Share API is invoked with the solve result; on browsers that don't support Web Share API, a clipboard copy fallback is used instead

**Given** PostCompletionScreen renders
**When** the user taps "Return home"
**Then** they are navigated back to /home and the new SolveJournalEntry appears at the top of the journal

**Given** prefers-reduced-motion is not set
**When** PostCompletionScreen renders
**Then** a brief entrance animation plays before the stats appear (≤1.5 seconds total); with prefers-reduced-motion set, stats appear instantly

---

### Story 3.5: Optional Photo & Personal Note on Solve

As a puzzler,
I want to optionally attach a photo and a personal note to my solve,
So that I can remember the context and mood around completing a puzzle.

**Acceptance Criteria:**

**Given** the SolveConfirmation screen
**When** a user views it
**Then** photo attachment and personal note fields are present but collapsed by default

**Given** a user tapping "Add photo"
**When** the camera opens and a photo is taken or selected
**Then** the image is compressed client-side to ≤1MB (browser-image-compression) before upload

**Given** a photo is attached
**When** the solve is saved
**Then** the image is stored at solve-photos/{user_id}/{solve_id}/{filename} in Supabase Storage and the URL is saved to the solve_logs row

**Given** a user tapping "Add note"
**When** the text field expands
**Then** they can type a personal note (context, mood, companions) — no character limit enforced, but soft guidance shown

**Given** a user who adds a note but no photo (or vice versa)
**When** the solve is saved
**Then** only the present fields are stored — nulls are handled explicitly, never coerced to empty strings

**Given** a solve with a photo
**When** it appears in the SolveJournalEntry on /home
**Then** a photo thumbnail is visible alongside the entry

---

### Story 3.6: Offline Solve Queue & Automatic Sync

As a puzzler in an area with no connectivity,
I want to log solves offline and have them sync automatically when I reconnect,
So that I never lose a solve due to poor signal.

**Acceptance Criteria:**

**Given** a user saves a solve while offline
**When** the POST /api/sync/solves request fails due to no connectivity
**Then** the Serwist Service Worker intercepts the request and adds the solve payload to the IndexedDB queue (via idb)

**Given** a solve is queued offline
**When** the user views the app
**Then** the OfflineIndicator component shows the count of queued solves ("1 solve waiting to sync")

**Given** the device regains connectivity
**When** the Service Worker detects it
**Then** the queued solves are automatically replayed against POST /api/sync/solves in order

**Given** the sync endpoint receives a queued solve
**When** it processes the payload
**Then** it uses ON CONFLICT (client_id) DO NOTHING — replaying the queue multiple times never creates duplicate solves

**Given** a solve was logged offline
**When** sync completes successfully
**Then** the OfflineIndicator clears and the solve appears in the journal on next render

**Given** a queued solve
**When** the user closes and reopens the browser before syncing
**Then** the solve is still in the queue (IndexedDB survives browser close)

---

### Story 3.7: Solve History & Collection Manager

As a puzzler,
I want to view my complete solve history and manage my puzzle collection,
So that I have a full record of my puzzling activity.

**Acceptance Criteria:**

**Given** a logged-in user on /home scrolling past recent solves
**When** they navigate to their full history
**Then** a paginated list of all solves is shown with timestamps, recorded times, puzzle names, piece counts, and photo thumbnails where present

**Given** a user on their solve history
**When** they tap a SolveJournalEntry
**Then** a solve detail view opens showing all solve fields including any personal note and full-resolution photo

**Given** a user long-pressing a SolveJournalEntry
**When** the quick action menu appears
**Then** options include: Share, Edit note, Delete

**Given** a user deleting a solve
**When** they confirm the destructive action in a bottom sheet
**Then** the solve is removed from solve_logs and the UI updates without a full reload

**Given** a user on /collection
**When** the page loads
**Then** puzzles they have added to their collection (FR7 — without necessarily logging a solve) are shown in a grid

**Given** a user on any puzzle detail page
**When** they tap "Add to collection"
**Then** a row is inserted in their collection table and a success toast appears ("Added to your collection")

---

## Epic 4: Gamification & Personal Analytics

Users earn badges, track solve streaks with streak shields (Premium), view personal best times by puzzle and piece count, see improvement trends over time, set annual/monthly puzzling goals, and experience distinct milestone celebrations on the post-completion screen. Displaced record holders receive a permanent Former Champion badge.

### Story 4.1: Streak Tracking & Streak History

As a puzzler,
I want to see my current solve streak and streak history,
So that I have a daily motivation to keep puzzling.

**Acceptance Criteria:**

**Given** a user who solves a puzzle
**When** the solve is saved
**Then** the streaks module in lib/gamification/streaks.ts recalculates their current streak (consecutive days with at least one solve)

**Given** a logged-in user on /home
**When** the stats header renders
**Then** their current streak count and a streak flame icon are visible in the terracotta stats header

**Given** a user on /dashboard
**When** the streak section renders
**Then** their current streak, longest streak ever, and a calendar-style streak history are all visible

**Given** a user who misses a day
**When** they next open the app
**Then** their streak is shown as 0 (or reduced to the new count) — no "you've been inactive" shaming language is used

**Given** the streak data
**When** TanStack Query fetches it
**Then** the query key used is queryKeys.solves.byUser(userId) or equivalent from lib/query-keys.ts

---

### Story 4.2: Personal Best Times & Former Champion Badge

As a competitive puzzler,
I want to track my personal best times by puzzle and piece count, and to know when I've been dethroned from a record,
So that I have meaningful performance goals.

**Acceptance Criteria:**

**Given** a user saves a new solve
**When** lib/gamification/personal-bests.ts evaluates it
**Then** the system checks whether the time is a new personal best for that puzzle and/or piece count category

**Given** a new personal best is set
**When** PostCompletionScreen renders for that solve
**Then** the PB delta (e.g., "New PB — 2m 14s faster than your previous best") appears with the terracotta celebration animation before the stats display

**Given** a user on /dashboard
**When** the PersonalBestGrid renders
**Then** personal best times are shown by piece count category (500, 1000, 1500, 2000+ pieces)

**Given** User A holds a personal best that User B surpasses (on the same puzzle leaderboard — FR51)
**When** User B saves their solve
**Then** `lib/gamification/personal-bests.ts` detects the record change and inserts a notification event row for both affected users
**And** both User A and User B receive an in-app notification delivered via Supabase Realtime to their active sessions; users not currently active receive it on next app load

**Given** User A is displaced from a record
**When** they next view their profile
**Then** a permanent "Former Champion" badge (FR52) appears on their profile for that puzzle — it never disappears even if they later set a new record

---

### Story 4.3: Badge System & Retroactive Awards

As a puzzler,
I want to earn badges for milestones and have them awarded retroactively to my solve history,
So that my history is fully recognised regardless of when I joined.

**Acceptance Criteria:**

**Given** the badge definitions in lib/gamification/badges.ts
**When** a solve is saved
**Then** all badge criteria are evaluated against the user's complete solve history (including previously imported solves)

**Given** a badge criterion is met
**When** the badge is awarded
**Then** a row is inserted in the gamification table and the PostCompletionScreen shows the badge unlock animation (distinct per badge type — not generic confetti)

**Given** a user has newly imported MSP history
**When** the import completes
**Then** all badge criteria are re-evaluated against the full history and any earned badges are awarded retroactively (FR23)

**Given** a badge unlock animation
**When** it plays on PostCompletionScreen
**Then** it plays before stats appear (≤2 seconds) and respects prefers-reduced-motion

**Given** a user on their profile
**When** they view the badge section
**Then** all earned badges are displayed as a stamp-grid; tapping a badge shows its name, description, and the date it was earned

---

### Story 4.4: Personal Analytics Dashboard & Puzzle Passport

As a puzzler,
I want a rich personal analytics dashboard and a shareable profile card,
So that I can track my improvement over time and show off my puzzle identity.

**Acceptance Criteria:**

**Given** a logged-in user on /dashboard
**When** the page loads
**Then** the following are all visible: current streak, total solves, average time by piece count, solve trend chart (improvement over time), global rank in piece count category

**Given** the SolveTrendChart
**When** it renders
**Then** it shows solve times plotted over time for the user's most-logged piece count category, with a visible improvement trend line

**Given** a user on /profile
**When** the PuzzlePassportCard renders in full variant
**Then** it shows: display name (Fraunces), avatar, solve count, streak, global rank, top 8 earned badge stamps, and Pioneer Migrator status (if applicable)

**Given** a user tapping "Share" on their Puzzle Passport
**When** the Web Share API is invoked
**Then** a shareable image of the card is generated with a descriptive alt text describing their stats

**Given** the compact PuzzlePassportCard variant
**When** it appears in the post-completion share preview
**Then** it shows a condensed version with solve count, streak, and the just-earned achievement

---

### Story 4.5: Personal Puzzling Goals & Progress Meter

As a puzzler,
I want to set annual or monthly puzzling goals and track progress visually,
So that I have a long-term sense of progress beyond daily streaks.

**Acceptance Criteria:**

**Given** a logged-in user on /dashboard
**When** they tap "Set a goal"
**Then** a form allows them to choose a goal type (annual puzzle count, monthly puzzle count, total piece count, or time-based target) and a target value

**Given** a goal is saved
**When** the dashboard renders
**Then** a GoalProgressMeter (shadcn/ui Progress component themed to brand tokens) displays current progress vs. target

**Given** a user completes a solve
**When** the goal is evaluated
**Then** progress updates immediately on next dashboard load

**Given** a user who reaches 100% of their goal
**When** the dashboard renders
**Then** a celebration state appears on the GoalProgressMeter (not a full PostCompletionScreen — a contextual milestone card)

**Given** a user who has not set a goal
**When** the dashboard goal section renders
**Then** an encouraging prompt appears ("Set your 2026 puzzling goal") — never an empty section

---

### Story 4.6: Premium Streak Shield

As a Premium user,
I want to apply a streak shield that protects my streak during a break,
So that a vacation doesn't erase months of daily puzzling.

**Acceptance Criteria:**

**Given** a Premium user (subscription tier = premium)
**When** they view their streak section on /dashboard
**Then** a "Use streak shield" option is available

**Given** a Premium user activating a streak shield
**When** they confirm
**Then** the shield is marked as active in the gamification table with an expiry date

**Given** an active streak shield expires without a solve logged
**When** streak recalculation runs
**Then** the streak is preserved for the shield duration and the shield is consumed

**Given** a free-tier user viewing the streak section
**When** streak shield UI is shown
**Then** it is visible but gated behind a PremiumGate wrapper that shows an upsell prompt — never hidden entirely

**Given** a Premium user who has no streak shields remaining
**When** they view the streak section
**Then** they see that no shields are available (not a confusing empty state)

---

## Epic 5: MSP Import & Data Portability

Users can import their solve history from a myspeedpuzzling.com CSV export (or universal spreadsheet), immediately access value from matched solves while progressively resolving unmatched ones via a card-stack review queue, and export all their data at any time.

### Story 5.1: MSP CSV Import — Upload & Fuzzy Matching

As an MSP migrator,
I want to upload my MSP CSV export and immediately see my matched solve history,
So that years of data transfer in minutes rather than being lost.

**Acceptance Criteria:**

**Given** a logged-in user on /import
**When** the page loads
**Then** an ImportUploader component allows CSV file drop or browse selection

**Given** a user uploads a valid MSP CSV file
**When** POST /api/import/msp processes it
**Then** papaparse streams the file row-by-row (not loading the whole file into memory)

**Given** the import is processing
**When** the UI renders
**Then** an ImportProgress component shows a progress bar with matched and unmatched counts updating in near-real-time

**Given** the import completes
**When** there are matched solves
**Then** matched solves are inserted into solve_logs with an import_batch_id tag and the user's dashboard is immediately populated with matched data — they are NOT blocked waiting for unmatched review

**Given** the import Route Handler
**When** it processes each row
**Then** it uses lib/fuzzy-match/ (fuse.js) to score matches against puzzle_catalog titles; matched rows (above confidence threshold) are inserted automatically; unmatched rows are inserted into an import_unmatched_queue table

**Given** a malformed CSV row
**When** the parser encounters it
**Then** that row is reported individually (per-row error reporting) and the rest of the import continues — one bad row does not fail the entire import (NFR28)

**Given** an MSP CSV file up to 10,000 rows
**When** the import runs
**Then** it completes without a timeout (NFR28)

---

### Story 5.2: Unmatched Solve Review Queue

As a migrator with unmatched solves,
I want to review and resolve them one by one at my own pace,
So that my full history is eventually captured without being blocked from using the platform.

**Acceptance Criteria:**

**Given** a completed import with unmatched solves
**When** the user is redirected to /import/review
**Then** the count of unmatched solves is displayed as: "72 solves need a quick look" — never "72 errors" or "import incomplete"

**Given** the review queue
**When** it renders
**Then** ImportReviewCard components appear in a card-stack pattern: one card visible at a time, showing the original MSP title, date, time, and the top fuzzy match suggestion with confidence percentage

**Given** a high-confidence suggestion (≥80%)
**When** the card renders
**Then** "Accept suggestion" is the clearly primary action with the matched puzzle name and image prominent

**Given** a low-confidence suggestion (<80%)
**When** the card renders
**Then** a caution indicator is shown and "Search manually" is equally prominent alongside "Accept"

**Given** the user accepts a suggestion
**When** the action fires
**Then** the import_unmatched_queue row is resolved, the solve is inserted into solve_logs, the card advances automatically to the next — no return to a menu between resolutions

**Given** the user taps "Search manually"
**When** the catalog search overlay opens
**Then** they can find and select the correct puzzle; on selection the card resolves and advances

**Given** the user taps "Mark as custom puzzle"
**When** the action fires
**Then** the solve is inserted into solve_logs with a custom_puzzle flag and the card advances

**Given** the user taps "Skip for now"
**When** the action fires
**Then** the card moves to the back of the queue; the user can return to it later

---

### Story 5.3: Import Completion & Pioneer Migrator Badge

As a migrator who has resolved all unmatched solves,
I want a celebration moment and a shareable import completion card,
So that finishing the import feels like an achievement.

**Acceptance Criteria:**

**Given** the last unmatched solve is resolved
**When** the queue empties
**Then** the user is automatically navigated to /import/complete

**Given** the /import/complete screen
**When** it renders
**Then** the Pioneer Migrator badge animation plays and the badge is awarded (if not already earned)

**Given** the completion screen
**When** badge evaluation runs
**Then** all retroactive badges based on imported solve history are awarded at this moment (FR23)

**Given** the completion screen
**When** a shareable import card renders
**Then** it shows: solve count, year range of history ("6 years"), total puzzles, and the Pioneer Migrator badge — designed as a first-class shareable artifact

**Given** a user tapping Share on the completion card
**When** the Web Share API is invoked
**Then** the card is shared to external platforms; clipboard fallback on unsupported browsers

**Given** a user tapping "View my dashboard"
**When** navigation completes
**Then** they land on /dashboard with full solve history visible

---

### Story 5.4: Universal Spreadsheet Import

As a non-MSP user who tracks puzzles in a spreadsheet,
I want to import my history using a standard template,
So that I'm not excluded from the import feature just because I wasn't on MSP.

**Acceptance Criteria:**

**Given** a user on /import
**When** they view the page
**Then** two import options are presented: "Import from myspeedpuzzling.com" and "Import from spreadsheet template"

**Given** a user selecting the spreadsheet option
**When** the form renders
**Then** a downloadable universal template (CSV/XLSX) is provided with the required columns (puzzle title, solve date, solve time, piece count, optional brand)

**Given** a user uploading a filled universal template
**When** POST /api/import/msp processes it
**Then** the format-detection logic in `lib/import/detect-format.ts` inspects the CSV header row: if it contains the MSP-specific columns (`puzzle_id`, `ranking`) it is treated as MSP format; otherwise it is treated as the universal template format
**And** the universal template column mapping is: `puzzle_title` → title, `solve_date` → date, `solve_time` → time, `piece_count` → piece_count, `brand` → brand (optional)

**Given** the universal import
**When** it processes
**Then** the same fuzzy matching, review queue, and completion flow as the MSP import applies (no separate code path needed — format auto-detection routes to the same pipeline)

**Given** a universal template file with a malformed or missing required column
**When** the format-detection or column mapping fails
**Then** a row-level error is reported for each affected row (consistent with NFR28) and the rest of the import continues; the error message identifies the missing column by name (e.g., "Row 12: missing required column 'solve_time'")

---

### Story 5.5: Full Data Export

As a puzzler who values data ownership,
I want to export all my solve history and profile data at any time,
So that I'm never locked into the platform.

**Acceptance Criteria:**

**Given** a logged-in user on /settings
**When** they tap "Export my data"
**Then** a request is made to GET /api/export

**Given** the export endpoint
**When** it processes
**Then** it streams a ZIP file containing: solve_logs as CSV, profile data as JSON, badge history as JSON, and swap transaction history as JSON

**Given** the export is complete
**When** the file downloads
**Then** it includes all data — including imported history and any custom puzzle solves

**Given** the GDPR right-to-deletion requirement
**When** a user has requested data deletion (future admin flow)
**Then** their export reflects the pre-deletion state if requested before deletion completes

**Given** the export endpoint
**When** a developer inspects it
**Then** it uses the Supabase server client (lib/supabase/server.ts) scoped to the authenticated user's data — no service role key needed, RLS handles the data boundary

---

## Epic 6: Swap Marketplace

Users can create swap listings with condition grading and photos, browse and filter marketplace listings, send and manage swap requests, confirm receipt and rate transactions, build a visible reputation score, and report disputes. Free-tier users have a listing cap; Premium users have unlimited listings and ISO alerts.

### Story 6.1: Create Swap Listing with Condition Grading

As a puzzler with puzzles to swap,
I want to create a listing with condition grading and photos in under 2 minutes,
So that I can quickly put my puzzle into the community marketplace.

**Acceptance Criteria:**

**Given** a logged-in user on /marketplace/new
**When** the listing creation form loads
**Then** fields are present for: puzzle (search/scan), condition grade, photos (required, minimum 1), and optional description

**Given** the ConditionGradeSelector component
**When** a user views it
**Then** 5 grade options are displayed (Excellent / Very Good / Good / Fair / Poor), each with a colour indicator, one-line description, and an example condition note — the trust system is taught through the component design, no tutorial modal required

**Given** a user selecting a condition grade
**When** the grade is chosen
**Then** a description template is pre-populated in the optional description field, which the user can edit or clear

**Given** a user uploading listing photos
**When** each photo is selected
**Then** it is compressed client-side to ≤1MB (browser-image-compression) before upload

**Given** photos are uploaded
**When** stored
**Then** they are saved at swap-photos/{listing_id}/{filename} — never at a user-chosen path

**Given** a user submitting a complete listing
**When** the form submits
**Then** the listing is created in swap_listings with status "active" and the user sees a confirmation ("Listing published")

**Given** the entire listing creation flow (photo upload + form submit)
**When** completed on WiFi
**Then** it completes in ≤5 seconds (NFR6)

**Given** a free-tier user who has reached their active listing cap (FR33 — 3 active listings)
**When** they attempt to create a new listing
**Then** a PremiumGate wrapper shows an upsell prompt rather than the listing form
**And** the cap of 3 is enforced at both the UI layer (PremiumGate) and at the Route Handler (`POST /api/marketplace/listings`) — a free-tier user with 3 active listings receives a 403 with `{ error: "Free listing limit reached", code: "listing-limit-exceeded" }` if they attempt to bypass the UI

---

### Story 6.2: Marketplace Browse & Filter

As a swap seeker,
I want to browse and filter marketplace listings,
So that I can find puzzles I want to swap for quickly.

**Acceptance Criteria:**

**Given** a logged-in user on /marketplace
**When** the page loads
**Then** active swap listings are displayed in a responsive grid (single column mobile, 2-column ≥768px, 3-column ≥1024px)

**Given** fewer than 20 active listings exist (cold-start state)
**When** the marketplace renders
**Then** a "Staff picks" editorial grid is shown above or instead of the sparse listings grid — never an empty room

**Given** a user tapping "Filters"
**When** the filter bottom sheet opens
**Then** filter options appear: condition grade (chips), piece count (slider range), location radius — and the button shows active filter count ("Filters · 2")

**Given** a user applying filters
**When** results update
**Then** listings update without a full page reload

**Given** a user tapping "Clear all" in the filter sheet
**When** the action fires
**Then** all filters reset and the full listing grid returns

**Given** filters applied in a session
**When** the user navigates within the marketplace (e.g., views a listing detail and returns)
**Then** the active filters persist
**And** filters reset when the user navigates away from the /marketplace route entirely (e.g., switches to Home, Catalog, or Profile tab) and then returns

---

### Story 6.3: Listing Detail & Swap Request Flow

As a swap seeker,
I want to view a listing's full detail and send a swap request,
So that I can connect with the seller and arrange an exchange.

**Acceptance Criteria:**

**Given** a user tapping a listing card
**When** the ListingDetail page loads
**Then** puzzle details, condition grade, all photos, seller reputation score, and swap history are all visible

**Given** the ReputationBadge component on the listing
**When** a user views it
**Then** numeric score, star visual, and swap count are shown; high trust (≥4.0) renders in sage, medium (3.0–3.9) in neutral, low (<3.0) in amber warning, new trader shows "New trader" label (never "0 swaps")

**Given** a user tapping the ReputationBadge
**When** the expansion triggers
**Then** the seller's full swap history bottom sheet slides up showing all past transactions and ratings

**Given** a user tapping "Request swap"
**When** the request is sent
**Then** a swap_requests row is created and the seller receives a Supabase Realtime in-app notification

**Given** a seller receiving a swap request
**When** they view their SwapInbox
**Then** they can Accept, Decline, or Counter the request

**Given** a seller accepting a request
**When** the acceptance is saved
**Then** both parties receive an in-app notification with next-step instructions for arranging the exchange

---

### Story 6.4: Swap Confirmation, Receipt & Rating

As a swap participant,
I want to confirm receipt of my puzzle and rate the transaction,
So that the reputation system reflects real swap outcomes and I build trust over time.

**Acceptance Criteria:**

**Given** a swap that has been accepted
**When** either party views their SwapInbox
**Then** a "Confirm receipt" action is available once they expect the puzzle to have arrived

**Given** a user confirming receipt
**When** the action fires
**Then** the swap_requests row status updates to "received" for that party

**Given** both parties have confirmed receipt
**When** the system detects the mutual confirmation
**Then** both are prompted to rate the transaction (1–5 stars) and their counterparty

**Given** ratings submitted by both parties
**When** they are saved
**Then** reputation scores for both parties recalculate using lib/reputation/score.ts and the updated scores are immediately visible on their profiles and any active listings

**Given** a user completing their first swap
**When** reputation displays
**Then** their score is visible and their status transitions from "New trader" to showing their actual score

---

### Story 6.5: Dispute Reporting & Listing Management

As a swap participant encountering a problem,
I want to report a dispute and manage my active listings,
So that bad-faith swaps can be escalated and I can keep my listings current.

**Acceptance Criteria:**

**Given** a user on a completed swap detail
**When** they tap "Report a dispute" (FR32)
**Then** the DisputeReportForm opens with fields for dispute type, description, and evidence (photo upload optional)

**Given** a dispute report submitted
**When** the form is saved
**Then** a dispute record is created in the admin queue (visible in Epic 9) and the swap status updates to "disputed"

**Given** a user on /marketplace/my-listings
**When** the page loads
**Then** all their active and completed listings are shown with their current status

**Given** a user tapping a listing action
**When** editing or deactivating a listing
**Then** the listing status updates in swap_listings and changes reflect immediately in the marketplace browse view

**Given** a Premium user on /settings
**When** they navigate to ISO alerts (FR53)
**Then** they can specify a puzzle title and piece count to watch for; when a matching listing is created, they receive an in-app notification

---

## Epic 7: Premium Subscriptions & Freemium Gating

Users can upgrade to a Premium Individual subscription via Stripe, access premium features (streak shields, unlimited swap listings, enhanced analytics), and manage, pause, or cancel their plan. All freemium gates enforced consistently across API and UI layers.

### Story 7.1: Stripe Integration & Premium Upgrade Flow

As a free-tier user,
I want to upgrade to Premium Individual by paying with my card,
So that I can access streak shields, unlimited swap listings, and enhanced analytics.

**Acceptance Criteria:**

**Given** a logged-in free-tier user encountering any PremiumGate component
**When** the upsell prompt appears
**Then** tapping "Upgrade" navigates them to /settings/subscription

**Given** a user on /settings/subscription
**When** the page loads
**Then** the current plan (Free) and the Premium Individual plan with pricing and feature list are displayed clearly — no dark patterns, no urgency language

**Given** a user clicking "Upgrade to Premium"
**When** the Stripe Checkout flow initiates
**Then** they are redirected to Stripe-hosted Checkout — no card data ever touches the application server (NFR11)

**Given** a successful Stripe payment
**When** the Stripe webhook fires to POST /api/webhooks/stripe
**Then** the webhook signature is verified before processing; on success, the subscriptions table updates with stripe_customer_id, subscription_status: "active", and tier: "premium"

**Given** a failed payment on Stripe's side
**When** the failure event fires
**Then** the user sees a clear, actionable error message within the same session ("Payment failed — please check your card details")

**Given** the Stripe webhook handler
**When** a developer inspects it
**Then** all Stripe secret key access is via import { env } from '@/lib/env' — never process.env directly

---

### Story 7.2: Premium Feature Access & Freemium Gate Enforcement

As a Premium subscriber,
I want all premium features to be immediately and consistently available after subscribing,
So that I'm not navigating a patchwork of locked and unlocked states.

**Acceptance Criteria:**

**Given** a user with an active Premium subscription
**When** Next.js Middleware processes their request
**Then** the subscription status is read from the subscriptions table and set as a request header — Server Components and Route Handlers read the header without additional DB queries per request

**Given** a Premium user accessing streak shields (/dashboard)
**When** the feature loads
**Then** streak shield controls are fully available without a PremiumGate wrapper

**Given** a Premium user on the marketplace
**When** they view the create listing page
**Then** no listing cap is enforced — FR33 unlimited listings applies

**Given** a free-tier user accessing any premium-gated feature
**When** the feature would normally be shown
**Then** a PremiumGate component wraps it with an upsell prompt — the feature is never shown half-rendered or broken, just gated

**Given** the premium gate logic
**When** a developer inspects it
**Then** the gate reads the subscription header set by Middleware — it never performs an independent DB query per component

---

### Story 7.3: Subscription Management & Cancellation

As a Premium subscriber,
I want to view, pause, or cancel my subscription without friction,
So that I feel in control of my plan and not trapped.

**Acceptance Criteria:**

**Given** a Premium user on /settings/subscription
**When** the page loads
**Then** their current plan, renewal date, and payment method (last 4 digits via Stripe API) are displayed

**Given** a user clicking "Cancel subscription"
**When** the confirmation bottom sheet appears
**Then** the consequence is stated clearly ("Your Premium benefits continue until [date]") — no guilt language, no dark patterns

**Given** a user confirming cancellation
**When** the Stripe cancellation API call completes
**Then** the subscription is marked cancel_at_period_end in Stripe and the subscriptions table reflects the pending cancellation

**Given** the subscription period ending after cancellation
**When** the Stripe webhook fires
**Then** the subscriptions table updates to status: "inactive" and tier: "free", and PremiumGate components re-activate on next request

**Given** a cancelled user returning to /settings/subscription
**When** the page loads
**Then** a "Reactivate Premium" option is clearly available

---

## Epic 8: Community & Social

Users can follow other puzzlers, view a friend activity feed, browse contextually framed leaderboards, share solves via the Web Share API, participate in the weekly Puzzle of the Week with its special leaderboard, create or follow curated puzzle lists, submit and upvote feature requests on a public board, and send contextual in-app feedback.

### Story 8.1: Community Leaderboards

As a competitive puzzler,
I want to browse leaderboards showing solve times by puzzle and piece count,
So that I have meaningful context for my own performance.

**Acceptance Criteria:**

**Given** a logged-in user on /community/leaderboards
**When** the page loads
**Then** they can view leaderboards segmented by puzzle and by piece count category (500, 1000, 1500, 2000+ pieces)

**Given** a leaderboard
**When** it renders
**Then** rank is shown with contextual framing ("Top 12% for 1000-piece puzzles") rather than just a raw global number

**Given** a user's own entry in a leaderboard
**When** it renders
**Then** their row is visually highlighted so they can find their position immediately without scrolling

**Given** the leaderboard data
**When** a developer inspects it
**Then** it is fetched on page load (on-load refresh polling — not WebSocket real-time in V1, per Architecture decision)

**Given** a leaderboard with a Former Champion entry (FR52)
**When** it renders
**Then** the Former Champion badge is visible on that user's row

---

### Story 8.2: Follow Users & Activity Feed

As a social puzzler,
I want to follow other puzzlers and see their recent solve activity,
So that I feel part of a community and get inspiration from others' progress.

**Acceptance Criteria:**

**Given** a logged-in user on another user's profile page (/profile/[username])
**When** they view the page
**Then** a "Follow" button is available (or "Unfollow" if already following)

**Given** a user tapping Follow
**When** the action completes
**Then** a row is inserted in community_follows and a low-friction acknowledgement appears ("Following [username]")

**Given** a user on /community
**When** the activity feed loads
**Then** recent solve activity from followed users is shown: puzzle name, time, piece count, and a "nice solve" one-tap acknowledgement option

**Given** a user tapping "nice solve" on a feed item
**When** the action fires
**Then** a lightweight acknowledgement is saved (one tap, no comment required) and the feed item updates to reflect it

**Given** a user with no follows yet
**When** the activity feed renders
**Then** the warm empty state appears: "Follow other puzzlers to see their solves here. [Explore community]" — never a blank screen

**Given** a followed user logs a new solve
**When** the activity feed is next loaded (on-load refresh)
**Then** the new entry appears at the top of the feed

---

### Story 8.3: Share Solve via Web Share API

As a puzzler proud of a completion,
I want to share my solve result to external platforms with one tap,
So that I can spread the word about the platform organically.

**Acceptance Criteria:**

**Given** a user on the PostCompletionScreen
**When** they tap "Share"
**Then** the Web Share API is invoked with: title ("Just solved [puzzle name] in [time]!"), text (solve stats), and url (deep link to the puzzle catalog page)

**Given** a browser that does not support the Web Share API
**When** the share button is tapped
**Then** a clipboard copy fallback is used and a toast confirms ("Link copied to clipboard")

**Given** a user sharing from their Puzzle Passport
**When** the share action fires
**Then** the Web Share API shares a generated image of the Puzzle Passport card along with the solve stats

**Given** the share functionality
**When** a developer inspects it
**Then** it is implemented in the shared ShareButton component (components/shared/ShareButton.tsx) — not duplicated per feature

---

### Story 8.4: Puzzle of the Week

As a puzzler,
I want to participate in a weekly featured puzzle challenge and appear on a special leaderboard,
So that I have a recurring community event to look forward to.

**Acceptance Criteria:**

**Given** an admin has designated a Puzzle of the Week (Story 9.7 sets this up; for local dev a seed entry is provided in supabase/seed.sql)
**When** the /community page loads
**Then** the PuzzleOfTheWeek component renders as a visually distinct, beautifully designed weekly card — not a list item

**Given** the Puzzle of the Week card
**When** a user views it
**Then** the puzzle name, image, a "Solve this week" CTA, and a time-limited special leaderboard are all on the card

**Given** a user who logs a solve for the Puzzle of the Week during the active week
**When** their solve is saved
**Then** they automatically appear on the special leaderboard for that week

**Given** the week ending
**When** the system rolls over to a new Puzzle of the Week
**Then** the previous week's leaderboard becomes read-only and the new card shows the next puzzle

**Given** an admin-designated sponsored Puzzle of the Week (FR56)
**When** the card renders
**Then** a tasteful "Sponsored by [Brand]" label appears on the card without dominating the design

---

### Story 8.5: Curated Puzzle Lists

As a puzzler with opinions,
I want to create and publish curated lists of puzzles (e.g., "Best for Beginners"),
So that I can share my taste and help other puzzlers discover great puzzles.

**Acceptance Criteria:**

**Given** a logged-in user
**When** they navigate to create a list
**Then** a form allows them to set a list name, description, and add puzzles by searching the catalog

**Given** a user adding puzzles to a list
**When** they submit
**Then** the list is saved with its ordered puzzle entries and becomes visible on their profile

**Given** a user publishing a list
**When** it goes public
**Then** other users can discover and follow it from the community feed or catalog pages

**Given** a user following a list
**When** the list creator adds new puzzles
**Then** followers see the updated list on their next visit (on-load refresh — no real-time push for list updates in V1)
**And** no in-app notification is sent for list updates in V1; the follow relationship is a bookmark that surfaces updates passively on return

**Given** any puzzle detail page
**When** a user views it
**Then** curated lists that include that puzzle are shown ("Appears in 3 lists") with links to explore them

---

### Story 8.6: Feature Request Board — Browse & Vote

As a platform user,
I want to browse the feature request board and upvote requests I care about,
So that I can signal my priorities to the team and see where the platform is headed.

**Acceptance Criteria:**

**Given** a logged-in user navigating to /community/feature-requests
**When** the page loads
**Then** all feature requests are displayed as cards showing: title, short description, vote count, and a status tag (Under Review / Planned / In Progress / Shipped / Won't Build)

**Given** the feature request list
**When** it renders
**Then** requests are sortable by vote count (default) and by date submitted; a filter by status tag is available

**Given** a logged-in user viewing a request they have not yet voted on
**When** they tap the upvote button
**Then** their vote is recorded, the count increments immediately (optimistic update via TanStack Query), and the button state changes to "voted"

**Given** a user who has already voted on a request
**When** they view it
**Then** the upvote button is shown in its "voted" state and tapping it removes their vote (toggle behaviour)

**Given** a request with status "Won't Build"
**When** the card renders
**Then** the admin's public reason is displayed below the status tag — the reason field is required when an admin sets this status (enforced in Story 9.8)

**Given** a request with a published admin response (set in Story 9.8)
**When** the card renders
**Then** the response is shown inline on the card beneath the request description

**Given** an unauthenticated visitor on /community/feature-requests
**When** they view the board
**Then** all requests are visible in read-only mode; the upvote button prompts sign-in on tap

---

### Story 8.7: Feature Request Submission

As a platform user,
I want to submit a new feature request,
So that I can suggest improvements to the platform.

**Acceptance Criteria:**

**Given** a logged-in user on /community/feature-requests
**When** they tap "Submit a request"
**Then** a form appears with fields: title (required, max 120 chars) and description (required, max 500 chars)

**Given** a user typing a request title
**When** they have entered at least 5 characters
**Then** the form performs a live similarity search against existing requests and surfaces up to 3 potential duplicates with a prompt: "These existing requests might cover what you're looking for — would you like to upvote one instead?"

**Given** a user submitting a new request
**When** the form is saved
**Then** a feature_requests row is created with: title, description, submitter_id, status: "Under Review", vote_count: 1 (auto-upvoted by submitter); the request appears on the board immediately

**Given** a user who has already submitted a request in the current 24-hour window
**When** they attempt to submit another
**Then** an inline message informs them of the one-per-day submission limit — the limit is enforced at the Route Handler, not just in UI

**Given** a successfully submitted request
**When** the submission completes
**Then** a confirmation toast appears ("Your request has been submitted") and the form closes; the user's new request is visible at the top of the board sorted by "newest"

---

### Story 8.8: Feature Request Notifications & Premium Beta

As a platform user,
I want to be notified when a feature I voted for ships,
So that I know to look for it and feel that my input mattered.

**Acceptance Criteria:**

**Given** a user who voted on a feature request
**When** an admin updates the request status to Shipped (Story 9.8)
**Then** all voters receive an in-app notification: "A feature you voted for has shipped: [request title]" — delivered via the existing notification system (FR39)

**Given** a Premium Individual subscriber (FR37)
**When** an admin marks a shipped feature as "beta available" before setting status to Shipped
**Then** Premium users receive early access to the feature; the feature request board shows a "Beta — available to Premium members" label on that card

**Given** a non-Premium user viewing a card with the "Beta — available to Premium" label
**When** they tap the label
**Then** a bottom sheet explains what Premium beta access includes with a link to upgrade

**Given** a feature request whose status changes from any state to Shipped
**When** the status update is saved (Story 9.8)
**Then** the notification fan-out to all voters is handled asynchronously via a Supabase Edge Function — not inline in the Route Handler response

---

### Story 8.9: In-App Contextual Feedback

As a platform user,
I want to send feedback from wherever I am in the app,
So that I can report issues or suggestions in context without leaving my current task.

**Acceptance Criteria:**

**Given** any authenticated page in the application
**When** a user views the page
**Then** a persistent, unobtrusive feedback affordance is visible (e.g., a small button in the corner or accessible via the nav menu) — it does not interfere with primary page content

**Given** a user opening the feedback form
**When** the form appears
**Then** the originating page path and feature context are automatically captured and attached to the submission (not shown to user, stored server-side for admin triage)

**Given** a user composing feedback
**When** they choose to attach a screenshot
**Then** the browser's screenshot capability (or a manual file upload fallback) is available; the screenshot is attached to the submission

**Given** a user submitting feedback
**When** the submission completes
**Then** a confirmation toast appears ("Thanks — your feedback has been received") and the form closes; the user is not redirected or interrupted

**Given** an admin viewing the feedback queue (admin panel)
**When** they open a submission
**Then** the originating page, feature context tag, timestamp, user ID (anonymised display), and any attached screenshot are all visible

**Given** any unauthenticated page
**When** a visitor views it
**Then** the feedback affordance is not shown — feedback is for logged-in users only in V1

---

## Epic 9: Platform Administration & Trust Infrastructure

Administrators can investigate and resolve swap disputes, adjust reputation scores, apply tiered account restrictions, view a tamper-evident audit log of all moderation actions, moderate the puzzle catalog (merge duplicates, correct metadata), and manage the public feature request board (status updates, public responses, vote-threshold alerts).

### Story 9.1: Admin Panel Foundation & Role Enforcement

As a platform administrator,
I want a dedicated admin panel accessible only to verified admin accounts,
So that moderation tools are never accessible to regular users.

**Acceptance Criteria:**

**Given** any user attempting to access /admin/* routes
**When** Next.js Middleware processes the request
**Then** it checks the user_roles table for role: 'admin' or 'moderator'; any other session is redirected to /home

**Given** an admin user on /admin
**When** the dashboard loads
**Then** an overview of pending disputes, recent moderation actions, and catalog review queue is shown

**Given** all admin mutations (dispute resolution, reputation adjustment, account restriction)
**When** they are executed
**Then** they use the Supabase service role key in Route Handlers only — the service role key is never accessible in client bundles

**Given** the admin panel
**When** a developer inspects the route handlers
**Then** all /api/admin/* endpoints verify both authentication (valid session) and role (admin/moderator) before processing — never relying on a single check

---

### Story 9.2: Swap Dispute Queue & Resolution

As an administrator,
I want to review reported swap disputes and take moderation action,
So that bad-faith actors are held accountable and the trust system remains credible.

**Acceptance Criteria:**

**Given** a dispute has been reported (Epic 6 creates the record)
**When** an admin views /admin/disputes
**Then** the DisputeQueue shows: listing details, seller history (all past swaps + prior complaints), buyer reputation, dispute description, and any uploaded evidence

**Given** an admin reviewing a dispute
**When** they take a moderation action (warn seller, mark transaction disputed, adjust reputation)
**Then** the action is saved and an audit log entry is appended immediately

**Given** an admin issuing a warning
**When** the action fires
**Then** the seller receives an in-app notification describing the warning and its implications

**Given** all admin moderation actions
**When** they are saved
**Then** an audit_log row is created with: admin_id, action_type, target_user_id, description, timestamp — the row is append-only (no updates or deletes permitted via RLS)

---

### Story 9.3: Reputation Score Adjustment & Account Restrictions

As an administrator,
I want to adjust reputation scores and apply tiered account restrictions to sellers who violate trust policies,
So that the marketplace remains safe for all participants.

**Acceptance Criteria:**

**Given** an admin on /admin/users/[id]
**When** the page loads
**Then** the user's full profile, reputation score, swap history, and any prior moderation actions are visible

**Given** an admin adjusting a reputation score (FR45)
**When** the action is submitted
**Then** the reputation score updates in the database and an audit log entry is created

**Given** an admin applying a restriction (FR46)
**When** they choose a restriction tier (e.g., "photo-required listings" or "48-hour hold before listing goes live")
**Then** the restriction is saved to the user's account and applied to all future listings by that user automatically

**Given** an admin flagging an account for enhanced review
**When** the seller creates a new listing
**Then** the system enforces the restriction (photo required, hold applied) before the listing goes live — this is enforced at the Route Handler level, not just in UI

**Given** a restricted user
**When** they view their account settings
**Then** a notice explains any active restrictions on their account

---

### Story 9.4: Admin Audit Log

As an administrator,
I want a tamper-evident audit log of all moderation actions,
So that every decision is traceable and accountable.

**Acceptance Criteria:**

**Given** any moderation action is taken by an admin
**When** the action is saved
**Then** an audit_log row is appended with: admin_id, action_type, target_entity_id, action_description, timestamp

**Given** the audit log RLS policy
**When** any client attempts to update or delete an audit_log row
**Then** the operation is rejected — the table is append-only by design

**Given** an admin on /admin (FR47)
**When** they view the AuditLog component
**Then** a paginated, reverse-chronological list of all moderation actions is shown with admin name, action type, target, and timestamp

**Given** a GDPR deletion request (FR19, ARCH15)
**When** an audit log entry references a deleted user
**Then** the user_id is retained but any PII fields are replaced with a sentinel value ("deleted_user") — the log remains legally complete without containing PII

---

### Story 9.5: Puzzle Catalog Moderation

As an administrator,
I want to review user-submitted puzzles, merge duplicate entries, and correct metadata errors,
So that the catalog remains accurate and trustworthy.

**Acceptance Criteria:**

**Given** user-submitted puzzles from Story 2.5 (status: "pending_review")
**When** an admin views /admin/catalog
**Then** a review queue shows all pending submissions with the submitted data and any potential duplicate matches found automatically

**Given** an admin approving a submission
**When** they tap "Approve"
**Then** the puzzle status updates to "active" and it becomes publicly visible in the catalog

**Given** an admin identifying a duplicate (FR48)
**When** they use the CatalogMerger tool
**Then** they can select two puzzle entries and merge them: one entry is marked as the canonical record, solve logs referencing the merged entry are updated to point to the canonical entry, and the duplicate is archived

**Given** an admin correcting puzzle metadata (wrong piece count, incorrect brand)
**When** the edit is submitted
**Then** the puzzle_catalog row is updated and the change is logged in the audit trail

**Given** a reported puzzle issue from Story 2.5 (FR11)
**When** an admin views the report in the catalog queue
**Then** the original reporter is credited if the issue results in a catalog correction

---

### Story 9.6: GDPR Data Deletion & Right-to-Erasure

As a user,
I want to permanently delete my account and all associated personal data,
So that I can exercise my right to erasure under GDPR.

**Acceptance Criteria:**

**Given** a logged-in user on /settings
**When** they tap "Delete my account"
**Then** a confirmation bottom sheet appears with a clear statement of what will be deleted and that this is irreversible

**Given** a user confirming deletion
**When** the request is submitted
**Then** a deletion_requests row is created with a 30-day SLA timestamp and the user is immediately signed out

**Given** a deletion request
**When** the queued Supabase Edge Function processes it
**Then** the GDPR cascade policy is applied: solve_history → hard delete; swap records → anonymize (seller/buyer replaced with sentinel UUID); reputation scores → delete; badge awards → delete; auth account → hard delete via Supabase Admin API

**Given** audit log entries referencing the deleted user
**When** the cascade runs
**Then** user_id fields in audit_log are replaced with the sentinel UUID — the log retains accountability without retaining PII

**Given** the deletion is complete
**When** an admin reviews the deletion_requests queue
**Then** the request is marked "completed" with a timestamp — the 30-day SLA is trackable

---

### Story 9.7: Puzzle of the Week Designation & Sponsorship

As a platform administrator,
I want to designate a weekly featured puzzle, schedule its active week, and optionally mark it as sponsored,
So that the Puzzle of the Week feature (FR54/FR56) has live content and the community card in Story 8.4 can function.

**Acceptance Criteria:**

**Given** an admin on /admin/puzzle-of-the-week
**When** the page loads
**Then** the current Puzzle of the Week (if any) is shown with its active week range, puzzle details, and sponsored status
**And** a history of past Puzzle of the Week designations is listed below in reverse chronological order

**Given** an admin tapping "Designate new Puzzle of the Week"
**When** the form renders
**Then** fields are: puzzle (catalog search — required), week start date (Monday only — required), sponsored toggle (off by default), sponsor name (text field, enabled only when sponsored is on)

**Given** an admin submitting a valid designation
**When** the form is saved
**Then** a row is inserted in a `puzzle_of_the_week` table with: puzzle_id, week_start (Monday), week_end (Sunday), is_sponsored, sponsor_name, designated_by (admin user_id)
**And** an audit log entry is appended recording the designation
**And** the /community Puzzle of the Week card (Story 8.4) reflects the new designation immediately on next page load

**Given** the week ending (Sunday midnight UTC)
**When** the system checks the active designation
**Then** the previous week's `puzzle_of_the_week` row is automatically marked `archived: true` by a Supabase scheduled Edge Function (or cron trigger)
**And** the special leaderboard for that week becomes read-only

**Given** an admin designating a sponsored Puzzle of the Week (FR56)
**When** the designation is saved with `is_sponsored: true` and a sponsor name
**Then** the PuzzleOfTheWeek card in Story 8.4 renders the "Sponsored by [sponsor name]" label
**And** the audit log records the sponsor name alongside the admin action

**Given** the supabase/seed.sql development seed file
**When** `supabase db seed` is run locally
**Then** a default Puzzle of the Week entry is seeded for the current week so Story 8.4 can be developed and tested before Story 9.7 is in place

---

### Story 9.8: Feature Request Administration

As a platform administrator,
I want to manage feature requests — updating their status, publishing responses, and being alerted when requests hit the vote threshold —
So that the public board stays current and users feel the platform is genuinely responsive.

**Acceptance Criteria:**

**Given** an admin on /admin/feature-requests
**When** the page loads
**Then** all feature requests are shown in a sortable table with: title, vote count, current status, date submitted, and a "response published" indicator

**Given** a request that has crossed the platform-configured vote threshold (configurable in /admin/settings, default: 10 votes)
**When** the threshold is reached
**Then** the admin panel surfaces the request in a "Needs Response" queue with a visual indicator; no automated public action is taken until the admin acts

**Given** an admin updating a request's status
**When** they select a new status from the dropdown (Under Review / Planned / In Progress / Shipped / Won't Build)
**Then** the status updates immediately; if the new status is "Won't Build" the reason field is required before saving

**Given** an admin saving a "Won't Build" status without a reason
**When** they attempt to submit
**Then** the save is blocked and the reason field is highlighted — the reason is required to maintain transparency on the public board (Story 8.6)

**Given** an admin publishing a public response on a request
**When** they submit the response text
**Then** the response is saved and displayed on the request card in Story 8.6; the "response published" indicator updates in the admin table

**Given** an admin setting a request status to Shipped
**When** the update is saved
**Then** the notification fan-out to all voters is triggered asynchronously (Story 8.8); the admin sees a confirmation that notifications are queued

**Given** an admin marking a shipped feature as "beta available" before setting status to Shipped
**When** this flag is set
**Then** Premium users gain early access to the feature and the "Beta — available to Premium" label appears on the board card (Story 8.8); the Shipped status is set separately when the feature goes fully public

**Given** all admin actions on feature requests
**When** they are saved
**Then** an audit_log entry is appended with: admin_id, action_type ("feature_request_status_update" or "feature_request_response_published"), request_id, new_value, timestamp

