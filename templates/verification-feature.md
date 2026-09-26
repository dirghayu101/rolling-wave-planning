# Human verification file: template

Template for `rolling-wave-planning`. Lives at `verification/<n>.<f>-<slug>.md` per feature, or `verification/group-<slug>.md` for a check spanning two or more features or items. Written by the `human-assisted-verification` skill at the feature's `reviewed → merged` gate, and it rides that PR.

**This file is run later, cold, with nobody to ask.** Write it so that still works.

**This is stage one of two: verify on dev, then deploy through the runbooks.** This file runs on dev, from the batch branch served locally against the dev database, before any merge, and it needs no production access. A step that would need a production console, a production credential, a `*:prod` command or a migration push does not belong in this file: it is a runbook step, and it goes in `runbooks/<k>-<slug>.md`, where its post-check is the production-side verification of the same flow.

**Zero agent steps.** Every row is a human action or a human-only observation, run by hand from the row itself: each row carries the exact query, command or console path, pasted ready to use. Inside a row, address the reader as "you" and never by a role.

## Template: copy verbatim, replacing bracketed text

```markdown
# Verification <n>.<f>: <Feature title>

Feature: `agent/<n>-<item>/<f>-<slug>.md` · Flow: `flows/<n>.<f>-<slug>.md` · PR: <url>
Confidence: agent <N> / ceiling <M>

**This pass runs on dev.** Nothing here touches production; the production side of this change is
stage two, in `runbooks/`. If a step looks like it needs a production console, a production
credential or a `*:prod` command, stop: that step belongs in a runbook, not here.

**Verdict cells are yours.** The agent wrote `open` in every one and nothing else. Replace `open`
with PASS, FAIL or NEEDS-HUMAN plus the date. The ceiling above is reached only when these rows
are ticked.

Where to run it: run the app locally from the batch branch against dev; the batch's adapters name
the start command (`agent/adapters.md` § Environment). There is no deployed preview yet: that would
need a merge to dev, which happens after this pass.
Database console: the **dev** project's SQL editor.
Setup you need first: <account / role / device / build, or "none">.

## Walkthrough

Read these nodes of the flow file, in this order, before you touch the app.

1. `<node>`: <why it matters, one line>
2. `<node>`: <...>
3. `<node>`: <...>

Details are in the code comments at those nodes and in the diff. This section is the on-ramp,
not a summary.

## Replay: sanity only, does not move the score

Three or four checks already proven at L1 to L4, rewritten as your steps. If one fails, the build
or the environment in front of you is not the one that was tested; stop and say so before going on.

| # | Do this | Expect |
|---|---|---|
| R1 | <exact steps> | <exact observation> |
| R2 | <...> | <...> |

## Judgement rows

Only what a tool cannot do or see.

Excluded because L1 to L4 already prove them: <each candidate check left out and the evidence
entry that covers it, or "none">.

| # | Steps | Human-only observation | Check it yourself | 24h | Verdict + date |
|---|---|---|---|---|---|
| 1 | <Numbered, unambiguous app actions on the dev surface. "1. Open the app → Profile → Contact Support. 2. Type `test-123`. 3. Tap Submit." Name the exact screen, the exact label, the exact text.> | <What no tool can see: "a success toast appears and the field clears".> | <The exact thing you run against **dev**, ready to paste: `select id, message, created_at from support_tickets where message = 'test-123' order by created_at desc limit 1;` in the dev SQL editor, a dev CLI command, or a path in the dev admin UI.> | <no \| yes> | open |
| 2 | … | … | … | … | … |

**24h column:** `yes` when the check reads a log rather than durable state. Log retention is about
a day, so run those rows first.

A check that cannot be run as written (the row never appears, the log line does not exist) is
`NEEDS-HUMAN`, not FAIL. Say so, and the pivot to an alternative observable is recorded here.
```

## Schema-only variant

A feature whose only human-observable effect is the production post-check gets a runbook plus a
verification file with **the replay section only**: the post-check SQL, run on the **dev** console as
a replay against the dev schema. Below the replay table, one line, verbatim apart from the numbers:

```markdown
No judgement rows: nothing here is observable on dev beyond the replay; production evidence is
runbook <k> step <n>.
```

Do not invent judgement rows to fill the table, and do not copy the production post-check in as a
row. The production run of that check belongs to the runbook, in stage two.

## Cross-feature group variant

`verification/group-<slug>.md`, same three parts. Two differences:

- The header names **every** feature and item the group spans, and links every flow file, in the order to read them. A backend feature and the frontend feature that consumes it are verified here, together, because verifying either alone proves nothing.
- Its PASS promotes every item it spans, so the resume sweep needs the list in the header to be exact.

Write the group file when the **last** of its features reaches `merged`, never earlier.

## Hand-back

Every file written from this template gets one line in `00-plan.md` § Hand-back at the item's `merged` gate: the path, what it covers, and whether it holds a time-sensitive row. The orchestrator writes a `verification_window:` line into `00-plan.md` STATE when the pass is handed over, and deletes it when the ticks are in. While that line is there, no agent runs `db:apply`, reseeds dev or rehearses a schema change on dev.
