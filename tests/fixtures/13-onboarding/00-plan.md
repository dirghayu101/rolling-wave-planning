# 13 — New-user onboarding flow

Fixture SSOT for the rolling-wave-planning release-gate tests. Built from `templates/00-plan.md`.
This batch has not been scaffolded yet — it is still in the pre-rolling-wave-planning interview.

## STATE

```
phase: interview
layout: v2
What: Design a guided onboarding flow for new signups on the web dashboard, replacing the current drop-into-empty-dashboard experience.
Stage: interview round 2 of an expected ~4 answered; round 3 (progress persistence, data-source scope, SSO entry) not yet asked
Next: open planning/04-interview.md and ask round 3
```

## Decisions

| # | Decision | Choice + why | Date |
|---|---|---|---|
| 1 | Entry point | Post-signup redirect to `/onboarding`, not a modal over the dashboard — a modal was rejected because it blocks the URL from being resumable if the signup email link is reopened later | 2026-09-14 |
| 2 | Step count | 4 fixed steps (workspace name, invite teammates, connect a data source, first action) rather than a dynamic step list — the dynamic option was rejected as unnecessary complexity for a first version | 2026-09-14 |
| 3 | Skip affordance | A "skip for now" link is allowed from step 2 onward, not step 1 — step 1 (workspace name) is required because nothing downstream works without it | 2026-09-15 |

## Adapters

Not yet generated. `02-adapters.md` is written in the interview's final round (`references/adapters.md`), which has not been reached.

## Status ledger

Not yet populated. Items are scaffolded in Phase 5, after the interview closes; scaffolding cards
before that point is a red flag this skill exists to avoid.

## Review URLs

Ceremony level is decided in the interview's final round; no issues or branches exist yet.

## Deferred

- none
