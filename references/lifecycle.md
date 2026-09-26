# Lifecycle

Reference for `rolling-wave-planning`. Loaded at phase `scaffolded` and at phase `executing`, and it is the only target either phase loads.

**At `executing`, do not read this from the top.** Find the open item's stage in the `00-plan.md` ledger and the open feature's stage in that item's card feature index, go straight to that transition, and satisfy its gate. The ledger is the program counter.

A file whose home is in question, or a directory that does not yet exist: `references/ssot-layout.md`.

## Unit hierarchy

| Unit | Definition | Planned |
|---|---|---|
| **Batch** | The whole effort. One SSOT directory. | Up front, stable layer only |
| **Item** | Today's card. | Up front, stable layer only |
| **Feature** | One skimmable PR, roughly 400 changed lines or fewer excluding tests and generated code, delivering one coherent behavior. | **Just in time, when the item opens** |

**An item that is already feature-sized gets no sub-breakdown**: one item branch, one PR, one feature file numbered `1-`. Do not manufacture a split to satisfy the shape.

## Stages

Four, at both feature scope (the card's feature index) and item scope (the `00-plan.md` ledger):

`open` to `built` to `reviewed` to `merged`. Plus `blocked` (with the blocker in the note) and `deferred`.

`merged` is the **agent terminal** at both scopes. Everything an agent can do is done and the batch branch carries the work.

`verified` is set from the ticks in `verification/`, made by hand, usually weeks later, possibly for a cross-feature group rather than one feature. The agent never sets it. The resume sweep may set it when the ticks are already on disk (`references/resume.md`).

## The loop

1. **Open an item**: take the item `open` gate.
2. **Open a feature**: take the feature `open` gate.
3. **Work it**, delegating the how. Every dispatch follows `references/dispatch.md`, carries a tier, and appends one row to the feature's `.log.md`.
4. **Walk the feature to `merged`**, one gate at a time. Then open the next feature, or the next overlapping feature in its own worktree (`references/dispatch.md` § Concurrency).
5. **Close the item** once every feature is `merged`.

## Feature transitions

### to `open`

- [ ] `agent/<n>-<item>/<f>-<slug>.md` exists, copied from `templates/feature.md`, with the what and why, links and test strategy planned.
- [ ] `agent/<n>-<item>/<f>-<slug>.log.md` exists, empty.
- [ ] **The BEFORE flow is drawn.** Dispatch the `flow-explorer` role (`light` tier) to write `flows/<n>.<f>-<slug>.md` with the before diagram of the existing flow this feature will change, pinned to the base SHA. **Skip it, and say so in one line in the file, when the flow does not exist yet** (a feature that adds a surface from nothing has no before). Shape: `templates/flow.md`.
- [ ] Ceremony ON: the feature branch is cut and its PR will be linked per `references/ceremony.md`. Load that file now if it is not loaded; it loads once per item, not once per session.
- [ ] The implementation is dispatched per `references/dispatch.md`, with a tier, and the dispatch row is appended to the feature's `.log.md` with the SHA it was dispatched at.
- [ ] TDD is running. A bug feature has been through `systematic-debugging` first.

### `open` to `built`

- [ ] Tests green. The feature file's test strategy "Actually ran" column is filled from the real run, not from intent.
- [ ] **The L3 browser pass has run on any UI change**, driving the real surface through the bound adapter: the rendered element or state asserted, `console --clear` before and `errors --json` after clean of new errors, `network requests` for the calls the change makes, **geometry and focus reads** where layout or keyboard behavior changed, and a screenshot at every breakpoint the feature claims. This pass is what finds real defects; a green suite is not a substitute. Definitions: `references/verification.md`.
- [ ] Evidence rows appended to the feature's `.log.md`, each with a re-openable pointer and the SHA.
- [ ] The full test suite runs green before the PR is marked ready.
- [ ] **The AFTER flow is written** into the same `flows/` file, pinned to the head SHA, at the moment the PR is ready.
- [ ] Ceremony ON: the feature PR is opened, its description written from `templates/pr-body.md`.

### `built` to `reviewed`

- [ ] **One fresh-eyes review**, on the PR, by an agent that did not write the code. Scope: the diff, the tests, the L3 browser evidence. The security pass rides in the same packet when the card flags a sensitive surface. Procedure and the two-pass limit: `references/review.md`.
- [ ] Findings are fixed by a fresh subagent that did not write the code and did not review it, then re-reviewed in scope. **Two passes maximum.**
- [ ] Findings and their resolution are appended to the feature's `.log.md`, each with the SHA it was raised against.

### `reviewed` to `merged`

- [ ] **The feature's L5 work has a home in `verification/`**, written by the `human-assisted-verification` skill with every verdict cell reading `open`, every row running on dev, and it rides this PR. Either its own file, or a named cross-feature group file. A group file is written when the **last** feature of the group merges; until then the feature file names the group and this box is ticked by that pointer. A feature with no human-verifiable surface records its substitute in the card.
- [ ] **A feature that needs a production step** (a migration, a secret, a config flip) has its runbook written as `runbooks/<k>-<slug>.md`, numbered in run order, from `templates/runbook.md`, and it rides this PR: what it does in plain words, preflight, dry run, apply, post-check SQL or command, rollback, known consequences. The read-only production post-check lives here and nowhere else. A feature with no production step gets no runbook.
- [ ] The feature PR is merged into the item branch per `references/ceremony.md`, a merge commit, not a squash. With ceremony OFF, `merged` means implemented, tests green, committed.
- [ ] The feature index row in the card is updated, and the item's `agent/<n>-<item>/resume.md` is overwritten.

## Minor change lane

A feature triaged **minor** in `references/resume.md` skips every checklist above except tests green, the full suite green, the PR opened and merged, and a dispatch row plus a merge row in its log. No before or after flow, no verification file, no L3 pass unless the change is visual (then one screenshot in the PR body is enough), no L4, no integrity check. Its feature file is a stage line, one paragraph of what and why quoting the ruling, and the PR number. Records that a proper feature would fill stay unwritten, not filled with "not applicable". The developer's rule of 2026-09-25: if something is genuinely big and needs proper documentation, do it; otherwise it is overhead.

## Item transitions

### to `open`

- [ ] The card is read and its premise still holds against the repo as it is now. If it does not, the card is **rewritten in place**. No correction block.
- [ ] The item is decomposed into features of 400 changed lines or fewer, and the feature index is written into the card with every feature at `open` or `blocked`.
- [ ] `agent/<n>-<item>/resume.md` is created.
- [ ] Ceremony ON: the item branch is cut from the batch branch and the item's tracking issue is opened as a sub-issue of the batch issue.
- [ ] The card's test strategy is filled from `00-plan.md` § Testing plan.
- [ ] Ledger row moved to `open` with a one-sentence note.

### `open` to `built`

- [ ] **Every feature PR is merged** into the item branch.
- [ ] The **L4 cross-feature pass** has run, in the environment the card's `Environment:` line names, with evidence rows appended to the last feature's `.log.md`. A cross-item group whose later item this is has run too, and its row in `00-plan.md` § Testing plan reads `ran <date>`.
- [ ] The card's `Non-functional:` criterion, when it states one, has been measured with the bound load tool, and the numbers are in an evidence row.
- [ ] The card's `How it was tested:` line is filled, three lines at most.

### `built` to `reviewed`

- [ ] The item PR into the batch branch is open, its description written from `templates/pr-body.md`.
- [ ] **The integrity check has run** on that PR: `templates/integrity-check.md`, `light` tier, fresh context. Three questions and nothing else: do the stage lines agree with the ledger, are all verdict cells in `verification/` still `open`, and is every ephemera row swept or flagged `kept:`. It reports; the orchestrator edits. It is not a review and it does not open the source.
- [ ] Each acceptance row the card names has its evidence pointer appended in `planning/00-acceptance.md`. **The verdict column is the developer's.** Then re-count `acceptance: <n> of <m> rows met` in STATE.

### `reviewed` to `merged`

- [ ] The item PR is merged into the batch branch.
- [ ] The ledger row and note are updated, and `00-plan.md` § Hand-back gains one line per verification file and runbook this item leaves for the developer.
- [ ] `agent/<n>-<item>/resume.md` is overwritten with the item's terminal state.

## Batch scope

When every item reads `merged`, the batch PR into the trunk opens with its description from `templates/pr-body.md`, and the developer merges it. Nobody else merges that one. Before it opens:

- [ ] Every cross-item group and end-to-end flow in `00-plan.md` § Testing plan reads `ran <date>` or `n/a`.
- [ ] The full test suite has run green on the batch branch.
- [ ] Every row in `planning/00-acceptance.md` reads `met`, `struck: <reason>` or `deferred: <where>`, or is named in § Hand-back as still owed. `met` and `struck` are the developer's verdicts.
- [ ] Every ephemera row of every item is swept and dated, or carries `kept: <reason>`.
- [ ] **`runbooks/0-release.md` is written**, from `templates/release-runbook.md`: the merge order, the numbered runbooks in the order to run them, the dashboard release and its tag, the app tag or OTA push, and the version bump. It links the project's own release conventions and never restates them.
- [ ] `00-plan.md` § Hand-back is complete: every `verification/` file still owed a pass and every `runbooks/` file still to be run by hand, in the order to run them.

Then set `phase: done`. The batch is agent-complete. The code is reviewed through the PRs, the dev pass runs on `verification/`, and `runbooks/0-release.md` is then followed by hand. Items reach `verified` when those ticks land, which the next resume sweep promotes (`references/verification.md` § Promotion).

## Commits

- **Code and tests commit as they land.** Normal cadence, on the feature branch.
- **`agent/` files commit at gates only**: feature `merged`, and the item PR. Not per edit.
- **`flows/`, `verification/` and `runbooks/` ride the feature PR** that produced them.
- **Never a commit whose whole diff is a record edit, made between gates.** That is the 80-of-128 `docs(...)` commit pattern this rule exists to stop.
- Read history with `git log --first-parent`, so the batch reads as one merge per feature.

## TDD is the fixed default

Every code feature is built test-first through the `tdd` role's skill, by an implementer with fresh context. An exception is one line in the item's card saying which feature and why. Any feature whose subject is a bug goes through `systematic-debugging` before a fix is written, so the failing test encodes a root cause rather than a symptom.

## Pausing

A batch that stops mid-item is paused, which is a ceremony with its own steps: `references/resume.md` § Pausing a batch.

## Red flags

- A stage moved without its gate.
- A feature at `merged` whose PR is still open.
- A UI change at `built` with no L3 browser evidence row, or an L3 row with no geometry or focus read on a layout or keyboard change.
- A third review pass on one feature. Two is the limit; a third means the packet was wrong, so fix the packet.
- A feature opened with no `flows/` file and no line saying the before flow does not exist yet.
- A `flows/` file edited after it was written.
- An item decomposed into features before its own turn came.
- A second resume block, an addendum, or "supersedes the previous" anywhere under `agent/`.
- An entry in a `.log.md` that was edited, re-pinned or corrected.
- An item closed with unswept ephemera rows.
- An agent writing a verdict cell in `verification/` or `planning/00-acceptance.md`.
- A production step written into a `verification/` file instead of a runbook.
- A feature with a migration, a secret or a config flip merged with no `runbooks/<k>-<slug>.md`.
- A batch PR opened with no `runbooks/0-release.md`.
- A batch reaching `done` with an empty § Hand-back while `verification/` holds unrun files.
