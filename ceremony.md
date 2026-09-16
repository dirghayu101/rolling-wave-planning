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
| Feature | item branch | feature implemented, tests green | rich description (what / why / how tested), confidence score, agent code review | **agent, automatically**, once review findings are resolved |
| Item | batch branch | all the item's features merged | item integration review + rogue-check | **agent, automatically**, once findings are resolved |
| Batch | `dev` | all items `verified` | final whole-batch review, full test-suite evidence, handoff summary | **the developer — nobody else merges this one** |

Merge method for feature→item and item→batch is a **merge commit, not a squash**: squashing a
base branch in a stack rewrites history the child branches depend on. The developer chooses the
method for the batch PR.

**Reviews post as GitHub PR review comments, not chat messages.** Use the GitHub MCP review flow
(`pull_request_review_write` create → `add_comment_to_pending_review` → submit) or the `gh api`
equivalents. The PR is the durable review record — the diff, the discussion, and the commit list
persist forever, which is why "PR" is the drill-down link in the feature file.

## Issues and the GitHub navigation tree

The developer reviews everything in the GitHub web UI. Every artifact must be reachable by
drill-down from a single entry point, without opening the repo:

    batch tracking issue → item tracking issues → feature PRs → diffs + review threads

- **One batch tracking issue**, opened at kickoff: a task-list of the item issues (GitHub renders
  cross-referenced task-list entries with live open/closed state). Closed when the developer
  merges the batch PR. This is the developer's home page for the effort.
- **One tracking issue per ITEM. Never per feature** — a per-feature issue would duplicate the
  feature PR. The item issue holds the feature checklist with PR links, updated as each feature
  merges, and is closed at `verified`.
- **Title convention:** item issues `[<N>.<i>] <item title>`, feature PRs `[<N>.<i>.<f>] <feature
  title>`, batch issue and batch PR `[<N>] <batch title>`.
- **One label per batch** (`batch:<N>-<slug>`) on every issue and PR of the effort, so a single
  filter shows everything.
- **PR descriptions are self-sufficient:** what & why, test-strategy summary, and confidence score
  live in the description, so review needs no repo file open.

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
at `verified`, not at merge. A PR already merged without the line is retrofitted with a comment
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

Both rules live in `rolling-wave-planning` ("Item numbers are execution slots", "Pausing a batch");
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

Decided at kickoff (`pre-rolling-wave-planning` Phase 4) and recorded in the decisions table.

| Level | When | Shape |
|---|---|---|
| **ON** (default) | feature efforts | the full ladder above |
| **lighter** (default for bug batches) | bug batches | one branch and one PR for the whole batch; one tracking issue for the batch; a per-bug test strategy only when the bug is non-trivial |
| **OFF** | only if the developer asks | no branch/PR/issue machinery; `code-done` reverts to "implemented, tests green, committed" |

## Security pass

An **additional** security-focused review (RLS, auth, payments, secrets handling) runs only on
features whose `Sensitive surfaces:` line is not `none`. Flag those surfaces in the item card at
planning time so the feature inherits the flag. The security review posts on the feature PR and
must be resolved before auto-merge.

## Rogue-check

An audit by a **fresh-context reviewer who did not execute the work.** Runs at **every item PR**,
and **once more at the batch PR**. No other cadence — moment-to-moment agent work is deliberately
unconstrained; this replaces step-level policing.

**(a) Direction.** Are the `00-plan.md` decisions honored? Any silent scope creep? Are the ledger
stages truthful (the classic drift: a row reading `verified` above an unchecked
`01-verification.md`, or `code-done` before the PR actually merged)? Do the confidence scores
survive a spot-check re-derivation from the diff — re-derive one or two? Is `working/` clean?

**(b) Execution architecture.** Was subagent-driven development actually used — one orchestrator
handing bounded tasks to subagents — or did one agent grind the whole item in a single rotting
context? Evidence: task decomposition in the working file, distinct subagent handoffs, feature
branches with independent commit clusters.

**(c) Model tiering.** Did hard implementation and review run on a heavy model, and mechanical or
minor work on a light one? Evidence: the model recorded on each dispatch in the working file.

**Where findings land.** On the item PR (or the batch PR for the final pass), as review comments,
resolved before that PR auto-merges. Any finding that cannot be resolved inside the item goes into
`00-plan.md` STATE as the next order of business — **never into a code comment**.

## Red flags

- A GitHub issue opened per feature — issues are per item, PRs are per feature.
- A feature or item PR merged with unresolved review findings.
- A squash-merge of a feature or item PR — it rewrites history the child branches depend on.
- A confidence score that does not survive re-derivation from the diff.
- A rogue-check finding parked in a code comment instead of `00-plan.md` STATE.
- The agent merging the batch PR — that one is the developer's.
- A review delivered in chat instead of on the PR.
- A merged PR title or a branch renamed to match a renumbering — those are history, not records to keep current.
- A PR opened without `Part of #<item issue>` on line one, or an item issue that is not a sub-issue of its batch.
