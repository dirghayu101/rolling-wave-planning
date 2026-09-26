# Item 1: Push token registration

Batch: `../../00-plan.md` · Stage: **merged**

## Problem

Push tokens rotate on the client but the backend never invalidates the stale one, so FCM sends
pile up 404s against dead tokens.

## Files involved

- `supabase/migrations/0041_push_tokens.sql`: token table and rotation trigger
- `functions/register-push-token/index.ts`: registration endpoint

## Evidence

- 2026-09-07: query showed about 12% of stored tokens 404 on send

## Acceptance criteria

`Acceptance rows served:` 1

- [x] A rotated token replaces, never duplicates, the row for that device
- [x] A 404 on send marks the token invalid within one cron pass

## Test strategy

- **L4 flow:** register a token, rotate it, force a 404 on send, confirm one live row remains · no group
- **Environment:** `supabase start`, seeded from `supabase/seed.sql`, reset with `supabase db reset`
- **Non-functional:** none stated
- **How it was tested:** L1 and L2 on the rotation trigger and the endpoint; L4 ran the rotate-then-404 flow on the local stack; evidence entries in this item's feature logs.

## Sensitive surfaces

none

## Human verification

No human-verifiable surface: the whole item is a backend lifecycle with no rendered state and no
perception-only effect. Substitute: the L4 fault-injection pass forces a 404 from FCM and asserts
the row is marked invalid within one cron pass.

## Feature index

| # | Feature | Stage | Flow | Confidence |
|---|---|---|---|---|
| 1.1 | register-and-rotate | merged | not drawn, merged before the v3 migration | agent 84 / ceiling 90 |
| 1.2 | invalidate-on-404 | merged | not drawn, merged before the v3 migration | agent 80 / ceiling 88 |

## Outcome

- Token rotation is idempotent; invalidation runs in the existing send-result cron pass.
- No new infra needed; cost was two migrations and one function edit.
