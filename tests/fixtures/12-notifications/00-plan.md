# 12: Notifications platform hardening

Fixture SSOT for the rolling-wave-planning release-gate tests. Built from `templates/00-plan.md`.

## STATE

```
phase: executing
layout: v3 (migrated from v2 on 2026-09-10; items 1 to 3 merged before the migration and have no flows/ files)
What: Ship push and email notification reliability plus a user-facing quota indicator.
Stage: item 4 of 9 open; feature 4.1 merged, feature 4.2 reviewed, feature 4.3 not opened yet
acceptance: 2 of 4 rows met
Next: write verification/4.2-quota-settings.md with human-assisted-verification, then merge PR 221 into the item branch
```

## Decisions

| # | Decision | Choice + why | Date |
|---|---|---|---|
| 1 | Push provider | FCM over OneSignal; the mobile apps already ship Firebase | 2026-09-08 |
| 2 | Quota surfacing | Persistent header banner plus a dedicated settings screen, over a toast-only warning, so the limit is discoverable outside the moment of failure | 2026-09-09 |
| 3 | Ceremony level | ON (issues and PRs), matching the project default | 2026-09-09 |
| 4 | L2 to L4 environment | Local Supabase stack over the hosted dev project; the digest cron has to be triggered by hand, which the hosted project forbids | 2026-09-09 |

## Adapters

Roles, tiers and tool bindings: `agent/adapters.md`.

## Acceptance

The developer's requirements in their words: `planning/00-acceptance.md`.

## Testing plan

### Cross-item groups

| Group | Flow | Items in | Recorded on | Status |
|---|---|---|---|---|
| `quota-mute-settings` | Mute a channel from the settings screen item 4 builds, then confirm the quota banner and the mute both survive a reload and a session restart | 4, 5 | 5 | pending |

### End-to-end flows

| Flow | Drives it | Gate |
|---|---|---|
| Change a preference, trigger a send, see it arrive, see it counted against the quota and listed in history | `browser-verification` | batch close |

### Environment

- Bring-up: `supabase start` (local stack, needs Docker running)
- Seed data: `supabase/seed.sql` (three users, one at 90% of quota, one fully muted)
- Reset: `supabase db reset`

### Load and performance

| Criterion | Tool | Gate | Status |
|---|---|---|---|
| The digest scheduler handles 500 users in under 60 s | `k6` | batch close | pending |

## Status ledger

| # | Item | Stage | Note |
|---|---|---|---|
| 1 | [Push token registration](agent/1-push-tokens/0-card.md) | merged | FCM tokens persisted and refreshed on rotation |
| 2 | [Notification preferences schema](agent/2-notif-prefs/0-card.md) | merged | per-channel opt-in columns, RLS in place |
| 3 | [Digest email scheduler](agent/3-digest-scheduler/0-card.md) | merged | daily digest via pg_cron; L5 pass still owed |
| 4 | [In-app quota indicator](agent/4-quota/0-card.md) | open | 4.1 merged, 4.2 reviewed, 4.3 not opened |
| 5 | [Mute-per-channel settings](agent/5-mute-channels/0-card.md) | open | not started; opens after item 4 |
| 6 | [Notification history log](agent/6-notif-history/0-card.md) | open | not started |
| 7 | [Admin broadcast tool](agent/7-admin-broadcast/0-card.md) | open | not started |
| 8 | [FCM rate-limit backoff](agent/8-fcm-backoff/0-card.md) | open | not started |
| 9 | [Notification analytics dashboard](agent/9-notif-analytics/0-card.md) | open | not started |

## Hand-back

| # | What | File | Note |
|---|---|---|---|
| 1 | run the dev pass for the digest scheduler | `verification/3.1-idempotent-digest-run.md` | row 2 reads a cron log, so run it first |

Items 1 and 2 have no human-verifiable surface; the substitute for each is recorded in its card.

## Review URLs

- Batch tracking issue: https://example.invalid/notifications/issues/12
- Batch branch: `12-notifications`
- Batch PR: not yet opened

## Deferred

- none
