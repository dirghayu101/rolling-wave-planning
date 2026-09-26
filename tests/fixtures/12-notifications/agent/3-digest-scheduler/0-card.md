# Item 3: Digest email scheduler

Batch: `../../00-plan.md` · Stage: **merged**

## Problem

The daily digest cron sometimes double-sends because the job has no idempotency key, so an
overlapping run (a slow query holding the previous invocation open) resends the same digest.

## Files involved

- `supabase/functions/send-digest/index.ts`: cron entrypoint
- `supabase/migrations/0045_digest_run_log.sql`: idempotency key table

## Evidence

- 2026-09-07: confirmed missing idempotency key (intake premise 1, settled)

## Acceptance criteria

`Acceptance rows served:` 2

- [x] A digest run for a given user and period sends at most once
- [x] An overlapping invocation exits early instead of resending

## Test strategy

- **L4 flow:** trigger two overlapping cron invocations for one period and count the sends · no group
- **Environment:** `supabase start`, seeded from `supabase/seed.sql`, reset with `supabase db reset`
- **Non-functional:** the 500-user criterion in `00-plan.md` is measured at batch close, not here
- **How it was tested:** L1 on the conflict branch, L2 on the run-log insert, L4 on two overlapping invocations against the local stack; evidence entries in this item's feature logs.

## Sensitive surfaces

none

## Human verification

`../../verification/3.1-idempotent-digest-run.md`: the email itself is fire and forget, so only a
human can say one arrived and the second run sent nothing. Listed in `00-plan.md` § Hand-back.

## Feature index

| # | Feature | Stage | Flow | Confidence |
|---|---|---|---|---|
| 3.1 | idempotent-digest-run | merged | not drawn, merged before the v3 migration | agent 86 / ceiling 94 |

## Outcome

- Idempotency key is `(user_id, period)`, unique-constrained; an overlapping run hits the conflict and exits clean.
