# Feature 4.1: Quota Banner

Item: `rollout/4-quota/0-card.md` · Stage: **merged**

## What & why

A dismissible banner at the top of the notifications feed showing the user's current quota usage (e.g., "3 of 10 daily notifications"). Guides users toward their quota limits without blocking their inbox. Separate from feature 4.2 (quota settings) because the banner appears on the main feed, not in settings.

## Links

- PR: https://github.com/example/notifications/pull/1001
- Item tracking issue: https://github.com/example/notifications/issues/989
- Doc chapter: not yet written
- Key files: `src/components/QuotaBanner.tsx`, `src/hooks/useQuota.ts`, `tests/unit/quota-banner.test.ts`

## Test strategy

Planned 2026-09-10, updated at close 2026-09-15.

| Layer | Planned | Actually ran |
|---|---|---|
| L1 unit (one test per exit point) | Hook returns quota state · Banner renders when quota < limit · Banner hidden when quota >= limit · Dismiss action persists preference · Badge shows correct count | `tests/unit/quota-banner.test.ts`: 5 unit tests, all green in CI run #412 |
| L2 integration (seams) | DB query for user quota · API call for quota state · localStorage persistence for dismiss preference | Integration test on branch DB: `tests/integration/quota-banner.db.test.ts`, 3 seams exercised, all pass |
| L3 real-surface (adapter bound in `02-adapters.md`) | Drive app as user → Open notifications feed → Verify banner appears with correct quota state → Dismiss banner → Reload and verify persistence | `assets/4.1-quota-banner-1440.png`, `assets/4.1-quota-dismiss-1440.png`, network requests clean, console errors empty |
| L4 cross-feature (item level) | Quota banner + settings + enforcement working together | Not yet run (feature 4.2 and 4.3 not merged) |
| L5 human-only | `verification/4.1-quota-banner.md` rows | `verification/4.1-quota-banner.md`, 4 rows for human verification |

Sensitive surfaces: none

## Evidence log

| date | layer | evidence | by |
|---|---|---|---|
| 2026-09-10 | L1 | `tests/unit/quota-banner.test.ts`, 5 exit points, all green in CI run #412 | tdd · heavy |
| 2026-09-12 | L2 | `tests/integration/quota-banner.db.test.ts`, 3 seams (DB query, API call, localStorage), branch DB pass | integration · heavy |
| 2026-09-15 | L3 | `assets/4.1-quota-banner-1440.png`, `assets/4.1-quota-dismiss-1440.png`, `errors --json` empty, network requests clean | browser-verification · light |
| 2026-09-16 | L5 | `verification/4.1-quota-banner.md`, 4 rows (quota accuracy, dismiss persistence, accessibility, quota boundary display) | human-assisted-verification · judge |

## Confidence: agent 85 · ceiling 92 (2026-09-16)

**Justification (agent):** Unit coverage is complete (5/5 exit points tested). Integration seams are exercised (DB, API, localStorage). L3 surface drive captured quota state rendering and dismiss persistence. No review findings. Agent score unchanged; rederived with L5 file now in place. Gap to ceiling rests on: human verification of quota accuracy edge cases (quota calculation at boundaries) and accessibility compliance.

**Justification (ceiling):** Same dimensions as agent score, but with L5 human verification rows now written (4 rows in `verification/4.1-quota-banner.md`) and assumed PASS. Ceiling is bounded by the gap between visual/UX edge cases the human can verify versus system-level quota concurrency testing that exceeds L5 scope. Rederived 2026-09-16 with L5 evidence recorded.

## What would raise this

- Human verification of quota edge cases (off-by-one, timezone boundaries) — needs L5 rows
- Integration test covering concurrent quota increments — agent-actionable but deferred to item 4.3
