# Item 2: Notification preferences schema

Batch: `../../00-plan.md` · Stage: **merged**

## Problem

There is no per-channel opt-in; users get every notification type or none, set by a single
boolean.

## Files involved

- `supabase/migrations/0043_notification_prefs.sql`: per-channel columns and RLS

## Evidence

- 2026-09-07: confirmed via schema query that `users.notifications_enabled` was the only flag

## Acceptance criteria

`Acceptance rows served:` none (supporting work)

- [x] Each channel (push, email, in-app) has its own opt-in column
- [x] RLS restricts a user's prefs row to that user

## Test strategy

- **L4 flow:** set each channel independently, then read the row back as another user and as the owner · no group
- **Environment:** `supabase start`, seeded from `supabase/seed.sql`, reset with `supabase db reset`
- **Non-functional:** none stated
- **How it was tested:** L1 on the column defaults, L2 on the policy through a real token, L4 on the local stack; evidence entries in this item's feature logs.

## Sensitive surfaces

RLS

## Human verification

No human-verifiable surface: a schema plus a policy, with no rendered state. Substitute: the
policy test that reads the row as a second user and asserts the read is denied.

## Feature index

| # | Feature | Stage | Flow | Confidence |
|---|---|---|---|---|
| 2.1 | per-channel-columns-and-rls | merged | not drawn, merged before the v3 migration | agent 88 / ceiling 92 |

## Outcome

- Migration shipped with a policy test proving cross-user reads are denied.
