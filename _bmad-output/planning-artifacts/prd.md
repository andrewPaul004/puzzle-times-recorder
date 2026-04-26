---
stepsCompleted: ["step-01-init", "step-02-discovery", "step-02b-vision", "step-02c-executive-summary", "step-03-success", "step-04-journeys", "step-05-domain", "step-06-innovation", "step-07-project-type", "step-08-scoping", "step-09-functional", "step-10-nonfunctional", "step-11-polish"]
releaseMode: phased
inputDocuments:
  - "_bmad-output/planning-artifacts/research/market-jigsaw-puzzle-tracking-community-platform-research-2026-04-25.md"
  - "_bmad-output/brainstorming/brainstorming-session-2026-04-25-1.md"
workflowType: 'prd'
briefCount: 0
researchCount: 1
brainstormingCount: 1
projectDocsCount: 0
classification:
  projectType: "Web App (SPA/PWA, mobile-first)"
  domain: "Vertical multi-sided network — social + trust-critical marketplace + gamification + ML"
  complexity: "Medium-High"
  projectContext: "greenfield"
  firstCohort: "Speed puzzlers migrating from myspeedpuzzling.com (MSP)"
  primaryDifferentiator: "Mobile-first UX (3-tap log), swap marketplace, superior mobile experience vs MSP"
---

# Product Requirements Document - PuzzleTimesRecorder

**Author:** Andrew
**Date:** 2026-04-25

## Executive Summary

PuzzleTimesRecorder is a mobile-first jigsaw puzzle tracking and community platform targeting the 48% of American adults who puzzle regularly — and specifically, the underserved speed puzzler cohort currently trapped on myspeedpuzzling.com (MSP), a donation-funded Czech-built desktop tool with no mobile experience, no marketplace, and its most-requested features (gamification, social layer) sitting unassigned on a public GitHub board.

The market structure mirrors Letterboxd vs. Goodreads: a neglected utilitarian incumbent, a large engaged community fragmented across Reddit and Facebook groups, and no community-first alternative. Letterboxd grew from 1.3M to 17M users in four years in precisely this structure. The window is open now — before MSP ships the features their users are publicly demanding.

The platform competes on three axes MSP cannot address without a full rebuild: a mobile-first UX designed for the moment of victory (3-tap log, one-handed operation, offline-first), a trusted swap marketplace with condition grading and reputation infrastructure, and data portability (MSP CSV import, universal spreadsheet template) that removes the sunk-cost barrier keeping puzzlers on the incumbent.

Revenue is freemium: a free core that out-competes MSP on every dimension, Premium Individual tiers unlocking AI coaching and unlimited swap listings, Premium Club for organized puzzle groups, affiliate revenue on puzzle recommendations, and a B2B data layer for puzzle manufacturers designed into the schema from day one.

### What Makes This Special

**Mobile-first as an architectural commitment, not an afterthought.** The core log interaction — puzzle scanned or searched, time recorded, photo attached, solve logged — takes 3 taps, works one-handed, queues offline. This single interaction gap is MSP's most visible failure and the primary switching trigger for the first cohort.

**A trusted swap marketplace no puzzle platform has solved.** Condition grading, reputation scoring, and seller history turn the secondary puzzle market (currently fragmented across Facebook Marketplace and eBay) into a single trustworthy destination. The marketplace is free (acquisition driver); power features are premium.

**Data portability as an acquisition wedge.** MSP CSV import with fuzzy puzzle matching removes the primary friction for switching — years of solve history. The "you own your data" promise signals confidence and seeds the AI coaching and recommendation engines from day one.

**Warm, tactile design with purposeful micro-animations.** Cozy, not flashy. A design language that feels earned — built for people who love the physical act of puzzling, not for speed-run dashboards.

## Project Classification

