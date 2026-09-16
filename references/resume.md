# Resume

Reference for `rolling-wave-planning`. Loaded **first** on any resume: "continue the flow", "pick this back up", a cold session on an existing batch, or a new input arriving mid-effort. It is also the target for phase `paused`. Run the protocol, then load the one target for the phase.

## Resumability protocol

1. **Read `00-plan.md`** (STATE + decisions + ledger). That is the whole entry load.
2. **Read `rollout/<n>-<item>/0-card.md` for the in-progress item, then its current feature file, then `working/<item>.agent.md`. Never the whole `rollout/` tree.** Total load is bounded regardless of batch size, which is the point of the sharding.
3. **Run the integrity sweep** below. Cheap, and on every resume.
4. **State the next action before editing anything.** If the sweep found drift, the next action is the remediation, not the work.

## Load exactly one target

After the sweep, mirror the router: one target, chosen by `phase:`.

| `phase:` | Load | Resumes at |
|---|---|---|
| `intake` | invoke skill `pre-rolling-wave-planning` | Phase 0; `planning/00-intake.md` may exist already |
| `exploring` | invoke skill `pre-rolling-wave-planning` | Phase 1, continuing from `planning/01-exploration.md` |
| `edge-cases` | invoke skill `pre-rolling-wave-planning` | Phase 2, continuing from `planning/02-edge-cases.md` |
| `blueprint` | invoke skill `pre-rolling-wave-planning` | Phase 3, continuing from `planning/03-blueprint/` |
| `interview` | invoke skill `pre-rolling-wave-planning` | Phase 4, at the round after the last one in `planning/04-interview.md` |
| `scaffolded` | `references/lifecycle.md` | opening the first item |
| `executing` | `references/lifecycle.md` | the transition matching the ledger stage |
| `paused` | § Resuming a paused batch below, then the row for the phase STATE says the batch was in | the `Resume here:` block |
| `done` | `references/verification.md` | the promotion pass only |

A checkpoint that exists is never regenerated: settled questions are not re-asked, explored ground is not re-explored. If `layout: v1`, read `references/ssot-layout.md` § v1 batches before writing any file.

## Integrity sweep

Check each, against the files you just read:

- An item row at `complete` with an L5 row that is not PASS, or not ticked in `01-verification.md`.
- An item row at `documented` above an unfinished handover: a feature with no chapter in `docs/`, a `verification/` file missing its index row in `01-verification.md`, or the working file still live.
- A feature index row at `merged` whose PR never merged, or at `documented` with no chapter on the branch.
- A row at `agent-verified` with no L1 to L3 evidence rows in the feature file, or an item at `agent-verified` with no L4 cross-feature pass.
- A terminal row with a live working file, or more than one live working file for the same item.
- A feature stage ahead of its item's stage, or `phase: executing` with no item at `in-progress`.
- Decisions contradicted by the ledger. Rows without cards, cards without rows.
- A deferred sibling stub dir with no forward link in `00-plan.md`.

For each hit, **restore truth in the cheaper direction: demote the stage to match the evidence** when the step itself is missing, or **complete the missed step** when it was done but not recorded. One remediation may clear several flags at once. Anything bigger goes into STATE as the first order of business. Never start new work on top of known drift.

**The sweep also promotes.** When the human has ticked every L5 row for an item and they all read PASS, the sweep moves that item from `documented` to `complete` in the same commit as the tick, re-derives the item's `agent` and `ceiling` scores now that the human evidence exists, and dates them (`references/verification.md`). Promotion on ticks is the only path an agent may take to `complete`; a row the human has not ticked stays where it is, however finished the work looks.

## Mid-flight inputs

The user will report new issues mid-effort. Triage each one immediately into exactly one of:

