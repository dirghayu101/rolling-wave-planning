# Feature 4.2 — Quota settings screen

Item: `rollout/4-quota/0-card.md` · Stage: **reviewed**

## What & why

A dedicated settings screen showing usage, the reset date, and a per-channel breakdown, reachable
from the banner (4.1) and from Settings > Notifications directly. Separate from the banner because
it is a navigated screen with its own states (loading/error/empty), not a passive header element.

Wireframe: `planning/03-blueprint/quota-settings.html`

## Links

- PR: https://example.invalid/notifications/pull/221 (draft, opened after review point 1)
- Item tracking issue: https://example.invalid/notifications/issues/12
- Doc chapter: not yet written
- Key files: `apps/dashboard/routes/settings/notifications/quota.tsx`, `apps/dashboard/lib/useQuotaBreakdown.ts`

## Test strategy

Planned 2026-09-11, updated at review 2026-09-13.

| Layer | Planned | Actually ran |
|---|---|---|
| L1 unit | exit points: renders empty/loading/error/success states, formats reset date, sorts channel rows | `apps/dashboard/routes/settings/notifications/quota.test.tsx`, 5 exit points, all green |
| L2 integration | `useQuotaBreakdown` hook against the real per-channel usage query | `apps/dashboard/lib/useQuotaBreakdown.integration.test.ts`, hits the test-branch DB |
| L3 real-surface (agent-browser) | load the screen at 79%/80%/100% seeded usage, screenshot at 1440/768/375, verify against the wireframe | not yet driven |
| L4 cross-feature | screen reachable from the 4.1 banner's "Manage" link | not yet run — gated on this feature reaching `merged` |
| L5 human-only | not yet written | n/a |

Sensitive surfaces: none

## Evidence log

| date | layer | evidence | by |
|---|---|---|---|
| 2026-09-12 | L1 | `apps/dashboard/routes/settings/notifications/quota.test.tsx`, 5 exit points, green in CI run #886 | tdd · heavy |
| 2026-09-13 | L2 | `apps/dashboard/lib/useQuotaBreakdown.integration.test.ts`, hit test-branch DB, per-channel rows confirmed | tdd · heavy |

## Confidence: agent 58 · ceiling 84 (2026-09-13)

Unit and integration exit points are covered and green. Weakest dimension is real-surface
verification: L3 has not been driven yet, so the screen's rendered states and its match against
the wireframe are unproven. That is the agent-actionable raise still open on this feature — it is
not yet exhausted, so it does not belong on "what would raise this" below.

## What would raise this

- (nothing needing human intervention or missing tooling yet; the open raise is agent-actionable L3 work, tracked as the next action in `00-plan.md`, not listed here)
