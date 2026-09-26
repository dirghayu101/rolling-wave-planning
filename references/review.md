# Review

Reference for `rolling-wave-planning`. **Load this at the feature PR, not every session.**

One review per feature. It happens once, on the feature PR, and it is the only review in the flow.

Two rules hold:

- **The reviewer did not write the code.** A fresh-context subagent reviews; a different fresh subagent fixes; the reviewer re-reviews in scope. One agent never occupies two of those seats.
- **Roles, not names.** The reviewer role is `review`, the security reviewer is `security-review`, both bound in `agent/adapters.md`. Review runs on the `heavy` tier, never `light`. A reviewer finding the orchestrator is inclined to dismiss may go to the `judge` (`references/dispatch.md` § Escalating to the judge).

## Scope

**Three things, and nothing else:**

1. **The diff.** Correctness, reuse, project conventions.
2. **The tests.** Do the exit points the tests claim to cover match the ones the code has.
3. **The L3 browser evidence.** Does it show the surface actually doing what the feature claims, at the breakpoints it claims.

**Security rides in the same packet** when the card's `Sensitive surfaces:` line is not `none`: auth boundaries, tenant isolation, key handling, policy tests. One reviewer, one packet, one pass. The `security-review` role's skill goes on that packet alongside `review`.

## The record is not reviewable material

**State this in the reviewer packet, in these words:**

> The feature file, the PR body, the flow file and the verification file are context, not subject matter. Do not report findings about them. A stale line number, a count that disagrees with another file, a wording nit in the record: none of these is a finding. Report only what is wrong in the diff, the tests, or the browser evidence.

Findings about the record are what turned 88 findings on one feature into 4 real ones. The reviewer is reading the record to understand the diff, not to grade it.

## Two passes maximum

1. The reviewer posts findings on the PR, each actionable and located: file, line, what is wrong, what would satisfy it.
2. A **fresh** subagent fixes them, carrying `superpowers:receiving-code-review` or whatever the project binds.
3. The reviewer role re-reviews on fresh context, **scoped to the findings and their blast radius**, not the whole diff again.
4. Zero open findings, and the PR merges.

The loop's shape belongs to `subagent-driven-development`. Invoke it; do not restate it here.

**A third pass means the packet was wrong.** Stop, fix the packet (missing scope file, missing acceptance criterion, wrong premise), and say so in the feature's `.log.md`. Do not run the loop a third time hoping it converges.

## Where findings land

On the PR, as review comments, through the platform's review flow. The PR is the durable review record. One appended entry per pass in the feature's `.log.md`, carrying the SHA reviewed and the counts: findings raised, findings fixed, findings skipped with a reason. **That entry is never edited afterwards.**

With ceremony OFF, the findings go in the `.log.md` and nowhere else. Never in chat, never in a code comment.

## Review dimensions

1. **Correctness.** Does it do what the feature file says, including the edge cases in `planning/02-edge-cases.md` for this item.
2. **Reuse and duplication.** Walk the ladder and report the first rung that fails: does it already exist in this repo; is the type generated from its source rather than hand-written beside a generated file; native or standard library before a dependency, and an installed dependency before a new one. A new dependency with no argument in the PR description is a finding.
3. **Project conventions.** The repo's own patterns, naming, file placement, error handling and test conventions win over the reviewer's preferences. Cite the existing file the convention comes from.
4. **Security**, only when the card flags the surface.

## The integrity check is not a review

At the item PR, one short `light`-tier check runs (`templates/integrity-check.md`): stage lines agree with the ledger, verdict cells untouched, ephemera swept. Three questions, a table, no source files opened, no diff read. It exists so nobody ships an item whose ledger lies, and it is the whole of the process policing in this skill.

## Red flags

- A finding about the record: a stale line pin, a count mismatch, a wording preference in a card or a PR body.
- A third review pass on one feature.
- The implementer fixing its own review findings, or the reviewer fixing what it found.
- A re-review that re-reads the whole diff instead of the findings and their blast radius.
- A flagged feature merged with no security section in the reviewer's report.
- A review delivered in chat.
- A `.log.md` review entry edited after the fact to reflect a later commit.
- A hand-written type sitting beside the generated file it duplicates.
