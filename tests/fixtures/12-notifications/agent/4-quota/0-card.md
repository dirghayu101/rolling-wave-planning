# Item 4: In-app quota indicator

Batch: `../../00-plan.md` · Stage: **open**

## Problem

Users hit their notification send quota with no warning; the first sign is a support ticket after
sends silently stop. The quota exists in the backend already (`notification_quota`), it is just
never surfaced.

## Files involved

- `notification_quota` table (existing, read-only for this item)
- `apps/dashboard/components/QuotaBanner.tsx`: new header banner
- `apps/dashboard/routes/settings/notifications/quota.tsx`: new settings screen
- `planning/03-blueprint/quota-settings.html`: approved wireframe for the settings screen

## Evidence

- 2026-09-07: query confirmed quota is tracked per-user in `notification_quota`, updated on every send (intake premise 2, settled)
- Support tag `quota-surprise`: 21 tickets in the last 30 days

## Acceptance criteria

`Acceptance rows served:` 3

- [x] A header banner appears once usage crosses 80% of the period quota
- [ ] A dedicated settings screen shows usage, reset date, and per-channel breakdown
- [ ] An upgrade path is reachable from both the banner and the settings screen (feature 4.3)

## Test strategy

- **L4 flow:** load the dashboard at 85% seeded usage, follow the banner's Manage link to the settings screen, confirm both read the same period totals · group `quota-mute-settings`, recorded on item 5
- **Environment:** `supabase start`, seeded from `supabase/seed.sql`, reset with `supabase db reset`
- **Non-functional:** none stated
- **How it was tested:** filled at `built`

## Sensitive surfaces

none

## Standing rules for this item's packets

- The quota row is read-only for this item: no packet writes `notification_quota`.
- Every screen feature carries the wireframe path in scope and is compared against it at L3.

## Feature index

| # | Feature | Stage | Flow | Confidence |
|---|---|---|---|---|
| 4.1 | [quota-banner](1-quota-banner.md) | merged | [`flows/4.1-quota-banner.md`](../../flows/4.1-quota-banner.md) | agent 82 / ceiling 90 |
| 4.2 | [quota-settings](2-quota-settings.md) | reviewed | [`flows/4.2-quota-settings.md`](../../flows/4.2-quota-settings.md) | agent 74 / ceiling 88 |
| 4.3 | quota-upgrade-modal | open | not yet drawn | agent - / ceiling - |

Feature 4.3's own `open` gate has not been taken: it has no HEAD file, no log file and no before
flow yet. The wireframe already covers its modal state inline in
`planning/03-blueprint/quota-settings.html`, so it needs no separate wireframe.

## Outcome

Appended when the item reaches `merged`.
