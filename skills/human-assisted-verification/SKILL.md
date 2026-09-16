---
name: human-assisted-verification
description: "Use when a verification step can only be performed or perceived by a human: a surface with no automation adapter bound (typically a mobile screen), a fire-and-forget effect (push, email, webhook) with no durable trace, or an end-to-end judgement no tool can make. Don't use when a test, a browser flow, or a read-only query already proves the behavior."
---

# Human-Assisted Verification

## Overview

The agent and the human perceive a system differently. The human uses the app: taps, sees, feels
something is wrong. The agent reads logs, DB rows, and network traffic. A bug the human can see may
be invisible to the agent's tools, and vice-versa.

This skill writes **only the human half**. Everything the agent can observe is layers L1 to L4 of
the verification ladder (`references/verification.md` in the `rolling-wave-planning` repo) and is
finished **before** handover: unit tests, seams, the bound browser or mobile adapter, cross-feature
runs. What is left is what a human alone can do or see, and the checklist you write here has **zero
agent steps**. The human is the instrument and also the reader: each row carries the exact query,
command or console path, so they run it themselves without an agent in the loop.

A row an agent could have checked does not belong here. It is an unclimbed rung of the ladder and a
rogue-check finding.

## When to Use

- A surface with no automation adapter bound in the batch's `02-adapters.md` (typically mobile
  screens), or a surface recorded as **uncovered** in the kickoff decisions.
- Fire-and-forget effects with no persisted trace an agent can read (push, email, webhooks).
- A judgement no tool makes: does the animation feel right, is the copy wrong, did the toast appear.
- **Don't** use when an automated test, a browser flow, or a single read-only query already proves
  it. Climb that rung instead.

## The Process

### Write the rows

Copy `templates/verification-feature.md` (paths are relative to the `rolling-wave-planning` repo
root) into `verification/<n>.<f>-<slug>.md`, and index it with one row in `01-verification.md`.
Cross-feature human checks get `verification/group-<slug>.md`. Each row has:

| Column | What | Who |
|---|---|---|
| **Human steps** | Detailed, numbered, unambiguous app actions. e.g. "1. Open app → Profile → Contact Support. 2. Type 'test-123'. 3. Tap Submit." Assume the human is deliberately slow, leaving no gaps. | Human |
| **Human-only observation** | What no tool can see. e.g. "a success toast appears and the field clears." | Human |
| **Check it yourself** | The exact thing the human runs, pasted ready to use: the SQL for the database console (`select id, message, created_at from support_tickets where message = 'test-123' order by created_at desc limit 1;`), the CLI command, or the click path in the admin UI. Written out in full: a row that says "check the tickets table" is unfinished. | Human |

Record a verdict per row: **PASS / FAIL / NEEDS-HUMAN**, with the date. Reference the relevant test
cases too.

### Durable-observable-first

1. Point the human at **durable state** (a persisted row, a status field) wherever the behavior
   produces one: it doesn't expire, so the row survives a paused batch.
2. **Logs are primary only for fire-and-forget calls** with no persisted trace (e.g. confirming the
   push send succeeded). Flag those rows **time-sensitive (24h)** in the `24h` column: log retention
   is about a day. Order them first in the file and say so in the handover.
3. Note dev-time DB resets: a row the human would look for may be wiped, so verify before the next
   reset.

### Born stable, elaborated per item, executed incrementally

1. The checklist exists from the start of the effort, initially holding only the **stable** record
   in `01-verification.md`: which tables or state must change per item.
2. When a feature's L1 to L3 evidence is in (its `reviewed → agent-verified` gate), flesh out its
   per-feature file with concrete human steps and the exact checks, while context is fresh. The file
   is handed to the human at `documented`.
3. The human verifies in **groups as items complete** (verify 4 done of 20), never blocked waiting
   for the whole batch.

### Fallback on failed assertion

If a check cannot be run as written, often because a planning-phase premise was wrong (the log line
you expected doesn't exist, the table you expected doesn't change):

1. Do **not** fail silently or assume the change is broken. The row is `NEEDS-HUMAN`, not FAIL.
2. Propose an **alternative observable** (a different row, a different log, a temporary audit
   record) and rewrite the row with its exact query.
3. Record the pivot in the SSOT (the verification file and `00-plan.md` STATE) so the decision
   survives a session exit.

### Promotion to `complete`

Ticks are the only thing that moves an item from `documented` (the agent's terminal stage) to
`complete`. The human ticks whenever they get to it, with no session running; the next resume's
integrity sweep reads the `verification/` files, promotes any item whose rows are all PASS, and
changes the ledger row in the **same commit** as the tick it is acting on. A FAIL becomes a
mid-flight input and is triaged into the ledger.

**No interrupt handshake.** v1 had the human interrupt the agent so it could run its machine
assertions inside the 24h log window. There are no agent steps left to interrupt, so the handshake
is gone; the 24h concern is carried by the `24h` flag on the affected rows and by the resume sweep.

## Delegation

- Evidence-before-claims discipline → `verification-before-completion`.
- If a failed verification reveals a genuine new bug → `systematic-debugging`.
