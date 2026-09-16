# Item 9 — Notification analytics dashboard

Batch: `00-plan.md` · Stage: **pending**

## Problem

Nobody on the team can see aggregate send/open rates per channel; every "is this working" question
is answered by an ad-hoc query.

## Files involved

- new admin analytics screen (not yet blueprinted)
- read model over `notification_history` (item 6) and send logs

## Evidence

- Recurring ad-hoc query requests in the team channel, no durable log kept

## Acceptance criteria

- [ ] An admin can see send and open rate per channel, per week
- [ ] The dashboard reads from a durable table, not a log tail

## Sensitive surfaces

none

## Feature index

Decomposed when the item opens.
