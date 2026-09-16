# Item 7 — Admin broadcast tool

Batch: `00-plan.md` · Stage: **pending**

## Problem

There is no way to send a one-off announcement to all users (e.g. planned downtime); it is
currently done by hand-editing rows in the digest table, which has caused two accidental
duplicate sends.

## Files involved

- new admin-only broadcast function
- admin dashboard (new screen, not yet blueprinted)

## Evidence

- Incident notes, 2026-08-22 and 2026-08-30: manual row edits caused duplicate sends

## Acceptance criteria

- [ ] An admin can compose and send a one-off broadcast to all opted-in users on a channel
- [ ] The tool cannot double-send the same broadcast

## Sensitive surfaces

auth

## Feature index

Decomposed when the item opens.