- **Project Type:** Web App — SPA/PWA, mobile-first, with progressive enhancement for desktop
- **Domain:** Vertical multi-sided network — trust-critical social platform + swap marketplace + gamification engine + ML recommendation/coaching layer
- **Complexity:** Medium-High — marketplace trust infrastructure, honor-system fraud model, multi-language from day one, AI cold-start dependency, dual-mode user archetypes (casual logger vs. active swapper)
- **Context:** Greenfield — no existing system; first cohort is speed puzzlers actively migrating from myspeedpuzzling.com

## Success Criteria

### User Success

- A speed puzzler migrating from MSP can import their full solve history and complete their first new solve log in under 5 minutes of signing up
- The core log interaction — scan or search puzzle, record time, attach photo — completes in 3 taps, one-handed, on a mobile device
- Users who log at least 3 solves in their first week return the following week at a rate ≥ 60%
- A swap listing can be created (photo, condition grade, description) in under 2 minutes
- The platform feels faster, warmer, and more rewarding than MSP within the first session — measurable via post-onboarding NPS

### Business Success

- **3-month:** 100–500 active users (MSP migrators + word-of-mouth); 80%+ of signups complete first solve log; at least 10 completed swap transactions; qualitative confirmation of "better than MSP" from early users
- **12-month:** 2,000–5,000 MAU; 5–10% Premium Individual conversion; puzzle catalog covers ≥ 80% of commonly logged puzzles (barcode hit rate); positive unit economics on Premium tier
- **18-month:** Meaningful swap marketplace liquidity (users can find a swap partner within 7 days); first Premium Club customers; affiliate revenue contributing to sustainability

### Technical Success

- Offline-first log queuing — solves recorded without connectivity sync correctly on reconnect, zero data loss
- Barcode scan resolves to correct puzzle in catalog ≥ 80% of cases at launch, improving with catalog growth
- MSP CSV import processes successfully for ≥ 95% of valid exports, with fuzzy puzzle matching covering ≥ 75% of titles
- i18n architecture supports adding a new language without code changes — translation layer complete at launch even if only English ships V1
- Page load on mobile (3G) under 3 seconds for core log and dashboard views

### Measurable Outcomes

- Pioneer Migrator badge awarded to first 500 MSP imports — tracks early cohort
- Week-1 retention ≥ 50%, Week-4 retention ≥ 30% (consumer social benchmark)
- Swap marketplace trust score average ≥ 4.2/5 after first 50 transactions
- Premium conversion rate ≥ 5% of MAU within 12 months

## Product Scope