- **In scope** → its own ledger row + card, even a stub, **at the execution slot it will actually run in, shifting the still-`pending` items, per "Item numbers are execution slots"** (the next unused number is almost never the right one). Never handle a discovered bug as narrative inside another item's log (an audited batch did both in consecutive weeks; the narrated one is invisible in the ledger). **An improvement to a feature this batch already built is in scope by definition**: the batch owns that surface, so it is an insert, not a deferral.
- **Out of scope** → a **sibling stub dir**, not a file inside this batch. Create `<M>-<slug>/README.md` next to the batch dir under the project's features dir, from `templates/deferred-README.md`, numbering `<M>` with the same sibling scan the batch used (the scan counts stub dirs as taken). Write enough context to pick it up cold, then **record a forward link in this batch's `00-plan.md`** so the discovery is findable from where it was found. Then continue the flow you interrupted.
- **Unclear** ("might be related, not sure") → stub ledger row at stage `triage`. Classifying it is itself work; the row keeps it visible either way.

## Item numbers are execution slots

`<n>` in `rollout/<n>-<slug>/` is **position in execution order, never an identity**; the ledger is sorted by it, and slots are assigned at open time in the planned order.

- **Insert that will execute NEXT** (the normal case, since inserts land at "now"): it takes slot `(highest item opened so far) + 1` and **every still-`pending` item shifts +1**: rename its `rollout/<n>-…` dir and, if the working file carries a number prefix, `working/<item>.agent.md`, retitle its issue `[<N>.<i>]`, and fix every reference in `00-plan.md` (ledger, STATE, and any decision that spells out the order, adding a dated note there, never a silent rewrite).
- **Insert that will execute LATER** (rare): it takes the slot after the item it follows; only items after it shift.
- **Never renumber an item that has a branch, PR, or merged code**: those numbers are frozen in git history. If a shift would require it, the insert goes at the END and STATE must say explicitly that it executed out of numeric order. That is the one allowed exception, and it is loud on purpose.
- Feature numbers `<i>.<f>` are per-item and unaffected by a shift, except that `<i>` follows its item. `docs/` chapter numbers (`docs/045-…`) are READING order, not item numbers: they never shift. No fractional or letter suffixes (`1.5`, `1a`, `1.1`) for an insert: `<N>.<i>.<f>` is already the feature grammar, so `10.1.1` is a feature, never an item.

**Why:** batch 10 gave a mid-flight item the next unused number, 4 (2026-09-04), while it actually executed second and items 2–3 were still pending: the number implied it ran last and cost the developer a long, confused session. Renumbered 2026-09-10.

## Pausing a batch

A batch can be paused when the developer must switch to other work. Pausing is a ceremony, not just stopping, and it is **batch-level**, recorded in STATE; the stages stay item-level and keep their values.

1. Nothing is left `in-progress`: take the open feature to `merged`, or record the exact stopping point in `working/<item>.agent.md` and mark the item `blocked`, reason "paused".
2. Merge the batch branch into `dev` (batch PR, CI must run on it) so trunk carries everything merged. The batch issue stays OPEN with a pause comment. Delete merged item/feature branches; the batch branch may be deleted and re-cut from `dev` on resume, and STATE says which.
3. STATE's first line becomes `**PAUSED <date> — <one-line reason>.**` above a `Resume here:` block (the whole thing under ~10 lines): the next action, every owed developer action (verification rows still open, secrets to mint, devices), and the branch to cut from. Set `phase: paused`.
4. Owed verification rows stay unticked in `01-verification.md`; owed out-of-scope work goes to its sibling stub dir with the pause date. Ledger rows keep their stage: `merged` is still `merged`.
5. Update the project's state table, if one exists (a table of active efforts in the project's root agent instructions file), so the batch reads `⏸ Paused <date>` with the resume pointer. Skip the step, with no substitute, only when the project has no such table.

## Resuming a paused batch

Read STATE first and find the `Resume here:` block. Cut or re-cut the branch it names. Re-run the integrity sweep above, which is where a pause most often shows drift, since the pause froze stages that other work has since moved past. Clear the `PAUSED` line and set `phase:` back to what the batch was doing (`executing` in almost every case). Then take that phase's row in the load table above.
