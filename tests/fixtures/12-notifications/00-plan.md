# 12: Notifications platform hardening

Fixture SSOT for the rolling-wave-planning release-gate tests. Built from `templates/00-plan.md`.

## STATE

```
phase: executing
layout: v2
What: Ship push/email notification reliability and a user-facing quota indicator for the notifications platform.
Stage: item 4 of 9 in-progress, feature 4.1 merged, feature 4.2 reviewed, feature 4.3 pending
Next: drive feature 4.2 (quota-settings) through L3 with agent-browser and record the evidence, then take it to agent-verified
```

## Decisions

| # | Decision | Choice + why | Date |
|---|---|---|---|
| 1 | Push provider | FCM chosen over OneSignal; the mobile apps already ship Firebase | 2026-09-08 |
| 2 | Quota surfacing | Persistent header banner + a dedicated settings screen, chosen over a toast-only warning, so the limit is discoverable outside the moment of failure | 2026-09-09 |
| 3 | Docs writer | `subagent` (heavy tier); no docs-writer CLI on PATH for this project | 2026-09-09 |
| 4 | Ceremony level | ON (issues + PRs), matching the project default | 2026-09-09 |

## Adapters

Roles, tiers and tool bindings for this batch: `02-adapters.md`.

## Testing plan

### Cross-item groups

| Group | Flow | Items in | Recorded on | Status |
|---|---|---|---|---|
| `quota-mute-settings` | Mute a channel from the notification settings screen item 4 builds, then confirm both the quota banner and the mute survive a reload and a session restart | 4, 5 | 5 | pending |

### End-to-end flows

| Flow | Drives it | Gate |
|---|---|---|
| Notification round trip: change a preference, trigger a send, see the notification arrive, see it counted against the quota and listed in history | `browser-verification` | batch `done` |

### Environment

- Bring-up: `supabase start` (local stack, needs Docker running)
- Seed data: `supabase/seed.sql` (three users, one at 90% of quota, one fully muted)
- Reset: `supabase db reset`

### Load and performance

| Criterion | Tool | Gate | Status |
|---|---|---|---|
| The digest scheduler handles 500 users in under 60 s | `k6` | item 3 `agent-verified` | pending |

## Status ledger

| # | Item | Stage | Note |
|---|---|---|---|
| 1 | [Push token registration](rollout/1-push-tokens/0-card.md) | complete | FCM tokens persisted and refreshed on rotation |
| 2 | [Notification preferences schema](rollout/2-notif-prefs/0-card.md) | complete | per-channel opt-in columns, RLS in place |
| 3 | [Digest email scheduler](rollout/3-digest-scheduler/0-card.md) | complete | daily digest via pg_cron |
| 4 | [In-app quota indicator](rollout/4-quota/0-card.md) | in-progress | 4.1 merged, 4.2 in review, 4.3 pending |
| 5 | [Mute-per-channel settings](rollout/5-mute-channels/0-card.md) | pending | |
| 6 | [Notification history log](rollout/6-notif-history/0-card.md) | pending | |
| 7 | [Admin broadcast tool](rollout/7-admin-broadcast/0-card.md) | pending | |
| 8 | [FCM rate-limit backoff](rollout/8-fcm-backoff/0-card.md) | pending | |
| 9 | [Notification analytics dashboard](rollout/9-notif-analytics/0-card.md) | pending | |

## Review URLs

- Batch tracking issue: https://example.invalid/notifications/issues/12
- Batch branch: `batch/12-notifications`
- Batch PR: not yet opened
- Item PRs: recorded on each item's card, not here.

## Deferred

- none
