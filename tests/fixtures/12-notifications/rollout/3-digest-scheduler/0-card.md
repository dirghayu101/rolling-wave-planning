# Item 3 — Digest email scheduler

Batch: `00-plan.md` · Stage: **complete**

## Problem

The daily digest cron sometimes double-sends because the job has no idempotency key, so an
overlapping run (a slow query holding the previous invocation open) resends the same digest.

## Files involved

- `supabase/functions/send-digest/index.ts`: cron entrypoint
- `supabase/migrations/0045_digest_run_log.sql`: idempotency key table

## Evidence

- 2026-09-07: confirmed missing idempotency key (intake premise 1, settled)

## Acceptance criteria

- [x] A digest run for a given user and period sends at most once
- [x] An overlapping invocation exits early instead of resending

## Sensitive surfaces

none

## Feature index

| # | Feature | Stage | agent | ceiling |
|---|---|---|---|---|
| 3.1 | idempotent-digest-run | merged | 86 | 90 |

## Outcome

- Idempotency key is `(user_id, period)`, unique-constrained; overlapping run hits a conflict and exits clean.
