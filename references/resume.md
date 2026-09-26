# Resume

Reference for `rolling-wave-planning`. Loaded **first** on any resume: "continue the flow", a cold session on an existing batch, or a new input arriving mid-effort. It is also the target for phase `paused`. Run the protocol, then load the one target for the phase.

## Resumability protocol

1. **Read `00-plan.md`**: STATE, decisions, ledger, hand-back. That is the whole entry load.
2. **Read `agent/<n>-<item>/resume.md` for the open item.** One block, current by construction.
3. **Read the open feature's HEAD file, and its `.log.md` only if the next step needs an evidence or finding entry.** Never the whole `agent/` tree.
4. **Do not load `planning/00-acceptance.md` here.** It loads at the item PR and at batch close.
5. **Run the integrity sweep** below. Cheap, and on every resume.
6. **State the next action before editing anything.** If the sweep found drift, the next action is the remediation.

## Load exactly one target

| `phase:` | Load | Resumes at |
|---|---|---|
| `intake` to `interview` | invoke skill `pre-rolling-wave-planning` | the phase its STATE names, from that phase's checkpoint |
| `scaffolded` | `references/lifecycle.md` | opening the first item |
| `executing` | `references/lifecycle.md` | the transition matching the ledger stage |
| `paused` | § Resuming a paused batch below, then the phase row | the resume block |
| `done` | `references/verification.md` | the promotion pass only |

A checkpoint that exists is never regenerated. If `layout:` reads `v1` or `v2`, read `references/migration-3.md` before writing any file.

## Integrity sweep

Check each against the files you just read:

- An item row at `verified` with a verdict cell in its `verification/` files that is not PASS.
- An item at `merged` with a `verification/` file that is not named in `00-plan.md` § Hand-back, or a `runbooks/` file that is not either.
- A feature index row at `merged` whose PR never merged.
- A feature at `built` with no evidence entries in its `.log.md`, or an item at `built` with no L4 entry.
- A feature at `open` with no `flows/` file and no line in one saying the before flow does not exist yet.
- A `flows/` file whose diagram was edited after it was written (compare against the pinned SHA in its header).
- A `.log.md` entry with no SHA, or one that reads as a correction of an earlier entry.
- A second resume block for one item, an addendum, or a "supersedes" line anywhere under `agent/`.
- A feature stage ahead of its item's stage, or `phase: executing` with no item at `open`.
- Decisions contradicted by the ledger. Rows without cards, cards without rows.
- With `planning/03-blueprint/` present: a `round-<n>-answers.md` with no matching round in `planning/04-interview.md`. Record it before anything else; every later decision rests on answers sitting outside the SSOT.
- A deferred sibling stub dir with no forward link in `00-plan.md`.

For each hit, **restore truth in the cheaper direction**: demote the stage to match the evidence when the step is missing, or complete the missed step when it was done but not recorded. Anything bigger goes into STATE as the first order of business. Never start new work on top of known drift.

**The sweep also promotes.** When the developer has ticked every row in an item's `verification/` files and they all read PASS, the sweep moves that item from `merged` to `verified` in the same commit as the tick it is acting on, and strikes the matching line from § Hand-back. A group file promotes every item it spans. A row the developer has not ticked stays where it is, however finished the work looks.

## Mid-flight inputs

Triage each one immediately into exactly one of:

- **In scope**: its own ledger row and card, **at the execution slot it will actually run in**, shifting the still-unopened items. Never handle a discovered bug as narrative inside another item's log. **An improvement to a feature this batch already built is in scope by definition.**
- **Out of scope**: a **sibling stub dir**, not a file inside this batch. Create `<M>-<slug>/README.md` next to the batch dir from `templates/deferred-README.md`, numbering with the same sibling scan the batch used. Write enough context to pick it up cold, then **record a forward link in `00-plan.md`**.
- **Minor**: a ruling on a routed question, a copy or style tweak, a one-screen fix, anything under roughly a hundred changed lines with no schema change and no new screen. It is a feature `<n>.<k>` on the item that owns the code, even when that item is already `merged`: one branch, one PR onto the item branch (or straight onto the batch branch when the item branch is gone), tests, `test:all`, merge. No new item, no issue, no card edit beyond one feature-index line, no flow file, no verification file unless an existing verification row is now wrong (then fix that row), no L4, no integrity check, no acceptance row. The feature file is ten lines or fewer and the log holds the dispatch and merge rows. Size decides the lane, not the agent's taste for records: when in doubt between minor and in scope, minor. (Added 3.2.0 after the developer stopped a five-agent ceremony for four one-line rulings on 2026-09-25.)
- **Unclear**: a stub ledger row at stage `blocked`, reason "triage". Classifying it is itself work; the row keeps it visible.

**A mid-flight input that is a new requirement, not a bug, also gets a row in `planning/00-acceptance.md`**, in the developer's words, dated. Triaged out of the batch, its acceptance row reads `deferred: <the stub dir>`.

## Item numbers are execution slots

`<n>` in `agent/<n>-<item>/` is **position in execution order, never an identity**.

- **Insert that will execute NEXT**: it takes slot `(highest item opened so far) + 1` and every still-unopened item shifts by one. Rename its `agent/<n>-…` dir, retitle its issue, and fix every reference in `00-plan.md`.
- **Insert that will execute LATER**: it takes the slot after the item it follows; only items after it shift.
- **Never renumber an item that has a branch, PR, or merged code.** If a shift would require it, the insert goes at the END and STATE says explicitly that it executed out of numeric order.
- Feature numbers `<i>.<f>` are per-item and unaffected by a shift, except that `<i>` follows its item. No fractional or letter suffixes: `<N>.<i>.<f>` is already the feature grammar, so `10.1.1` is a feature, never an item.

## Pausing a batch

Pausing is a ceremony, not just stopping, and it is batch-level.

1. Nothing is left mid-feature: take the open feature to `merged`, or write the exact stopping point into `agent/<n>-<item>/resume.md` and mark the item `blocked`, reason "paused".
2. **Every ephemera row is swept**: teardown run and `Swept on` dated, or `kept: <reason>`. A pause is where ephemera does the most damage.
3. Merge the batch branch into the trunk (batch PR, CI must run on it). The batch issue stays OPEN with a pause comment. Delete merged item and feature branches; the batch branch may be deleted and re-cut on resume.
4. STATE's first line becomes `**PAUSED <date>: <one-line reason>.**` above a resume line naming the next action and the branch to cut from. Set `phase: paused`. Everything the developer owes is already in § Hand-back.
5. Update the project's state table, if one exists, so the batch reads paused with its resume pointer.

## Resuming a paused batch

Read STATE, cut or re-cut the branch it names, re-run the integrity sweep (a pause is where drift shows, since the pause froze stages other work has since moved past), clear the `PAUSED` line, set `phase:` back to what the batch was doing, then take that phase's row.
