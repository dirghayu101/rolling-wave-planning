# Intake — Notifications platform hardening

Written at `phase: intake`, before any exploration.

## Rant (verbatim)

"Push notifications are flaky — tokens go stale and we never notice, the digest email job
sometimes double-sends, and support keeps getting tickets from users who blew past some invisible
send quota with no warning. I want the whole notifications path hardened, and I want users to
actually see when they're near their quota instead of just failing silently."

## Goals

- Push tokens stay valid: rotation and invalidation are handled, not silently dropped.
- The daily digest never double-sends.
- Users see their notification quota before they hit it, in the product, not just in a support ticket.
- Non-goal: redesigning the notification content or templates.

## Constraints

- FCM is the existing push provider (Decision 1); no provider migration in this batch.
- Quota state lives in Postgres already (`notification_quota` table) — reuse it, do not shadow it.
- Web-only for the quota UI; native app screens are out of scope for this batch.

## Unknowns and premises to verify

| # | Premise or unknown | How it gets settled | Status |
|---|---|---|---|
| 1 | Digest double-sends because the cron job isn't idempotent, not because of duplicate schedules | Read `supabase/migrations/` and the cron function | settled: confirmed missing idempotency key, 2026-09-07 |
| 2 | Quota is tracked per-user, not per-workspace | Query `notification_quota` schema | settled: per-user, 2026-09-07 |

## Surfaces touched (web / iOS / Android / backend)

| Surface | In this effort? | Notes |
|---|---|---|
| web | yes | quota banner + settings screen |
| iOS | no | |
| Android | no | |
| backend | yes | push token lifecycle, digest cron, quota tracking |

## Origin

- Requested in: planning session, 2026-09-06
- Deferred stub: none
- Originating batch: none
