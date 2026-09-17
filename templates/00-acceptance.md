# Acceptance list: <effort>

Written at `phase: intake`, immediately after `planning/00-intake.md`, straight from the rant. Copy to `planning/00-acceptance.md` and replace the bracketed text.

**This is the developer's own list, not a restatement of the plan.** One row per requirement they stated, in **their words**, quoted or lightly trimmed, never paraphrased into agent vocabulary: a paraphrase is already an interpretation, and the whole point of the list is to check the work against what was actually asked. A rant of twenty sentences usually holds fifteen to twenty rows. Split a sentence that carries two requirements into two rows; keep a requirement you do not yet understand and mark it for the interview.

**It is checked at every gate.** Cards name the rows they serve (`Acceptance rows served:` on `templates/0-card.md`), the item `agent-verified` gate appends evidence to those rows, and the batch `done` gate refuses to close while a row still reads `open`. `00-plan.md` STATE carries the count (`acceptance: <n> of <m> rows met`), so a cold session sees progress without loading this file.

**Verdicts are the developer's.** An agent fills the `Agent check` column with a pointer to evidence and stops there, exactly as it hands over an L5 row at `open`. The four verdict values:

| Verdict | Means | Written by |
|---|---|---|
| `open` | not yet satisfied, or satisfied with no evidence recorded | the starting value of every row |
| `met` | the evidence in the row satisfies the requirement | the developer |
| `struck: <reason>` | withdrawn. **Recorded, never deleted**: a struck row is the record that it was considered | the developer |
| `deferred: <where>` | it left this batch. Name the sibling stub dir or the batch that took it | the agent that triaged it out, or the developer |

## Stated requirements

From the rant in `planning/00-intake.md`. Confirmed in the interview's first round, before any design question.

| # | Requirement (developer's words) | Where it lives | Agent check (evidence) | Human verdict |
|---|---|---|---|---|
| 1 | <their sentence, quoted> | <the file, item or gate that will carry it, filled at scaffold> | <pointer to the evidence: a feature file's evidence row, a test path, a PR, a verification row id> | open |
| 2 | <...> | <...> | | open |

## Implicit rows

Every project gets these, whether or not the rant says them. Keep the numbering continuous with the block above. Strike one only when the developer strikes it, with their reason.

| # | Requirement | Where it lives | Agent check (evidence) | Human verdict |
|---|---|---|---|---|
| <i> | Every surface flagged as sensitive gets a security pass | the card's `Sensitive surfaces:` line, review point 2's security pass (`references/review.md`) | <the security review on each flagged feature's PR> | open |
| <i+1> | Tested as far as L1 to L4 allow, with the batch Testing plan actually run | `references/verification.md` ladder, `00-plan.md` § Testing plan (every group and flow at `ran <date>` or `n/a`) | <the evidence logs, the Testing plan rows> | open |
| <i+2> | Every feature is documented for a human reader | `docs/NNN-<slug>.md` per feature, indexed in `docs/000-index.md` | <the chapters and the index rows> | open |
| <i+3> | No machine-specific binding is written into shared skill files | bindings live in `02-adapters.md` and `<project root>/adapters.default.md` only | <the audit's check for machine-specific bindings and vendor names> | open |
| <i+4> | The developer's standing rules are honoured | their global rules file, plus the project's own agent instructions | <name the rules that bear on this effort, and where each is satisfied> | open |

## Interview round 1 record

Filled when the list is confirmed, before any design question is asked. `planning/04-interview.md` carries the full round; this block carries what it changed.

- Rows added by the developer: <numbers and one line each, or `none`>
- Rows whose reading was wrong: <number: what the agent read, what the developer meant>
- Rows struck: <number: their reason> (struck in the table above, not deleted)
- Confirmed on: <YYYY-MM-DD>

## Changes after confirmation

A requirement arriving mid-effort is a new row here, dated, as well as a mid-flight input triaged per `references/resume.md`. Never rewrite a confirmed row in place: strike it and add its replacement, so the audit trail survives.

| Date | Row | What changed | Why |
|---|---|---|---|
| <YYYY-MM-DD> | <#> | <added \| struck \| deferred \| reworded by the developer> | <their reason> |
