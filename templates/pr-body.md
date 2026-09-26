# PR description: template

Template for `rolling-wave-planning`. Used at all three levels of the ladder: feature, item, batch.

**The PR body is not a record.** It is a note to the reviewer, written once, read once. The sections
are fixed so every PR reads the same, even when a section is not yet filled; an unfilled section
carries its own fixed line saying where and when it fills in. Do not copy evidence tables into it
beyond the one test-strategy snapshot below, the body is still never edited to stay in sync with a
file, and **never treat a disagreement between it and a file as a finding**.

## Template: copy verbatim, replacing bracketed text

```markdown
Part of #<item issue>

## What and why
<Two to four sentences: the behavior delivered in a user's or operator's terms, then the one design
call worth knowing and where the risk sits. Link the feature file `agent/<n>-<item>/<f>-<slug>.md`.>

## What to look at
<The two or three files a reviewer opens first and why, and any finding routed out of scope.>

## Test strategy
<One sentence on environment. Then a three-column table copied from the feature file at PR time:
Layer | What ran | Result, one row per layer L1 to L5. Say plainly what is not proven. Point at the
log file for the evidence rows: `agent/<n>-<item>/<f>-<slug>.log.md`.>

Snapshot at `<SHA>`; the feature file is the live copy.

## Confidence
<The feature file's line if set. If not: "Set at the merge gate from the review and the
verification file; until then the feature file reads `agent – / ceiling –`.">

## Review
Findings live on this PR as review comments; the feature's log file carries one row per pass with
the SHA and the counts.

## Flow

```mermaid
<the AFTER diagram, copied from flows/<n>.<f>-<slug>.md>
```

Before and after, with permalinks: `flows/<n>.<f>-<slug>.md`
```

## Per level

| Level | What and why names | Flow section carries |
|---|---|---|
| Feature | the one behavior this feature delivers | its own after diagram |
| Item | what the item's features do together, and the L4 flow that proved it | the after diagram of the feature that carries the item's main path, or a link to each |
| Batch | what the batch delivers, and the hand-back the developer is receiving | a link to `flows/`, not an embedded diagram |

The batch PR's Test strategy section also names the full-suite command and its result on the batch branch, and points at `00-plan.md` § Hand-back.

## Red flags

- A confidence re-derivation or a copied log entry in a PR body; the test-strategy table is a dated
  snapshot, not a live copy.
- A PR body edited to stay current with a file.
- A review finding about the PR body.
- A feature PR with no after diagram.
- Line one missing `Part of #<item issue>`.
- A section heading missing or renamed.
