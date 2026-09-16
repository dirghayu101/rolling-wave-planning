# Item 1 — Push token registration

Batch: `00-plan.md` · Stage: **complete**

## Problem

Push tokens rotate on the client but the backend never invalidates the stale one, so FCM sends
pile up 404s against dead tokens.

## Files involved

- `supabase/migrations/0041_push_tokens.sql`: token table + rotation trigger
- `functions/register-push-token/index.ts`: registration endpoint

## Evidence

- 2026-09-07: query showed ~12% of stored tokens 404 on send

## Acceptance criteria

- [x] A rotated token replaces, never duplicates, the row for that device
- [x] A 404 on send marks the token invalid within one cron pass

## Sensitive surfaces

none

## Feature index

| # | Feature | Stage | agent | ceiling |
|---|---|---|---|---|
| 1.1 | register-and-rotate | merged | 84 | 90 |
| 1.2 | invalidate-on-404 | merged | 80 | 88 |

## Outcome

- Token rotation is idempotent; invalidation runs in the existing send-result cron pass.
- No new infra needed; cost was two migrations and one function edit.
