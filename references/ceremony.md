# Git & GitHub Ceremony

Reference for `rolling-wave-planning`. **Load this when an item opens, not every session.**
Applies when the ceremony level recorded in `00-plan.md`'s decisions table is ON or lighter.
With ceremony OFF, none of the branch/PR/issue machinery here applies.

## Branch naming

Dots, not slashes: git forbids a ref `x1` and a ref directory `x1/feat2` from coexisting, so
`<N>-<batch>/1` and `<N>-<batch>/1/2-slug` cannot both exist.

```
<N>-<batch>                 batch branch, cut from dev. The ONLY branch the developer merges.
<N>-<batch>.<i>             item branch, cut from the batch branch.
<N>-<batch>.<i>.<f>-<slug>  feature branch, cut from the item branch.
```

`<N>-<batch>` is the SSOT directory name verbatim. `<i>` and `<f>` are the item and feature
numbers from the directory. `<slug>` is the feature file's slug.

**Worked example — batch `10-terminal-alerting`, item 1 (the Capacitor shell), which was one
coherent behavior and so opened as a single feature:**

```
dev
└── 10-terminal-alerting                        batch branch
    └── 10-terminal-alerting.1                  item 1 — Capacitor shell
        └── 10-terminal-alerting.1.1-capacitor-shell        feature PR → item branch
    └── 10-terminal-alerting.2                  item 2 — cut from the batch branch
                                                AFTER item 1's PR merged
```

An item that does split shows two or more feature branches under it —
`….2.1-<slug>`, `….2.2-<slug>` — each with its own PR into the item branch. (Corrected
2026-09-10: this example read "item 1 (PWA shell)" split into manifest/service-worker features;
batch 10 changed from PWA to Capacitor on Sep 3rd, 2026 and item 1 shipped as one feature.)

**Sequential items stack naturally:** `.2` is cut from the batch branch only after `.1` has
merged into it, so it inherits item 1's work and nothing has to be rebased.

## PR ladder

| PR | Base | Opened when | Carries | Merged by |
|---|---|---|---|---|
| Feature | item branch | at the `reviewed` gate: tests green and review point 1 resolved on the branch (a draft PR is fine) | rich description (what / why / how tested), the `agent` and `ceiling` confidence scores, and review point 2 (`references/review.md`): fresh-context diff review plus the security pass when flagged | **agent, automatically**, once review findings are resolved |
| Item | batch branch | all the item's feature PRs merged into the item branch and the L4 cross-feature pass recorded | review point 3: integration review plus the rogue-check | **agent, automatically**, once findings are resolved |
| Batch | `dev` | all items `complete` | review point 4: final whole-batch review plus the rogue-check, full test-suite evidence, handoff summary | **the developer — nobody else merges this one** |

Merge method for feature→item and item→batch is a **merge commit, not a squash**: squashing a
base branch in a stack rewrites history the child branches depend on. The developer chooses the
method for the batch PR.

Reviews post on the PR as review comments, never in chat: see `references/review.md` § Reviews post
on the PR for the mechanics and the why. The PR is the durable record, which is why "PR" is the
drill-down link in the feature file.

## Issues and the GitHub navigation tree

The developer reviews everything in the GitHub web UI. Every artifact must be reachable by
drill-down from a single entry point, without opening the repo:

    batch tracking issue → item tracking issues → feature PRs → diffs + review threads

- **One batch tracking issue**, opened at kickoff: a task-list of the item issues (GitHub renders
  cross-referenced task-list entries with live open/closed state). Closed when the developer
  merges the batch PR. This is the developer's home page for the effort.
- **One tracking issue per ITEM. Never per feature** — a per-feature issue would duplicate the
  feature PR. The item issue holds the feature checklist with PR links, updated as each feature
  merges, and is closed at `complete`.
- **Title convention:** item issues `[<N>.<i>] <item title>`, feature PRs `[<N>.<i>.<f>] <feature
  title>`, batch issue and batch PR `[<N>] <batch title>`.
- **One label per batch** (`batch:<N>-<slug>`) on every issue and PR of the effort, so a single
  filter shows everything.
- **PR descriptions are self-sufficient:** what & why, test-strategy summary, and both confidence
  scores live in the description, so review needs no repo file open.

## Platform linking (GitHub)

