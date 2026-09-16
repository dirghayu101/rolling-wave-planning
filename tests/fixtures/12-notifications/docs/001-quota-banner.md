# 001 — Quota banner

## TL;DR

Shows a persistent header banner once a user's notification send usage crosses 80% of their
period quota, so the warning lands before sends silently stop rather than after.

## What changed and why

`apps/dashboard/lib/useQuota.ts` polls the existing `notification_quota` row on dashboard load and
exposes a `status` of `ok | warning | critical` at the 80% and 100% thresholds.
`apps/dashboard/components/QuotaBanner.tsx` renders nothing at `ok`, an amber banner at `warning`,
and a red banner with an upgrade link at `critical`.

## How it fits together

The banner reads from the same `notification_quota` table every send already writes to (item 2's
schema); there is no new backend endpoint, only a new read hook.

## Verification

- Unit: `apps/dashboard/lib/useQuota.test.ts`
- L3: `assets/4.1-banner-1440.png`, `assets/4.1-banner-768.png`, `assets/4.1-banner-375.png`

## Debugging by hand

Seed a user's `notification_quota.used` to 80% of `notification_quota.limit` and reload the
dashboard; the amber banner should appear immediately, no cache to bust.
