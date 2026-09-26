# Feature 4.2: Quota settings screen

Item: `0-card.md` · Stage: **reviewed**
Flow: `../../flows/4.2-quota-settings.md` · Log: `2-quota-settings.log.md`

## What and why

A dedicated settings screen showing period usage, the reset date and a per-channel breakdown,
reachable from the banner (4.1) and from Settings then Notifications directly. Separate from the
banner because it is a navigated screen with its own loading, error and empty states, and it owns
the per-channel query the banner never makes.

Built from the approved wireframe at `../../planning/03-blueprint/quota-settings.html`.

## Links

- PR: https://example.invalid/notifications/pull/221 (ready, review clean)
- Item tracking issue: https://example.invalid/notifications/issues/12
- Key files: `apps/dashboard/routes/settings/notifications/quota.tsx`, `apps/dashboard/lib/useQuotaBreakdown.ts`
- Verification: not yet written
- Runbook: none

## Test strategy

| Layer | Planned | Actually ran |
|---|---|---|
| L1 unit (one test per exit point) | loading, error, empty and success renders; reset-date formatting; channel-row sort order | `apps/dashboard/routes/settings/notifications/quota.test.tsx`, 5 exit points, green |
| L2 integration (seams) | `useQuotaBreakdown` against the real per-channel usage query | `apps/dashboard/lib/useQuotaBreakdown.integration.test.ts`, hits the local stack |
| L3 real surface | drive the screen at 79%, 80% and 100% seeded usage; screenshots at 1440, 768 and 375; channel table width and focus after the Manage link; wireframe comparison | driven 2026-09-13, see the log's L3 entry |
| L4 cross-feature | screen reachable from the banner's Manage link, both reading the same period totals | runs at the item's `built` gate |
| L5 human-only | not yet written | open, until the row is ticked |

Sensitive surfaces: none

Confidence: agent 74 / ceiling 88

## What would raise this

- A developer tick on the per-channel numbers: only a human can say the breakdown matches what they believe they sent.
