# Item 4 — In-app quota indicator

Batch: `00-plan.md` · Stage: **in-progress**

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

- [x] A header banner appears once usage crosses 80% of the period quota
- [ ] A dedicated settings screen shows usage, reset date, and per-channel breakdown
- [ ] An upgrade path is reachable from both the banner and the settings screen (feature 4.3)

## Sensitive surfaces

none

## Feature index

| # | Feature | Stage | agent | ceiling |
|---|---|---|---|---|
| 4.1 | [quota-banner](1-quota-banner.md) | merged | 82 | 90 |
| 4.2 | [quota-settings](2-quota-settings.md) | reviewed | 58 | 84 |
| 4.3 | quota-upgrade-modal | pending | – | – |

Feature stages: `pending` → `in-progress` (TDD) → `reviewed` → `agent-verified` → `documented` → `merged`.

## Working file

Live at `working/4-quota.agent.md`.