**Three views, three jobs.** Sub-issues on the batch issue = *where are we*; the merged-PR list
filtered by the batch label, sorted oldest-first (and `git log --first-parent <batch-branch>`) =
*what ran, in order*; the repo ledger (`00-plan.md` STATE) = *how to resume*. Issue and PR
**numbers are identity, not order** — they are never expected to be sequential. The `[<N>.<i>]`
slot label lives in the *title* and is retitled when slots shift (see "Renumbering and pausing"
below).

**Every item issue is a sub-issue of the batch issue**, added in slot order at open time:

```bash
gh api graphql -f query='{repository(owner:"<o>",name:"<r>"){issue(number:<n>){id}}}'   # node ids
gh api graphql -f query='mutation{addSubIssue(input:{issueId:"<batchId>",subIssueId:"<itemId>"}){issue{number}}}'
# mid-flight insert that must sit in the MIDDLE, not at the end:
gh api graphql -f query='mutation{reprioritizeSubIssue(input:{issueId:"<batchId>",subIssueId:"<itemId>",afterId:"<prevItemId>"}){issue{number}}}'
```

`addSubIssue` always appends; `reprioritizeSubIssue` takes `afterId` or `beforeId`.

**Every PR body's first line is `Part of #<item issue>`** — feature PRs and item PRs both point at
the item issue, the batch PR at the batch issue. **"Part of", never "Closes"**: item issues close
at `complete`, not at merge. A PR already merged without the line is retrofitted with a comment
`Part of #<n>` — that lands on the issue timeline just the same.

**Every issue and PR carries the `batch:<slug>` label** — that label is what makes the sorted PR
list work. Record both review URLs in `00-plan.md` at kickoff:

    https://github.com/<o>/<r>/pulls?q=is:pr+label:batch:<slug>+sort:created-asc
    https://github.com/<o>/<r>/issues/<batch issue number>

**Why (2026-09-10):** batch 10 was found with no platform linking — batch issue #42 had no
sub-issues, and none of the four merged PRs (#43, #44, #46, #47) referenced item issue #39 or #45.
The only glue was the `batch:<slug>` label, and the developer could not follow the chronology
from GitHub.

## Renumbering and pausing

Both rules live in `references/resume.md` ("Item numbers are execution slots", "Pausing a batch");
their git/GitHub consequences:

- **Item issue titles are retitled when items shift** — `[<N>.<i>]` always carries the item's
  current slot, because the issue tree is how the developer navigates.
- **Merged PR titles and branch names are never edited retroactively** — they are history, and an
  item carrying either is never renumbered at all. A renumbered item records the bridge in its
  card: `renumbered <date> from <old n>; PRs #x/#y carry the old number`. Without that line the two
  numbers cannot be reconciled later, so it is not optional.
- **On pause**, the batch PR into `dev` is an interim merge — title it
  `[<N>] <batch title> — interim merge (paused)`. The **batch tracking issue stays open** with a
  pause comment; item issues keep their own stages. Merged item and feature branches are deleted;
  the batch branch may be deleted and re-cut from `dev` on resume.

## Ceremony levels

Chosen in the final round of the kickoff interview (the `pre-rolling-wave-planning` skill, Phase 4)
and recorded in the decisions table.

| Level | When | Shape |
|---|---|---|
| **ON** (default) | feature efforts | the full ladder above |
| **lighter** (default for bug batches) | bug batches | one branch and one PR for the whole batch; one tracking issue for the batch; a per-bug test strategy only when the bug is non-trivial |
| **OFF** | only if the developer asks | no branch/PR/issue machinery; feature `merged` reverts to "implemented, tests green, committed", and review points 1 to 4 record into `working/<item>.agent.md` instead of a PR |

## Security pass and rogue-check

Both moved to `references/review.md` (points 2 and 3/4) at v2.0.0; the security pass posts on the
feature PR, the rogue-check on the item PR and once more on the batch PR.

## Red flags

- A GitHub issue opened per feature — issues are per item, PRs are per feature.
- A squash-merge of a feature or item PR — it rewrites history the child branches depend on.
- The agent merging the batch PR — that one is the developer's.
- A merged PR title or a branch renamed to match a renumbering — those are history, not records to keep current.
- A PR opened without `Part of #<item issue>` on line one, or an item issue that is not a sub-issue of its batch.
- An item issue closed at `documented` — it closes at `complete`, when the human rows are ticked.