Three delivery phases: V1 (MVP), V1.5 (Growth), V2+ (Vision). Full feature breakdown and risk mitigation in the [Project Scoping & Phased Development](#project-scoping--phased-development) section.

## User Journeys

### Journey 1: The MSP Migrator — Emma, Competitive Speed Puzzler

**Opening Scene:** Emma has been logging times on MSP for three years. She's ranked in the top 200 globally for 1000-piece puzzles. But she does most of her puzzling late at night on the couch with her phone — and every time she tries to log a solve on MSP, she's pinching and zooming a desktop UI, navigating three screens, and losing the high of finishing. She hears about PuzzleTimesRecorder in a r/Jigsawpuzzles thread.

**Rising Action:** She signs up on her phone in 90 seconds. The import screen offers to bring her MSP history — she exports her CSV from MSP and uploads it. Within two minutes, three years of solve data is in the platform. A "Pioneer Migrator" badge appears. Her personal bests auto-populate. She opens a new puzzle, taps "Start Timer," finishes, taps "Stop" — one more tap to confirm the puzzle name (pre-filled from barcode scan) and she's done. Three taps. Ten seconds.

**Climax:** She checks her dashboard and sees her full solve history visualized — average times by piece count, improvement trend over three years, a streak counter showing she's puzzled 12 days in a row. MSP never showed her this. She screenshots it and posts it to the subreddit.

**Resolution:** Emma logs every solve here now. She's referred four friends from the MSP Discord. She upgrades to Premium for streak shields before a vacation. She's not going back.

**Capabilities revealed:** MSP CSV import, barcode scan, 3-tap log flow, timer, personal dashboard with analytics, streak tracking, badges, referral hooks.

---

### Journey 2: The Casual Collector — Marcus, Weekend Puzzler & Swap Seeker

**Opening Scene:** Marcus doesn't care about speed — he puzzles for relaxation. He has 47 puzzles stacked in a closet, half of them done once and unlikely to be touched again. He's tried selling them on Facebook Marketplace twice; both deals fell through. He finds PuzzleTimesRecorder while searching for "puzzle swap."

**Rising Action:** He creates an account and goes straight to the swap marketplace. He lists three puzzles — photos from his phone, condition graded (all "Very Good," one piece missing noted in description), done in under 2 minutes each. He then browses listings and finds a Ravensburger he's wanted — seller has 12 positive swap reviews and a 4.8 reputation score. He requests the swap.

**Climax:** The swap completes. Both parties confirm receipt and rate each other. Marcus gets his Ravensburger, his reputation score ticks up, and his closet has three fewer puzzles. He starts logging his solves casually — not for speed, just to remember what he's done.

**Resolution:** Marcus is a monthly active user primarily through the marketplace. He converts to Premium when he wants to list more than 3 swaps simultaneously. The platform has a user who was never going to come through MSP at all.

**Capabilities revealed:** Swap marketplace (listing, browsing, condition grading, reputation system, swap request/confirmation flow), collection manager, photo upload, free-tier swap limits, Premium upgrade prompt.

---

### Journey 3: The Edge Case — Priya, Import Failure & Recovery

**Opening Scene:** Priya exports her MSP data but her CSV is malformed — she has 6 years of solve history including puzzles logged with non-standard titles she typed manually. The import runs and returns a partial match: 340 of 412 solves matched to catalog puzzles, 72 unmatched.

**Rising Action:** The platform shows her the 72 unmatched solves in a review queue. For each, it suggests the closest catalog match with a confidence score. She can accept the suggestion, search manually, or mark as "custom puzzle" (not in catalog). She works through 30 in a batch, defers the rest. Her existing 340 solved puzzles populate her dashboard immediately — partial progress, not blocked.

**Climax:** She resolves the remaining 42 over the next week as she uses the app normally. Each resolution awards her the retroactive badges the solve would have earned. Her Pioneer Migrator badge arrives when she hits 100% import completion.

**Resolution:** Priya's experience was bumpy but she never felt stuck. The progressive resolution model meant she got value from day one. She posts about the import flow in the MSP Discord, specifically noting it handled her messy data gracefully.

**Capabilities revealed:** Import validation, confidence-scored fuzzy matching, unmatched solve review queue, batch resolution UI, progressive import completion, retroactive badge awarding, error messaging that informs rather than blocks.

---

### Journey 4: The Platform Admin — Internal Operations

**Opening Scene:** A week after launch, a user reports a swap listing with potentially fraudulent condition grading — a puzzle listed as "Excellent" that arrived missing 15 pieces. The buyer has opened a dispute.

**Rising Action:** The admin opens the dispute queue. They can see the listing, the seller's history (3 previous swaps, one prior complaint), the buyer's reputation, and the reported evidence. They issue a warning to the seller, mark the transaction as "disputed," and trigger a reputation score adjustment.

**Climax:** The admin flags the seller account for enhanced review on future listings (photos required, 48-hour hold before listing goes live). The buyer is offered a reputation restoration.

**Resolution:** The dispute resolves in 4 days. The trust system's public reputation scores update transparently. The admin has a full audit trail. No code changes needed — the moderation tools handle the case.

**Capabilities revealed:** Admin dispute queue, seller/buyer profile view with full history, reputation score adjustment, account flagging and tiered restrictions, audit log, moderation action templates.

---

### Journey Requirements Summary

| Capability Area | Revealed By |
|---|---|
| MSP CSV import + fuzzy matching + review queue | Journey 1 + 3 |
| Barcode scan + 3-tap log flow + offline queuing | Journey 1 |
| Personal dashboard (analytics, streaks, trends) | Journey 1 |
| Badge system (Pioneer Migrator, retroactive awards) | Journey 1 + 3 |
| Swap marketplace (listing, grading, reputation, request flow) | Journey 2 |
| Freemium gating + Premium upgrade prompts | Journey 2 |
| Collection manager | Journey 2 |
| Dispute resolution + admin moderation tools | Journey 4 |
| Audit log + seller restriction tiers | Journey 4 |
| Progressive/partial import with unmatched review | Journey 3 |

## Innovation & Novel Patterns

### Detected Innovation Areas

**1. Trusted peer-to-peer puzzle swap marketplace**
No puzzle platform has built a structured swap marketplace with condition grading, reputation scoring, and dispute resolution. The secondary puzzle market currently exists as fragmented activity across Facebook Marketplace, eBay, and Reddit threads — entirely without trust infrastructure. This is the product's clearest moat: once a critical mass of swappers establishes reputation scores on the platform, they have no incentive to transact elsewhere.

**2. AI Puzzle Performance Coach**
Applying ML-driven performance coaching to jigsaw puzzling is genuinely novel. The closest analogues are fitness apps (Strava's training analysis, chess.com's game review) — but no one has built solve-time trend analysis, difficulty-adjusted benchmarking, or AI-generated improvement suggestions for puzzling. The data model required to power this (solve time × piece count × brand × difficulty × conditions) is a defensible asset once accumulated.

**3. Spotify-style puzzle recommendation engine**
Collaborative filtering for puzzle discovery — "people who loved this Ravensburger also loved..." — doesn't exist anywhere. Combined with affiliate revenue on buy links, this creates a flywheel: more solves logged → better recommendations → more puzzle purchases → affiliate revenue → platform sustainability.

**4. Data portability as a trust signal and acquisition mechanism**
Offering MSP CSV import + easy export of your own data is a novel positioning move in a market where incumbents rely on data lock-in. The "you own your data" promise simultaneously removes switching friction (import) and builds long-term trust (export). Few consumer platforms make both moves simultaneously, especially at launch.

### Market Context & Competitive Landscape

The Letterboxd structural analogy holds: Letterboxd built its moat on taste-graph data (ratings, lists, diary) that made every user's account more valuable over time. The equivalent here is solve history + swap reputation + puzzle ratings — none of which are portable from MSP. First-mover advantage in building this graph is significant.

The AI coach and recommendation engine are V1.5 features, but the data architecture must anticipate them from V1. Solve logs that don't capture enough metadata (piece count, brand, difficulty rating, puzzle format) cannot retroactively power these features.

### Validation Approach

- **Swap marketplace:** 10 completed swaps with ≥ 4.0 average trust rating within 30 days of launch validates the core trust model
- **AI coach:** Requires minimum viable dataset — estimate 500 solve logs from 50+ users before first meaningful coaching outputs; build "coming soon" placeholder with data progress indicator
- **Recommendation engine:** Collaborative filtering requires cold-start strategy; seed with editorial "curator picks" and brand-based recommendations until user graph is sufficient
- **Data portability:** Measure import completion rate (target ≥ 80% of started imports reach 100% match) and export usage rate as trust signal proxies

### Risk Mitigation

| Innovation | Risk | Mitigation |
|---|---|---|
| Swap marketplace trust | Bad actors gaming reputation scores | Minimum swap count before reputation displays; admin review threshold; photo-required listings after disputes |
| AI coach cold start | Weak coaching outputs damage credibility | Gate behind minimum solve count (e.g., 20 solves); set expectations ("your coach is learning") |
| Recommendation cold start | Generic recommendations feel hollow | Seed with curated editorial lists + brand/theme filters until graph is rich enough |
| Data portability | MSP changes CSV format | Abstract import layer; version-detect CSV structure; fallback to manual field mapping |

## Design Philosophy

### Visual Experience

The platform's design language is warm, tactile, and cozy — evoking the physical pleasure of puzzling rather than the cold precision of a speed-run tool. Design is a first-class differentiator, not decoration.

**Core principles:**
- Every interaction that completes a meaningful action earns a micro-moment of delight: badge unlocks, record-breaking events, streak milestones, and swap completions each have distinct, purposeful animations
- Animations reference the physical puzzle experience — piece-click haptics on badge unlocks, satisfying fill animations on progress, smooth completion celebrations
- The Puzzle Passport (shareable user profile) should feel like a physical passport: textured, stamped, collectable
- Puzzle of the Week is a beautifully designed weekly card, not a list item
- The platform should feel unhurried, craft-forward, and cozy — not a SaaS dashboard

**Emotional design targets:**
- A new user feels welcomed and unhurried within 30 seconds of landing
- A badge unlock produces genuine delight, not just a toast notification
- A completed swap feels like a satisfying physical handoff, not a transaction confirmation

**Design anti-patterns to avoid:**
- Cluttered dashboards (MSP's primary failure)
- Cold, clinical typography and layout
- Gamification that feels manipulative rather than celebratory
- Dark patterns in the premium upgrade flow

## Web App Specific Requirements

### Project-Type Overview

Single-page application (SPA) delivered as a Progressive Web App (PWA) with offline capability. Mobile-first responsive design — the primary experience is a phone in hand; desktop is progressive enhancement. No native app in V1; PWA install prompt surfaces after first solve log.

### Browser Support Matrix

- **Primary:** Chrome/Safari on iOS and Android (covers ≥ 85% of target users)
- **Secondary:** Chrome/Firefox/Safari on desktop (progressive enhancement)
- **Minimum:** ES2020, CSS Grid, Service Workers, Web Share API, Camera API (barcode scan)
- **Explicitly excluded:** IE11, legacy Android WebView

### Responsive Design

- Mobile breakpoints: 375px (iPhone SE) as minimum viable viewport
- Touch targets: minimum 44×44px per Apple HIG / WCAG 2.5.5
- One-handed operation: primary actions within thumb reach on 6" screen
- Offline-first: Service Worker caches core app shell and queues solve logs; syncs on reconnect

### SEO Strategy

- **Public (SEO-optimized):** Puzzle catalog pages, brand pages, community review aggregates, landing/marketing pages — server-side rendered or statically generated for crawlability
- **Authenticated (not SEO-targeted):** Dashboard, logging flow, marketplace management, profile — client-rendered SPA
- Puzzle catalog pages carry the acquisition SEO load: title, piece count, brand, difficulty, aggregated community rating as structured data

### Accessibility

- WCAG 2.1 AA compliance — non-negotiable given international launch intent
- i18n architecture: all UI strings externalized via translation keys at build time; no hardcoded copy
- RTL layout support designed in from the start (Arabic/Hebrew potential markets)
- Color contrast, screen reader support for core log and marketplace flows

### Real-time Considerations

Leaderboards and community feeds: **near-real-time** (polling or on-load refresh) in V1 — not WebSocket push. Rationale: real-time adds infrastructure complexity; speed puzzlers checking leaderboards between sessions don't require live updates. Revisit in V1.5 if engagement data shows demand.

### Implementation Considerations

- PWA manifest + Service Worker required at launch (offline log queuing is a V1 success criterion)
- Barcode scanning via browser Camera API (no native app required); fallback to manual search when camera unavailable
- Image uploads (swap listings, solve photos): client-side compression before upload; lazy loading in feeds
- Payment integration: Stripe (or equivalent) for Premium subscriptions; PCI scope handled by processor
- Analytics: privacy-first (no third-party trackers in EU without consent); first-party event logging for core funnels

## Project Scoping & Phased Development

### MVP Strategy & Philosophy

**MVP Approach:** Experience MVP — the V1 release must feel meaningfully better than MSP on every dimension a speed puzzler touches daily. A feature-poor clone that merely exists is not viable; the first cohort will make or break word-of-mouth. The bar is: "I'm never going back to MSP."

**Resource Requirements:** Solo founder or small team (1–3 engineers). Tech choices should favor boring, proven stack (e.g., Next.js + Postgres + Stripe) over novel infrastructure. The moat is product and community, not technology.

### V1 Feature Set (MVP)

**Core User Journeys Supported:** Emma (MSP migrator, happy path), Marcus (casual collector + swap seeker), Priya (partial import recovery), Admin (dispute moderation)

**Must-Have Capabilities:**
- Mobile-first PWA with offline solve log queuing
- Barcode scan + 3-tap log flow (timer, puzzle search, photo)
- Puzzle collection manager
- Personal dashboard: streaks, personal bests, solve history, improvement trends
- MSP CSV import with fuzzy matching + unmatched review queue
- Retroactive badge awards on import; Pioneer Migrator badge
- Core gamification: streaks, personal records, badge set
- Swap marketplace: listings with condition grading, reputation scores, swap request/confirmation flow, basic dispute reporting
- Community ratings and micro-reviews on puzzle catalog pages
- Frictionless onboarding (sign up → first log ≤ 5 min)
- Freemium gating: free tier + Premium Individual (unlimited swaps, streak shields)
- i18n architecture; English at launch
- SEO-optimized public puzzle catalog pages
- Admin dispute queue + moderation tools

### V1.5 — Growth Features

- AI Puzzle Performance Coach (gated behind ≥ 20 solves; cold-start managed)
- Puzzle recommendation engine (Spotify-style; seeds with editorial picks until graph is sufficient)
- Puzzle Contest Finder
- User competitions and community leaderboards (real-time refresh)
- Retroactive AI Coach analysis of imported MSP history
- Invite-a-friend flow targeting MSP connections
- Premium Club tier (club pages, group leaderboards, library tracker)

### V2+ — Vision

- Puzzle lending between trusted community members
- B2B manufacturer data insights (data model ready from V1)
- Creator program
- Browser extension for comprehensive MSP data extraction
- Native iOS/Android apps (if PWA adoption proves insufficient)

### Risk Mitigation Strategy

**Technical Risks:**
- *Barcode catalog coverage* — mitigate by seeding catalog from Open Food Facts, UPC databases, and community contributions before launch; launch with manual search fallback
- *MSP CSV format changes* — abstract import layer with version detection; community-reported format changes trigger quick patch
- *Offline sync edge cases* — solve log is the most critical data; implement idempotent sync with local-first conflict resolution

**Market Risks:**
- *MSP ships mobile app before launch* — accelerate; their codebase is not mobile-native, a responsive redesign takes months, not weeks
- *First cohort too small to bootstrap swap liquidity* — seed marketplace with admin listings and partner with puzzle swap Facebook groups at launch

**Resource Risks:**
- *Single developer* — V1 scope is achievable with Next.js full-stack; Stripe handles payments; Cloudinary or similar handles images; defer real-time features to V1.5
- *Catalog not complete at launch* — launch with top 500 most-logged puzzles on MSP (inferable from public leaderboards); manual add flow for users

## Functional Requirements

### Solve Logging & Tracking

- **FR1:** Users can start and stop a puzzle solve timer
- **FR2:** Users can associate a completed solve with a puzzle via barcode scan
- **FR3:** Users can associate a completed solve with a puzzle via manual catalog search
- **FR4:** Users can attach a photo to a completed solve
- **FR5:** Users can record a solve while offline; the solve syncs automatically when connectivity is restored
- **FR6:** Users can view their complete solve history with timestamps, times, and puzzle details
- **FR7:** Users can add a puzzle to their collection without logging a solve
- **FR49:** Users can attach an optional personal note or journal entry to a completed solve (context, mood, companions)

### Puzzle Catalog

- **FR8:** Users can search the puzzle catalog by title, brand, piece count, and theme
- **FR9:** Users can view a puzzle's details including title, brand, piece count, difficulty, and aggregated community rating
- **FR10:** Users can submit a rating and micro-review for a puzzle they have solved
- **FR11:** Users can report a puzzle missing from the catalog
- **FR12:** Users can submit a new puzzle to the catalog via manual entry or barcode scan result
- **FR13:** Unauthenticated visitors can discover puzzles through publicly accessible catalog pages

### Data Import & Export

- **FR14:** Users can import their solve history from a myspeedpuzzling.com CSV export
- **FR15:** The system matches imported solves to catalog puzzles using fuzzy title matching with confidence scores
- **FR16:** Users can review unmatched solves from an import and manually assign them to catalog puzzles
- **FR17:** Users can mark unmatched solves as custom/uncatalogued puzzles
- **FR18:** Users can import solve history from a universal spreadsheet template (non-MSP users)
- **FR19:** Users can export their complete solve history and profile data at any time

### Gamification & Personal Dashboard

- **FR20:** Users can view their current solve streak and streak history
- **FR21:** Users can view their personal best times by puzzle and by piece count category
- **FR22:** Users can earn badges based on solve milestones, import completion, and platform activity
- **FR23:** The system awards retroactive badges to solve history (including imported history) when badge criteria are met
- **FR24:** Users can view a personal analytics dashboard showing solve trends, improvement over time, and solve statistics
- **FR25:** Premium users can apply a streak shield to protect their streak from breaking during an inactive period
- **FR50:** Users can set personal puzzling goals (annual or monthly targets: puzzle count, total piece count, or time-based) and track progress with a visual meter
- **FR51:** The system notifies both the new record holder and the displaced record holder when a personal best is surpassed by another user
- **FR52:** Users who are displaced from a record receive a permanent "Former Champion" badge on their profile

### Swap Marketplace

- **FR26:** Users can create a swap listing with puzzle details, condition grade, photos, and description
- **FR27:** Users can browse and filter swap listings by puzzle title, condition grade, and location
- **FR28:** Users can send a swap request to a listing owner
- **FR29:** Listing owners can accept, decline, or counter an incoming swap request
- **FR30:** Users can confirm receipt of a swapped puzzle and rate the transaction and counterparty
- **FR31:** Users can view another user's reputation score and full swap transaction history
- **FR32:** Users can report a dispute on a swap transaction
- **FR33:** Free-tier users are limited to a set number of active swap listings; Premium Individual users have unlimited active listings
- **FR53:** Premium users can set "In Search Of" (ISO) alerts for specific puzzles and receive a notification when a matching swap listing is created

### User Accounts & Subscriptions

- **FR34:** Users can register for an account and complete onboarding with a first solve logged within 5 minutes
- **FR35:** Users can manage their profile including display name, avatar, location, and puzzling preferences
- **FR36:** Users can upgrade to a Premium Individual subscription
- **FR37:** Premium Individual subscribers can access streak shields, unlimited swap listings, and enhanced analytics
- **FR38:** Users can manage, pause, or cancel their subscription
- **FR39:** Users can configure notification preferences for swap activity, badge awards, and community interactions
- **FR40:** Users can access the platform interface in their preferred language

### Community & Social

- **FR41:** Users can view community leaderboards for solve times segmented by puzzle and piece count
- **FR42:** Users can follow other users and view their recent solve activity in a feed
- **FR43:** Users can share a completed solve to external platforms via the Web Share API
- **FR54:** The platform designates a weekly featured puzzle (Puzzle of the Week); users who log a solve that week appear on a time-limited special leaderboard
- **FR55:** Users can create, name, publish, and follow curated puzzle lists (e.g., "Best Puzzles for Beginners," "My 2026 Bucket List")
- **FR56:** Administrators can designate and mark the Puzzle of the Week as sponsored for manufacturer brand placement

### Platform Administration

- **FR44:** Administrators can view, investigate, and resolve reported swap disputes
- **FR45:** Administrators can adjust user reputation scores and apply tiered account restrictions
- **FR46:** Administrators can place listings under enhanced review (photo-required, hold before visible)
- **FR47:** Administrators can view a full audit log of all moderation actions
- **FR48:** Administrators can manage the puzzle catalog including merging duplicate entries and correcting metadata

## Non-Functional Requirements

### Performance

- Core solve log flow (start timer → stop → confirm puzzle → save): end-to-end completes in ≤ 3 seconds on a mid-range Android device on 3G
- Barcode scan resolves to a catalog puzzle match in ≤ 1.5 seconds
- Offline solve logs sync within 10 seconds of connectivity restoration; zero data loss on reconnect
- First Contentful Paint on mobile (3G): ≤ 2.5 seconds for all authenticated views
- Puzzle catalog search returns results in ≤ 1 second for queries against the full catalog
- Swap listing creation (photo upload + form submit): completes in ≤ 5 seconds on WiFi
- Lighthouse performance score ≥ 85 on mobile for core app views

### Security

- All user data encrypted at rest and in transit (TLS 1.2+ for all API communication)
- Passwords hashed using bcrypt or Argon2; no plaintext passwords stored anywhere
- Authentication via secure session tokens with appropriate expiry; refresh token rotation on use
- Payment processing delegated entirely to Stripe; no card data stored or transmitted through application servers (PCI-DSS scope handled by processor)
- User data access scoped by authentication — no cross-account data leakage possible by design
- Swap dispute evidence and admin actions stored in tamper-evident audit log
- GDPR compliance for EU users: explicit consent for analytics tracking, right-to-deletion honoured within 30 days (including imported solve history), data export available at any time (FR19)

### Scalability

- System handles 0–1,000 concurrent users without performance degradation at V1 launch
- Architecture supports 10× user growth (to ~10,000 MAU) through horizontal scaling of stateless application layer without re-architecture
- Puzzle catalog designed to support ≥ 100,000 puzzle entries without query degradation (indexed appropriately from day one)
- Image storage and CDN architecture chosen to scale independently of application servers
- B2B manufacturer data model designed into schema from V1 — no migration required to activate V2 B2B features

### Accessibility

- WCAG 2.1 AA compliance across all authenticated and public-facing views
- All UI strings externalized via i18n translation keys at build time; adding a new language requires no code changes
- RTL layout support architecturally in place from V1 (not necessarily activated, but not requiring rework to enable)
- Touch targets ≥ 44×44px on all interactive elements
- Colour contrast ratio ≥ 4.5:1 for all body text; ≥ 3:1 for large text and UI components
- Core flows (solve log, swap listing creation, marketplace browsing) operable without visual reliance on colour alone
- Screen reader compatibility for primary user flows (solve log, dashboard, marketplace)

### Integration

- Barcode catalog lookup: ≥ 80% match rate at launch; fallback to manual search is always available and surfaced immediately on miss
- MSP CSV import: processes files up to 10,000 rows without timeout; handles malformed CSVs gracefully with per-row error reporting rather than full-import failure
- Stripe subscription integration: payment failures surface actionable messaging to users within the same request cycle; webhook processing handles retry logic for delayed confirmations
- Image storage (swap listings, solve photos): client-side compression to ≤ 1MB before upload; CDN delivery with lazy loading in all list/feed views
- External sharing (FR43): Web Share API with graceful fallback to clipboard copy on unsupported browsers
