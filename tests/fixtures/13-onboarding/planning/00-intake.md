# Intake — New-user onboarding flow

Written at `phase: intake`, before any exploration.

## Rant (verbatim)

"New users sign up and land straight in an empty dashboard with no idea what to do first. We lose
a chunk of them right there. I want some kind of guided setup — get their workspace named, maybe
invite their team, connect something, see one real result — before we just dump them on the empty
state. Not sure how many steps, not sure if it should be skippable, not sure if we build this as a
modal or a real page. Web only for now, the mobile apps don't have signup."

## Goals

- A new signup is walked through workspace setup before reaching the empty dashboard.
- Drop-off during onboarding is measurable (so later batches can improve it).
- Non-goal: redesigning the empty-dashboard state itself.
- Non-goal: onboarding on mobile (web has no mobile signup surface).

## Constraints

- Web only; no iOS/Android surface for signup exists.
- Must not block a user who reopens the signup confirmation email later and lands back on the
  flow mid-way.
- No new third-party analytics tool; drop-off must be measurable from existing product telemetry.

## Unknowns and premises to verify

| # | Premise or unknown | How it gets settled | Status |
|---|---|---|---|
| 1 | Signup currently redirects straight to `/dashboard` with no intermediate screen | Read the signup route handler | settled: confirmed, 2026-09-13 |
| 2 | Existing telemetry can attribute an event to an onboarding step | Read the telemetry client's event schema | settled: confirmed, step-scoped events already supported, 2026-09-13 |
| 3 | Whether progress should persist server-side or in the browser | Interview round 3 | open |
| 4 | Whether "connect a data source" step needs its own new integration or can reuse an existing one | Interview round 3 | open |

## Surfaces touched (web / iOS / Android / backend)

| Surface | In this effort? | Notes |
|---|---|---|
| web | yes | the onboarding flow itself, 4 steps |
| iOS | no | no signup surface |
| Android | no | no signup surface |
| backend | yes | progress persistence, step-scoped telemetry events |

## Origin

- Requested in: planning session, 2026-09-13
- Deferred stub: none
- Originating batch: none
