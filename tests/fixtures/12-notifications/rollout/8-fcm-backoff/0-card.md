# Item 8 — FCM rate-limit backoff

Batch: `00-plan.md` · Stage: **pending**

## Problem

Bursts of sends (e.g. a broadcast, item 7) can hit FCM's rate limit; the current client has no
backoff, so the excess sends are silently dropped rather than retried.

## Files involved

- `functions/send-push/index.ts`: FCM client call site

## Evidence

- FCM 429 responses observed in logs during the 2026-08-30 incident (time-sensitive, already expired)

## Acceptance criteria

- [ ] A 429 from FCM triggers exponential backoff and retry, not a dropped send
- [ ] A send that exhausts retries is recorded, not silently lost

## Sensitive surfaces

none

## Feature index

Decomposed when the item opens.
