---
name: human-assisted-verification
description: "Use when a verification step can only be performed or perceived by a human: a surface with no automation adapter bound (typically a mobile screen), a fire-and-forget effect (push, email, webhook) with no durable trace, or an end-to-end judgement no tool can make. Don't use when a test, a browser flow, or a read-only query already proves the behavior."
---

# Human-Assisted Verification

## Overview

The agent and the human perceive a system differently. The human uses the app: taps, sees, feels
something is wrong. The agent reads tests, logs, DB rows and network traffic.

This skill writes **only the human half**. Everything the agent can observe is L1 to L4 of the ladder
(`references/verification.md`) and is finished before handover. Paths like that one resolve against
the `rolling-wave-planning` skill directory.

**This skill writes the dev pass, and the dev pass needs no production access.** Every file it
writes runs on dev: the dev schema copy of production, the app served locally from the batch branch,
and the dev database console. Rows are run by hand, never by an agent; inside a row, address the
person following it as "you" and never by a role.

**The file is run later.** Often after the batch branch is already delivered, and often for a group
of features at once rather than one at a time. Write it so it still works cold, with no session
running and nobody to ask.

## Two stages: verify on dev, then deploy through the runbooks

One flow, two stages. This skill writes stage one, the dev pass: on dev, from the batch branch
served locally against the dev database, before any merge. Stage two is `runbooks/`, the production
stage, run by hand and never by an agent after the dev pass and the merge, and a runbook's post-check
is the production-side verification of the same flow.

A row that could only be run against production is therefore **not a verification row**. It is a
runbook step. Route it to `runbooks/<k>-<slug>.md` and say so in the feature file. This covers:

- Anything reading or writing a production console or a production database.
- Anything needing a production credential, key or secret.
- Any `*:prod` command, any migration push, any deploy.
- **The read-only production post-check that proves a migration landed.** That is stage two, in the
  runbook, and it cannot run before the deploy. Never copy it in here as a row.

A schema change still gets a verification file when its effect is observable on dev: run the same
post-check SQL against the **dev** console as a replay row. When even that is all there is, write the
replay-only file and its `No judgement rows` line (`templates/verification-feature.md` § Schema-only
variant) rather than inventing judgement rows.

## When to Use

- A surface with no automation adapter bound in `agent/adapters.md`, or a surface recorded as
  **uncovered** in the kickoff decisions.
- Fire-and-forget effects with no persisted trace an agent can read.
- A judgement no tool makes: does the animation feel right, is the copy wrong, did the toast appear.
- **Don't** use when an automated test, a browser flow or a single read-only query already proves it.
- **Don't** use for anything production-facing. That is stage two, `templates/runbook.md`.

## The file has three parts, in this order

Copy `templates/verification-feature.md` into `verification/<n>.<f>-<slug>.md`, or
`verification/group-<slug>.md` for a check that spans two or more features or items.

The header carries where to run it: the app served locally from the batch branch against the dev
database, with the start command the batch's `agent/adapters.md` names, plus the dev SQL console.
There is no deployed preview to point at, because a preview would need the merge to dev that comes
after this pass.

### 1. Walkthrough order

Two to five lines naming **which nodes of `flows/<n>.<f>-<slug>.md` to read, in which order**, to
understand what changed before the app is touched. Name the nodes; the flow file carries the
permalinks. This is the reviewer's on-ramp, not a summary of the code.

Details belong in code comments and in the diff. Do not restate the implementation here.

### 2. Replay

Three or four checks the agent already proved at L1 to L4, rewritten as exact steps on dev with the
exact expected observation. Mark the section **Replay: sanity only, does not move the score.**

Its job is to confirm in two minutes that the build in front of the reader is the build that was
tested. A replay that fails means the build or the environment is wrong, which is worth knowing
before the judgement rows begin.

Replays never carry a verdict that feeds the confidence number. The score is set by L1 to L4 evidence
and by the judgement rows.

### 3. Judgement rows

