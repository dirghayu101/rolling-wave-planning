# Item 5: Mute-per-channel settings

Batch: `../../00-plan.md` · Stage: **open** (not started; the item `open` gate has not been taken)

## Problem

Users can opt out of a channel entirely (item 2) but cannot mute it temporarily, for example
"mute push for 24h", which is the most common support ask since opt-in shipped.

## Files involved

- `supabase/migrations/` (new mute-window table, not yet written)
- the notification settings screen item 4 builds

## Evidence

- Support tag `mute-request`: 9 tickets in the last 30 days

## Acceptance criteria

`Acceptance rows served:` none stated yet

- [ ] A user can mute a channel for a chosen duration
- [ ] A muted channel sends nothing until the window expires, then resumes without re-opt-in

## Sensitive surfaces

none

## Feature index

Decomposed when the item opens.
