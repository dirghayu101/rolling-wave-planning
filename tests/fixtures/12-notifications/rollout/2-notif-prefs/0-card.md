# Item 2 — Notification preferences schema

Batch: `00-plan.md` · Stage: **complete**

## Problem

There is no per-channel opt-in; users get every notification type or none, set by a single
boolean.

## Files involved

- `supabase/migrations/0043_notification_prefs.sql`: per-channel columns + RLS

## Evidence

- 2026-09-07: confirmed via schema query that `users.notifications_enabled` was the only flag

## Acceptance criteria

- [x] Each channel (push, email, in-app) has its own opt-in column
- [x] RLS restricts a user's prefs row to that user

## Sensitive surfaces

RLS

## Feature index

| # | Feature | Stage | agent | ceiling |
|---|---|---|---|---|
| 2.1 | per-channel-columns-and-rls | merged | 88 | 92 |

## Outcome

- Migration shipped with a policy test proving cross-user reads are denied.