Only what a human alone can do or see, on dev. Each row:

| Column | What |
|---|---|
| **Steps** | Numbered, unambiguous actions on dev, addressed to "you". Name the exact screen, the exact label, the exact text to type. Assume the reader is deliberately slow and leave no gaps. |
| **Human-only observation** | What no tool can see. "A success toast appears and the field clears." |
| **Check it yourself** | The exact thing to run against **dev**, pasted ready to use: SQL for the dev SQL editor, a dev CLI command, or a path in the dev admin UI. Nothing else may appear in this column. A row that says "check the tickets table" is unfinished. |
| **24h** | `yes` when the check reads a log rather than durable state. Run those first. |
| **Verdict** | `open`, until it is replaced by hand with PASS, FAIL or NEEDS-HUMAN plus the date. |

**A row an agent could have checked does not belong here.** It is an unclimbed rung and a review
finding.

**A row that needs production does not belong here either.** It is a runbook step.

**Verdict cells are filled by hand.** The agent writes `open` in every one and never anything else: not as a
placeholder, not as an expectation, not because the L1 to L4 evidence makes the outcome obvious.

The header carries the confidence line unchanged from the feature file, on one line:
`Confidence: agent N / ceiling M`. No re-derivation, no explanation of why the number is what it is.
**The ceiling is reached only when these rows are ticked.**

## Durable observable first

1. Point at **durable state** wherever the behavior produces one: it does not expire, so the row
   survives a pass run weeks later. Example: `select id, status, updated_at from orders where
   id = '<the order just created on dev>';` in the dev SQL editor.
2. **Logs are primary only for fire-and-forget calls** with no persisted trace. Flag those rows
   `24h: yes` and order them first. Example: the dev project's function logs for the push send, read
   in the dev console.
3. Note dev-time database resets: a row the file points at may be wiped by a rebuild. That is also
   why no agent rebuilds dev while the pass is open.

## The verification window

While this pass is running, dev is frozen for agents: no `db:apply`, no reseed, no schema rehearsal.
The orchestrator writes one `verification_window:` line into `00-plan.md` STATE at handover and
deletes it when the ticks are in. Say so in § Hand-back when the file is handed over.

## Written once, per feature, at the feature PR

The file is written at the `reviewed → merged` gate, once its L1 to L3 evidence is in, and it rides
that PR. It is not revised afterwards unless a check turns out to be unrunnable.

A **group file** is written when the **last** of its features reaches `merged`. A backend feature and
the frontend feature that consumes it are verified together, in one file, because verifying either
alone proves nothing anyone cares about. Its header names every feature and item it spans, and its
PASS promotes all of them.

## Fallback on a failed assertion

If a check cannot be run as written, often because a premise was wrong (the log line does not exist,
the table does not change, the dev surface does not expose it):

1. Do **not** fail silently and do not assume the change is broken. The row is `NEEDS-HUMAN`, not
   FAIL.
2. Propose an **alternative observable on dev** and rewrite the row with its exact query. If the only
   observable left is production, the row leaves this file and becomes a runbook step in stage two.
3. Record the pivot in the file and in `00-plan.md` STATE.

## Hand-back

Every file written here gets a line in `00-plan.md` § Hand-back the moment its item reaches `merged`:
the file path, what it covers, and whether any row is time-sensitive. That list is what
is read when the agent stops. Production steps get their own § Hand-back lines pointing at
`runbooks/`, in the order `runbooks/0-release.md` gives them.

## Promotion

Ticks on these rows are the only thing that moves an item from `merged` to `verified`. They land whenever there is time for them; the next resume's integrity sweep reads the files, promotes any item whose rows all read
PASS, and changes the ledger row in the **same commit** as the tick it is acting on. A FAIL becomes a
mid-flight input. A production post-check in a runbook never promotes anything and never moves the
confidence score.

## Delegation

- Evidence-before-claims discipline: `verification-before-completion`.
- A failed verification that reveals a genuine new bug: `systematic-debugging`.
