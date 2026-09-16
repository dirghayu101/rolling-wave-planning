# Item 5 — Mute-per-channel settings

Batch: `00-plan.md` · Stage: **pending**

## Problem

Users can opt out of a channel entirely (item 2) but cannot mute it temporarily (e.g. "mute push
for 24h"), which is the most common support ask after opt-in shipped.

## Files involved

- `supabase/migrations/` (new mute-window table, not yet written)
- notification settings screen (extends item 4's screen)

## Evidence

- Support tag `mute-request` count: 9 tickets in the last 30 days

## Acceptance criteria

- [ ] A user can mute a channel for a chosen duration
- [ ] A muted channel sends nothing until the window expires, then resumes without re-opt-in

## Sensitive surfaces

none

## Feature index

Decomposed when the item opens.
