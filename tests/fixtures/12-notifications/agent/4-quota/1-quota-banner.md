# Feature 4.1: Quota banner

Item: `0-card.md` · Stage: **merged**
Flow: `../../flows/4.1-quota-banner.md` · Log: `1-quota-banner.log.md`

## What and why

Persistent header banner that appears once a user's send usage crosses 80% of their period quota,
so the warning lands before the quota is exhausted rather than after. Separate from the settings
screen (4.2) because the banner is a passive, always-on surface rendered from the header layout,
while the settings screen is a navigated-to detail view with its own loading and error states.

## Links

- PR: https://example.invalid/notifications/pull/214 (merged)
- Item tracking issue: https://example.invalid/notifications/issues/12
- Key files: `apps/dashboard/components/QuotaBanner.tsx`, `apps/dashboard/lib/useQuota.ts`
- Verification: `../../verification/4.1-quota-banner.md`
- Runbook: none

## Test strategy

| Layer | Planned | Actually ran |
|---|---|---|
| L1 unit (one test per exit point) | render nothing under 80%, render warning at 80 to 99%, render critical at 100% and above | `apps/dashboard/lib/useQuota.test.ts`, 3 exit points, green |
| L2 integration (seams) | `useQuota` against the real `notification_quota` read endpoint | `apps/dashboard/lib/useQuota.integration.test.ts`, hits the local stack |
| L3 real surface | load the dashboard at 79%, 80% and 100% seeded usage; screenshots at 1440, 768 and 375; banner box height and header offset read at each width | driven 2026-09-11, see the log's L3 entry |
| L4 cross-feature | banner and settings screen read the same period totals | runs at the item's `built` gate, with 4.2 merged |
| L5 human-only | the banner's reappearance on the next quota tick, which no bound tool can wait out | `../../verification/4.1-quota-banner.md`, open until the row is ticked |

Sensitive surfaces: none

Confidence: agent 82 / ceiling 90

## What would raise this

- A developer tick on the reappearance row: no bound tool can hold a session open across a quota period boundary.
