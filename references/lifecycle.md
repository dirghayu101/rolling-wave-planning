# Lifecycle

Reference for `rolling-wave-planning`. Loaded at phase `scaffolded` and at phase `executing`, and it is the only target either phase loads.

**At `executing`, do not read this as a procedure from the top.** Find the in-progress item's stage in the `00-plan.md` ledger and the in-progress feature's stage in that item's card feature index, go straight to that transition below, and satisfy its gate. The ledger is the program counter.

## Unit hierarchy

| Unit        | Definition                                                                                                               | Planned                               |
| ----------- | ------------------------------------------------------------------------------------------------------------------------ | ------------------------------------- |
| **Batch**   | The whole effort. One SSOT directory.                                                                                    | Up front (stable layer only)          |
| **Item**    | Today's card.                                                                                                            | Up front (stable layer only)          |
| **Feature** | One skimmable PR (roughly **≤400 changed lines excluding tests and generated code**) delivering one coherent behavior. | **Just in time, when the item opens** |

Pre-decomposing item 7's features before item 1 starts is the rot this skill exists to avoid. **An item that is already feature-sized gets no sub-breakdown**: one item branch, one PR, one feature file numbered `1-`. Do not manufacture a split to satisfy the shape.

## Stage sets

**Feature** (in the card's feature index): `pending → in-progress → reviewed → agent-verified → documented → merged`.

**Item** (in the `00-plan.md` ledger): `pending → in-progress → agent-verified → documented → complete`.

Either scope can also sit at `triage` (not yet classified), `blocked` (with the blocker named in the note), or `deferred` (it left this batch, see `references/resume.md` § Mid-flight inputs).

`documented` is the **agent terminal** at both scopes: everything an agent can do is done, the work is handed over, and only the human's own verification stands between the item and `complete`.

Mapping from a `layout: v1` batch: v1 `code-done` at feature scope is v2 `merged`; v1 `code-done` at item scope is v2 `agent-verified` (the item PR merged, nothing human-verified yet); v1 `verified` is v2 `complete`. v1 has no equivalent of `reviewed` or `documented`. Do not rewrite a v1 ledger into v2 names; read it through this mapping.

## The loop

1. **Open an item**: take the item `pending → in-progress` gate below.
2. **Open a feature**: take the feature `pending → in-progress` gate.
3. **Work it**, delegating the how. Every subagent dispatch follows `references/dispatch.md` and carries a tier; record the tier in `working/<item>.agent.md`. New facts that change the card's problem statement get edited into the card now, not narrated in the working file.
4. **Walk the feature up its stages**, one gate at a time, until it is `merged`. Then open the next feature.
5. **Close the item** through its own gates once every feature is `merged`.

## Feature transitions

Each transition is a checklist. The stage in the feature index moves when every box is ticked, not when the work "feels" done.

### `pending → in-progress`

- [ ] The feature file `rollout/<n>-<item>/<f>-<slug>.md` exists, copied verbatim from `templates/feature.md`, with the what/why, links and test strategy planned.
- [ ] Ceremony ON: the feature branch is cut and its PR will be linked per `references/ceremony.md` § Platform linking. Load `references/ceremony.md` now if it is not already loaded; it is loaded once per item, not once per session.
- [ ] The implementation is dispatched per `references/dispatch.md`, with a tier, and the dispatch is recorded in the working file.
- [ ] TDD is running (see below). A bug feature has been through `systematic-debugging` first.

### `in-progress → reviewed`

- [ ] Tests green, and the test strategy's "Actually ran" column in the feature file is filled from the real run, not from intent.
- [ ] **Review point 1** is resolved on the branch, before the PR is opened: spec compliance against the feature file and the card's acceptance criteria, then code quality and reuse. Findings are fixed by a fresh subagent that did not write the code, then re-reviewed in scope, and the exchange is recorded in `working/<item>.agent.md`. Procedure and dimensions: `references/review.md`.
- [ ] Ceremony ON: **the feature PR is opened now** (a draft is fine), linked per `references/ceremony.md` § Platform linking. From here the PR is the durable record: L3 evidence, the docs chapter and review point 2 all attach to it.

### `reviewed → agent-verified`

- [ ] **L1 to L3 evidence rows** are recorded in the feature file, each with what was run and what it showed. Ladder definitions, what counts as evidence at each level, and the `agent` and `ceiling` scores: `references/verification.md`.
- [ ] Anything agent-actionable that would raise the score is **done, not listed**. The "what would raise this" list is only for raises needing human intervention or infrastructure that does not exist yet.
- [ ] The feature's L5 file exists in `verification/` for the human, with zero agent steps and every verdict `open`. Invoke the `human-assisted-verification` skill to write it; it owns the row shape.

### `agent-verified → documented`

- [ ] The reader chapter `docs/NNN-<slug>.md` is written **on the feature branch, before the PR merges**, so the PR carries it. It is delegated under the `docs-conventions` role, using the docs-writer binding (external CLI or `subagent`) in `02-adapters.md`, with the contract in `templates/doc-handoff.md`: feature boundary file list, item card path, terms, conventions path. A subagent fallback for that role is a normal outcome, not a failure.
- [ ] `docs/000-index.md` has the new chapter's row.

### `documented → merged`

- [ ] The feature PR description is self-sufficient (what and why, test strategy, the two scores), with the chapter already on the branch, and the PR is marked ready for review.
- [ ] **Review point 2** is resolved on the final diff: a fresh-context reviewer reads the diff against the feature file and the card, plus the security pass when the feature's `Sensitive surfaces:` line is not `none`. See `references/review.md`.
- [ ] The feature PR is merged into the item branch per `references/ceremony.md` (merge commit, not squash). With ceremony OFF, `merged` means implemented, tests green, committed.
- [ ] The feature index row in the card is updated.

## Item transitions

### `pending → in-progress`

- [ ] The card `rollout/<n>-<item>/0-card.md` is read, and its premise still holds against the repo as it is now. If it does not, the correction goes into the card first, dated.
- [ ] The item is decomposed into features of ≤400 changed lines each, and the **feature index is written into the card** with every feature at `pending`.
- [ ] `working/<item>.agent.md` is created. Exactly one, for this item.
- [ ] Ceremony ON: the item branch is cut from the batch branch and the item's tracking issue is opened as a sub-issue of the batch issue, per `references/ceremony.md`.
- [ ] Ledger row moved to `in-progress` with a one-sentence note.

### `in-progress → agent-verified`

- [ ] **Every feature PR is merged** into the item branch. A feature index row reading `merged` whose PR is still open is drift; fix it before this gate, not after.
- [ ] The **L4 cross-feature pass** has run: the features exercised together across their seams, evidence rows recorded. See `references/verification.md`.
- [ ] The item PR into the batch branch is **open**, and **review point 3** is resolved on it: integration review plus the rogue-check (direction, execution architecture, tiering read from `02-adapters.md` and the recorded packet tiers). See `references/review.md`.

### `agent-verified → documented`

This is the close-out gate. **ALL of:**

- [ ] Every feature of the item has its chapter in `docs/`, and `docs/000-index.md` is updated.
- [ ] The item's verification rows are handed over: `01-verification.md` indexes every `verification/` file for this item, and each one is complete enough for the human to execute without asking a question.
- [ ] `Outcome:` appended to the card, ≤5 bullets.
- [ ] `working/<item>.agent.md` deleted, or flagged `kept: <reason>` in the card.
- [ ] Ledger note updated, one sentence.
- [ ] The item PR is merged into the batch branch per `references/ceremony.md`.

**The gate is a checklist, not a reminder:** one audited effort collapsed 8/9 working files, the next collapsed 0/8, with the collapse instruction present in every file it ignored. Prose reminders don't survive deadline pressure; gates do.

### `documented → complete`

- [ ] **Every L5 row for this item reads PASS** in its `verification/` file and is ticked in `01-verification.md`, or the card's recorded substitute (fault injection, CI gates) is satisfied. Tick and ledger row change go in the same commit; the rule and the promotion sweep are in `references/verification.md`.
- [ ] The `agent` and `ceiling` scores are re-derived now that the human rows exist, and dated.
- [ ] Ceremony ON: the item's tracking issue is closed.

Only the human, or the resume sweep reading their ticks, sets `complete`. An agent never promotes an item past `documented` on its own judgement.

**Batch scope.** When every item reads `complete`, the batch PR into `dev` carries review point 4 (whole-batch review and a final rogue-check) and the developer merges it. Nobody else merges that one. Set `phase: done` and run the promotion pass in `references/verification.md`.

## TDD is the fixed default

Every code feature is built test-first through `superpowers:test-driven-development`. This is not a per-batch choice any more; it is the default the lifecycle assumes, and an exception is a dated line in the item's card saying which feature and why. Any feature whose subject is a bug goes through `systematic-debugging` before a fix is written, so the failing test encodes a root cause rather than a symptom.

## The working file

Exactly one live `working/<item>.agent.md` per item, holding the volatile detail and the tier recorded for each dispatch. Restructure it by editing in place. It is deleted at the item's close-out gate, or flagged `kept: <reason>` in the card. Full contract: `references/ssot-layout.md`.

## Pausing

A batch that stops mid-item does not just stop, it is paused, and pausing is a ceremony with its own steps. They live in `references/resume.md` § Pausing a batch, together with the resume that undoes them.

## Red flags

- A stage moved without its gate. The gate is the definition of the stage, not a suggestion attached to it.
- A feature at `merged` whose PR is still open, or at `documented` with no chapter in `docs/`.
- An item at `complete` with an unticked row in `01-verification.md`, or an agent setting `complete` at all.
- "DONE (verification pending)": that is `agent-verified`, a different stage.
- An item decomposed into features before its own turn came, or a split manufactured to make a feature-sized item look like three.
- A second working file for the same item, or "I'll collapse the working files at the end of the batch". Collapse is per item, at close-out.
- An Outcome block growing past 5 bullets.
- A feature file or card past ~100 lines: solution detail is leaking out of `working/`.
- A subagent dispatched without a tier, or the implementer reviewing or verifying its own work.
