# Git and GitHub ceremony

Reference for `rolling-wave-planning`. **Load this when an item opens, not every session.** With ceremony OFF, none of the branch, PR or issue machinery here applies.

## Branch naming

Dots, not slashes: git forbids a ref `x1` and a ref directory `x1/feat2` from coexisting.

```
<N>-<batch>                 batch branch, cut from the trunk. The ONLY branch the developer merges.
<N>-<batch>.<i>             item branch, cut from the batch branch.
<N>-<batch>.<i>.<f>-<slug>  feature branch, cut from the item branch.
```

`<N>-<batch>` is the SSOT directory name verbatim. `<i>` and `<f>` are the item and feature numbers. `<slug>` is the feature file's slug.

**Sequential items stack naturally:** `.2` is cut from the batch branch only after `.1` merged into it, so it inherits item 1's work and nothing has to be rebased.

**Overlapping features get worktrees, not shared branches** (`references/dispatch.md` § Concurrency). One branch, one implementer.

## When the trunk moves ahead

The stack is feature to item to batch to trunk, so a history rewrite on a base breaks every open child under it.

- **Merge the trunk into the batch branch only between items**, when no item branch is open.
- **Never rebase the batch branch while an item or feature branch depends on it.** Rebase for linear history only right before the batch PR, once every item branch has merged.
- **A child that needs something from the trunk mid-item takes it by merging the batch branch**, after the batch branch has itself taken the trunk. Never merge the trunk directly into a child.

## PR ladder

| PR | Base | Opened when | Carries | Merged by |
|---|---|---|---|---|
| Feature | item branch | at the `built` gate: tests green, full suite green, L3 evidence recorded, after flow written | description from `templates/pr-body.md`, the `flows/` file, the `verification/` file, any `runbooks/` file, and one review (`references/review.md`) | **agent**, once findings are resolved |
| Item | batch branch | every feature PR merged and the L4 pass recorded | description from `templates/pr-body.md` and the integrity check (`templates/integrity-check.md`) | **agent**, once the check is clean |
| Batch | trunk | every item `merged` | description from `templates/pr-body.md`, full-suite evidence, the hand-back list | **the developer. Nobody else merges this one** |

Merge method for feature to item and item to batch is a **merge commit, not a squash**: squashing a base branch in a stack rewrites history the child branches depend on. Read the result with `git log --first-parent`, which shows one merge per feature.

Reviews post on the PR as review comments, never in chat.

## What rides which PR

| Artifact | Rides |
|---|---|
| code and tests | the feature PR, committed as they land |
| `flows/<n>.<f>-<slug>.md` | the feature PR |
| `verification/<n>.<f>-<slug>.md` | the feature PR |
| `runbooks/<k>-<slug>.md` | the feature PR of the feature that needs it |
| `agent/**` | one commit at the feature `merged` gate, one at the item PR. Never between gates |
| `00-plan.md` | the same gate commits |

A commit whose whole diff is a record edit, made between gates, is the pattern this table exists to stop.

## Issues and the navigation tree

Every artifact must be reachable by drill-down from one entry point:

    batch tracking issue → item tracking issues → feature PRs → diffs + review threads

- **One batch tracking issue**, opened at kickoff: a task-list of the item issues. Closed when the developer merges the batch PR.
- **One tracking issue per ITEM. Never per feature**: a per-feature issue duplicates the feature PR. The item issue holds the feature checklist with PR links.
- **Title convention:** item issues `[<N>.<i>] <item title>`, feature PRs `[<N>.<i>.<f>] <feature title>`, batch issue and batch PR `[<N>] <batch title>`.
- **One label per batch** (`batch:<N>-<slug>`) on every issue and PR.
- **Every PR body's first line is `Part of #<item issue>`**, and the batch PR points at the batch issue. "Part of", never "Closes": item issues close when the `verification/` rows are ticked, not at merge.

Sub-issue wiring:

```bash
gh api graphql -f query='{repository(owner:"<o>",name:"<r>"){issue(number:<n>){id}}}'
gh api graphql -f query='mutation{addSubIssue(input:{issueId:"<batchId>",subIssueId:"<itemId>"}){issue{number}}}'
# an insert that must sit in the MIDDLE:
gh api graphql -f query='mutation{reprioritizeSubIssue(input:{issueId:"<batchId>",subIssueId:"<itemId>",afterId:"<prevItemId>"}){issue{number}}}'
```

`addSubIssue` always appends; `reprioritizeSubIssue` takes `afterId` or `beforeId`.

Record both review URLs in `00-plan.md` at kickoff:

    https://github.com/<o>/<r>/pulls?q=is:pr+label:batch:<slug>+sort:created-asc
    https://github.com/<o>/<r>/issues/<batch issue number>

## Renumbering and pausing

- **Item issue titles are retitled when items shift**: `[<N>.<i>]` always carries the item's current slot.
- **Merged PR titles and branch names are never edited retroactively**: they are history, and an item carrying either is never renumbered. A renumbered item records the bridge in its card.
- **On pause**, the batch PR into the trunk is an interim merge, titled `[<N>] <batch title>, interim merge (paused)`. The batch tracking issue stays open with a pause comment.

## Ceremony levels

Chosen in the final round of the kickoff interview and recorded in the decisions table.

| Level | When | Shape |
|---|---|---|
| **ON** (default) | feature efforts | the full ladder above |
| **lighter** (default for bug batches) | bug batches | one branch and one PR for the whole batch, one tracking issue, a test strategy only when the bug is non-trivial |
| **OFF** | only if the developer asks | no branch, PR or issue machinery; feature `merged` means implemented, tests green, committed; the review records into the feature's `.log.md` |

## Red flags

- A GitHub issue opened per feature.
- A squash-merge of a feature or item PR.
- The agent merging the batch PR.
- A merged PR title or branch renamed to match a renumbering.
- A PR opened without `Part of #<item issue>` on line one.
- A commit between gates whose whole diff is under `agent/`.
- An item issue closed at `merged`: it closes when the `verification/` rows are ticked.
- A `runbooks/` file still on disk after the push it describes.
