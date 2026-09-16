# Item 6 — Notification history log

Batch: `00-plan.md` · Stage: **pending**

## Problem

Users cannot see what was sent to them; support has to query the database on their behalf for
every "did I get notified" ticket.

## Files involved

- new `notification_history` read model (table or view, not yet decided)
- notification settings screen (extends item 4's screen)

## Evidence

- Support tag `did-i-get-notified`: 14 tickets in the last 30 days

## Acceptance criteria

- [ ] A user can see the last N notifications sent to them, per channel
- [ ] History reflects sends made after this feature ships (backfill out of scope)

## Sensitive surfaces

RLS

## Feature index

Decomposed when the item opens.
