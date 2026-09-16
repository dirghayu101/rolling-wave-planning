# Feature 4.1 — Quota banner

Item: `rollout/4-quota/0-card.md` · Stage: **merged**

## What & why

Persistent header banner that appears once a user's send usage crosses 80% of their period quota,
so the warning lands before the quota is exhausted rather than after. Separate from the settings
screen (4.2) because the banner is a passive, always-on surface with its own render path
(header layout), while the settings screen is a navigated-to detail view.

## Links

- PR: https://example.invalid/notifications/pull/214 (merged)
- Item tracking issue: https://example.invalid/notifications/issues/12
- Doc chapter: `docs/001-quota-banner.md`
- Key files: `apps/dashboard/components/QuotaBanner.tsx`, `apps/dashboard/lib/useQuota.ts`

## Test strategy

Planned 2026-09-10, updated at close 2026-09-12.

| Layer | Planned | Actually ran |
|---|---|---|
| L1 unit | exit points: render nothing under 80%, render warning at 80-99%, render critical at 100%+ | `apps/dashboard/lib/useQuota.test.ts`, 3 exit points, all green |
| L2 integration | `useQuota` hook against the real `notification_quota` read endpoint | `apps/dashboard/lib/useQuota.integration.test.ts`, hits the test-branch DB |
| L3 real-surface (agent-browser) | load dashboard at 79%/80%/100% seeded usage, screenshot at 1440/768/375 | driven 2026-09-11, see evidence log |
| L4 cross-feature | banner visible alongside the settings screen link, once 4.2 merges | pending — recorded at item close-out |
| L5 human-only | none owned by this feature (banner has no fire-and-forget or perception-only check) | n/a |

Sensitive surfaces: none

## Evidence log

| date | layer | evidence | by |
|---|---|---|---|
| 2026-09-10 | L1 | `apps/dashboard/lib/useQuota.test.ts`, 3 exit points, green in CI run #881 | tdd · heavy |
| 2026-09-11 | L2 | `apps/dashboard/lib/useQuota.integration.test.ts`, hit test-branch DB, row read confirmed | tdd · heavy |
| 2026-09-11 | L3 | `assets/4.1-banner-1440.png`, `assets/4.1-banner-768.png`, `assets/4.1-banner-375.png`; `errors --json` empty; `network requests` shows one GET to `/api/quota` returning 200 | browser-verification · light |

## Confidence: agent 82 · ceiling 90 (2026-09-12)

Unit and integration exit points are covered, and the real surface was driven at all three
breakpoints with clean console/network capture. Weakest dimension is unverifiable effects: the
banner's dismiss-and-reappear timing on the next quota tick is not covered by an automated check
and is parked on the settings-screen L4 pass at item close-out.

## What would raise this

- (agent-actionable raises exhausted at merge; nothing left on this list)
