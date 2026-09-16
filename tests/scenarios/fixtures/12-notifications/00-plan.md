# 12: Notifications

A batch for testing rolling-wave-planning and human-assisted-verification.

## STATE

```
phase: executing
layout: v2
What: Notifications system features and settings
Stage: item 4 in-progress, feature 4.1 merged, feature 4.2 reviewed, feature 4.3 pending
Next: Write verification for feature 4.1 and move it to documented
```

## Decisions

| # | Decision | Choice + why | Date |
|---|---|---|---|
| 1 | Test database for integration tests | Use branch DB (faster feedback than production) | 2026-09-01 |

## Adapters

Roles, tiers and tool bindings for this batch: `02-adapters.md`.

## Status ledger

| # | Item | Stage | Note |
|---|---|---|---|
| 1 | [Push Tokens](rollout/1-push-tokens/0-card.md) | complete | Early implementation, fully verified |
| 2 | [Notif Prefs](rollout/2-notif-prefs/0-card.md) | complete | User preferences system, fully verified |
| 3 | [Digest Scheduler](rollout/3-digest-scheduler/0-card.md) | complete | Daily digest scheduling, fully verified |
| 4 | [Quota System](rollout/4-quota/0-card.md) | in-progress | Feature 4.1 merged, 4.2 in review, 4.3 pending |
| 5 | [Mute Channels](rollout/5-mute-channels/0-card.md) | pending | Will start after item 4 |

## Review URLs

- Batch tracking issue: https://github.com/example/notifications/issues/999
- Batch branch: `notifications/quota-system`
- Batch PR: not yet opened
