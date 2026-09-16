# Review

Reference for `rolling-wave-planning`. **Load this at a review point, not every session.**
`references/lifecycle.md` names the transition that sends you here.

Two rules hold at every point:

- **The reviewer did not write the code.** A fresh-context subagent reviews; a different fresh
  subagent fixes; the reviewer re-reviews. One agent never occupies two of those seats.
- **Roles, not names.** The reviewer role is `review`, the security reviewer is `security-review`,
  both bound to an installed skill in the batch's `02-adapters.md`. Review runs on the `judge` or
  `heavy` tier, never `light`.

## The four review points

| # | When | Scope | Lands on |
|---|---|---|---|
| **1** | L1 tests green on the feature branch, before the feature PR opens | spec compliance, then code quality and reuse | `working/<item>.agent.md` (no PR exists yet) |
| **2** | Final diff of the open feature PR, at the `documented → merged` gate | fresh-context diff review, plus the security pass when the feature's `Sensitive surfaces:` line is not `none` | the feature PR |
| **3** | Item PR open | integration review across the item's merged features, plus the rogue-check | the item PR |
| **4** | Batch PR open | final whole-batch review, plus the rogue-check once more | the batch PR |

### Point 1: spec compliance and quality, on the branch

Two stages in order: first does the code deliver what the feature file's "What & why" and the
card's acceptance criteria state, then is it good code by the dimensions below. Run both stages the
way the `subagent-driven-development` skill defines them: name the skill in the packet and let the
subagent load it. Point 1 predates the PR, so its findings and their resolution live in
`working/<item>.agent.md`, and the PR description written at point 2 summarizes them.

### Point 2: feature PR, final diff

The PR was opened at the `reviewed` gate (see `references/lifecycle.md`) and has since collected L3 evidence and the docs chapter. A reviewer with no memory of the implementation reads the final diff against the feature file and the
item card. It reports findings; it does not fix. The feature PR auto-merges only when every finding
is resolved, which is also the gate that moves the feature to `merged`.

**Security pass.** An **additional** security-focused review (RLS, auth, payments, secrets handling)
runs only on features whose `Sensitive surfaces:` line is not `none`. Flag those surfaces in the
item card at planning time so the feature inherits the flag. The security review runs under the
`security-review` role from `02-adapters.md`, posts on the feature PR, and must be resolved before
auto-merge.

### Point 3: item PR

Integration review of the item's features **as one unit**: the seams between them, the L4
cross-feature evidence rows in the feature files, and anything more than one feature touched
(migrations, shared types, shared modules). The rogue-check runs here too.

### Point 4: batch PR

Final whole-batch review: are the `00-plan.md` decisions honored across every item, did duplication
creep in across item boundaries, does the full test-suite evidence hold, and does the spread of
`agent` and `ceiling` scores match what the diffs show. The rogue-check runs once more. The
developer merges this PR; the agent never does.

## Review dimensions

Every point applies dimensions 1 to 3. Dimension 4 applies only when the feature is flagged.

1. **Correctness.** Does it do what the feature file says, including the edge cases recorded in
   `planning/02-edge-cases.md` for this item? Are the exit points the tests claim to cover the ones
   the code actually has?
2. **Reuse and duplication.** Walk the reuse ladder in order, and report the first rung that fails:
   - **Does it already exist in this repo?** A helper, a hook, a policy, a migration pattern. Search
     before accepting new code.
   - **Is the type generated from its source?** A hand-written type that duplicates a generated
     database types file is a finding, not a style preference: the generated file is re-derived from
     the schema and its hand-written twin rots silently. Same for any generated client, route map or
     manifest.
   - **Native or standard library before a dependency**, and an already-installed dependency before
     a new one. A new dependency in a feature diff is a finding unless the PR description argues it.
3. **Project conventions.** The repo's own patterns, naming, file placement, error handling and test
   conventions win over the reviewer's preferences. Cite the existing file the convention comes from.
4. **Security**, when the feature's `Sensitive surfaces:` line is not `none`. Scope as the security
   pass above.

## Findings, then a fresh fix subagent, then a scoped re-review

1. The reviewer posts findings, each one actionable and located (file, line, what is wrong, what
   would satisfy it).
2. A **fresh** subagent fixes them. Not the implementer, whose context produced the finding in the
   first place, and not the reviewer, who would then grade its own fix.
3. The reviewer role re-reviews on fresh context, **scoped to the findings and their blast radius**,
   not the whole diff again.
4. Repeat until zero open findings. Only then does the PR auto-merge.

The loop shape and the two-stage spec-then-quality split belong to the `subagent-driven-development`
skill. Invoke it; do not restate it here.

## Rogue-check

An audit by a **fresh-context reviewer who did not execute the work.** Runs at **every item PR**,
and **once more at the batch PR**. No other cadence — moment-to-moment agent work is deliberately
unconstrained; this replaces step-level policing.

**(a) Direction.** Are the `00-plan.md` decisions honored? Any silent scope creep? Are the ledger
stages truthful (the classic drift: a row reading `complete` above an unchecked
`01-verification.md`, or `merged` before the PR actually merged)? Do the `agent` and `ceiling`
confidence scores survive a spot-check re-derivation from the diff — re-derive one or two? Does any
L5 row hold a check an agent could have run at L1 to L4? Is `working/` clean?

**(b) Execution architecture.** Was subagent-driven development actually used — one orchestrator
handing bounded tasks to subagents — or did one agent grind the whole item in a single rotting
context? Evidence: task decomposition in the working file, distinct subagent handoffs, feature
branches with independent commit clusters.

**(c) Tier and role discipline.** Did hard implementation and review run on the `heavy` or `judge`
tier, and mechanical or minor work on `light`? Did each packet take its skill from the role binding
in `02-adapters.md` instead of a hard-coded name? Evidence: the **tier and role recorded on each
dispatch** in the working file, read against the role rows of `02-adapters.md`. (Corrected
2026-09-16: this check read the model name recorded per dispatch. v2 records tier plus role, and
which model serves a tier is bound per batch in `02-adapters.md`, so a model name in the working
file is itself the finding.)

**Where findings land.** On the item PR (or the batch PR for the final pass), as review comments,
resolved before that PR auto-merges. Any finding that cannot be resolved inside the item goes into
`00-plan.md` STATE as the next order of business — **never into a code comment**.

## Reviews post on the PR

**Reviews post as GitHub PR review comments, not chat messages.** Use the GitHub MCP review flow
(`pull_request_review_write` create → `add_comment_to_pending_review` → submit) or the `gh api`
equivalents. The PR is the durable review record — the diff, the discussion, and the commit list
persist forever, which is why "PR" is the drill-down link in the feature file. Point 1 is the single
exception, because no PR exists yet; it records into `working/<item>.agent.md` instead, never into
chat either.

## Red flags

- A review delivered in chat instead of on the PR (or, at point 1, into the working file).
- The implementer fixing its own review findings, or the reviewer fixing what it found.
- A re-review that re-reads the whole diff instead of the findings and their blast radius.
- A feature or item PR merged with unresolved review findings.
- A hand-written type sitting beside the generated file it duplicates.
- A new dependency in a feature diff with no argument for it in the PR description.
- A flagged feature (`Sensitive surfaces:` not `none`) merged without the security pass.
- A confidence score that does not survive re-derivation from the diff.
- A rogue-check finding parked in a code comment instead of `00-plan.md` STATE.
- A model name, rather than a tier and a role, recorded on a dispatch in the working file.
