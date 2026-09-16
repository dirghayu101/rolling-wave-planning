# SSOT layout

Reference for `rolling-wave-planning`. Load it when a batch is being scaffolded, when a file's home is in question, or when `00-plan.md` reads `layout: v1`.

## Why the record is sharded

Audits of nine real efforts found the old single-file `00-plan.md` design failing on resume cost: plans grew to 700–1,400 lines of accumulated item cards and outcome prose, overwhelming the agents reading them, not just humans. Sharding is the fix, and it is load-bearing: a tiny entry file, one card per item, one file per feature, so a resume reads the entry file, the current item's card, the current feature file and that item's working file, whatever the batch size.

## Step 0: creating the directory

1. **Ask the user where it goes;** suggest the project convention (for example `docs/features/<N>-<name>/`). **List sibling dirs first and take the next unused number** — a real audit found two dirs both numbered 9. The scan must expect **deferred stub dirs**: a `<M>-<slug>/` holding only a `README.md` is a real sibling that owns its number, and skipping it collides two efforts on one number.
2. **Everything a later session needs lives INSIDE this directory.** If a bootstrap plan, interview record, or triage note exists elsewhere (a session scratchpad, a harness plans directory), copy it in. External pointers die with the session that made them.
3. Write `layout: v2` into the STATE block at creation. It is how a future session knows which of the two trees below it is standing in.

## The v2 tree

```
<N>-<slug>/
  00-plan.md          STATE (phase + layout) + decisions + ledger
  01-verification.md  human checklist index, verdict ticks
  02-adapters.md      role → driver bindings, generated at kickoff
  planning/           00-intake.md 01-exploration.md 02-edge-cases.md 03-blueprint/ 04-interview.md
  rollout/
    <n>-<item-slug>/  numbered in execution order
      0-card.md       the item's stable card
      <f>-<feature>.md  per-feature file
  verification/       <n>.<f>-<slug>.md  group-<slug>.md   (L5, human-only)
  working/<item-slug>.agent.md   JIT volatile detail, exactly ONE live file per item
  docs/               NNN-<slug>.md reader chapters, one per feature
  assets/             screenshots, captured logs (copy expiring evidence in)
```

## Per-file contracts

**`00-plan.md`** — the entry point. Item cards do NOT live here; that is what kept every audited plan file growing without bound. ONLY:

1. **STATE** (≤10 lines): what this effort is, `phase:`, `layout:`, and what to do next. **Edited in place on every re-plan, never by appending a superseding "new plan" section.** History lives in git; four stacked re-plan narratives are what made one audited 969-line plan unskimmable.
2. **Decisions** — table: `| # | Decision | Choice + why | Date |`. When a decision is reversed, rewrite its Choice cell as: was X → now Y, why the evidence wins, dated. A stale decision sitting above a contradicting ledger row is drift.
3. **Status ledger** — one row per item: `| # | Item | Stage | Note (one sentence) |`, linking to `rollout/<n>-<item>/0-card.md`. Detail never goes in cells.
4. **Forward links** to any deferred sibling stub dir spun out of this batch, so the discovery is findable from the batch it came from.

Copy the skeleton from `templates/00-plan.md`.

**`01-verification.md`** — the human checklist **index**: one row per verification file in `verification/`, with its tick. The rows themselves live in `verification/<n>.<f>-<slug>.md` (per feature) and `verification/group-<slug>.md` (cross-feature), authored per the `human-assisted-verification` skill. Ticking is what promotes an item to `complete`; the same-commit rule and the promotion mechanics are in `references/verification.md`. Audits found ledgers asserting DONE above fully unchecked checklists in 2 of 4 batches. No human-verifiable surface (pure tooling)? Record the substitute (fault injection, CI gates) in the item's card, never drop the file silently.

**`02-adapters.md`** — the batch's driver table: every role bound to a chosen skill, tool or tier, with its detected alternatives and a one-line invocation. Generated at kickoff by copying the project defaults file `<features-dir>/adapters.default.md` and re-running detection, so the interview only has to resolve the delta; the first batch in a project generates it from detection alone and saves it back as the defaults file. The user re-binds a role by editing this file, and packets read the binding rather than naming a product. Procedure, role list and the template: `references/adapters.md` and `templates/02-adapters.md`.

**`planning/`** — the pre-execution record, one checkpoint per phase, written by `pre-rolling-wave-planning` as each phase closes: `00-intake.md` (the ask in the user's own words plus extracted goals, constraints and unknowns), `01-exploration.md`, `02-edge-cases.md`, `03-blueprint/` (wireframes and the control/state inventory, see `references/blueprint.md`), `04-interview.md` (rounds, in order). A phase left without its checkpoint cannot be resumed, only redone.

**`rollout/<n>-<item>/0-card.md`** — the item's stable layer: problem, files involved, evidence, acceptance criteria, sensitive-surface flags, and the **feature index** (features with their stage, filled in when the item opens). **At the item's terminal stage, append `Outcome:` — ≤5 bullets.** If the card's premise was overturned, use a dated correction block (assumed → actually → why it was plausible). A card approaching 100 lines means solution detail is leaking in: move it to `working/`. Template: `templates/0-card.md`.

**`rollout/<n>-<item>/<f>-<feature>.md`** — the human's skim surface: what and why, links, test strategy, evidence rows, the two confidence scores. **Copy the template verbatim from `templates/feature.md`**; solution detail belongs in `working/`. Item-level architecture and trade-off notes that are worth the human's time belong in that feature's `docs/` chapter, not in a side file here.

**`verification/`** — L5 files: human-only steps, zero agent steps, each row an action plus an observation with the exact path to it. Authored per `human-assisted-verification`; shape in `templates/verification-feature.md`.

**`working/<item>.agent.md`** — JIT detail, plus the **tier recorded per subagent dispatch**. Exactly ONE live file per item; restructure by editing in place, never by spawning a second file (two "live" files with different currency broke one audited resume path). Prune superseded sections as you go. Deleted at close-out. Packet shape: `templates/handoff.agent.md`.

**`docs/`** — the reader-facing docset, one chapter per feature, `NNN-<slug>.md` where `NNN` is a three-digit **reading-order** prefix (take the next number; reading order never shifts when item slots shift). Follow the `human-engineering-docs` conventions: `000-index.md` with an abstract, `## TL;DR` per file, evidence labels, written to the human. The chapter is written on the feature branch before its PR merges, while context is hot, not at batch end. **Deep-dives shard, not stretch:** a subject needing more than 100 lines becomes two or more numbered self-contained files, never one long one. Prefer a small diagram (ASCII inline, or `excalidraw-diagram-generator`) the moment a flow or matrix gets re-explained in prose a second time.

**`assets/`** — screenshots, captured logs, exported traces. Copy expiring evidence in: log retention is typically a day or two, and a verification row that cites a log nobody saved is unprovable by the time anyone reads it.

## Line targets

Soft target **~100 lines** on the human-facing files only: `00-plan.md`, `0-card.md`, feature files, and `docs/` chapters. Past it, the file has stopped being skimmable and detail is leaking out of `working/`: shard or move, do not shrink the font.

Agent-facing files (`working/`, packets, this repo's references) have **no line cap**, but they are pruned: delete superseded sections as they are superseded. An unbounded file of live content is fine; an unbounded file of sediment is not.

## Three-tier file naming

| Suffix       | Meaning                                                  | Examples                                                                           |
| ------------ | -------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| `*.agent.md` | Agent machinery. Reading it wastes the developer's time. | `working/1-pwa-shell.agent.md`, handoff packets                                    |
| plain `.md`  | Shared record. The developer skims it when relevant.     | `00-plan.md`, `0-card.md`, feature files                                           |
| `*.human.md` | **The developer must act or decide.**                    | prod runbooks, decisions awaiting their call, security trade-offs needing sign-off |

The suffix, not the directory, says who owns the file; every file is numbered for reading order, `.human.md` included. **Test for `.human.md`:** if the file's open TODO belongs to the developer, it is `.human.md`. Saying it in chat is not a substitute: chat scrolls away, the suffix makes the obligation findable weeks later.

## v1 batches

**A batch whose `00-plan.md` says `layout: v1`, or carries no `layout:` field at all, keeps its own layout. Do not migrate it.** Renaming directories under a paused batch breaks every link in its STATE, its ledger and its issues, for no gain.

Two differences will trip you if you assume v2:

- **`02-` meant something else.** In v1, `02-deferred.md` was a file of out-of-scope discoveries. In v2 the number belongs to `02-adapters.md`, and deferred work moved out of the batch entirely into sibling stub dirs (`references/resume.md` § Mid-flight inputs). In a v1 batch, read `02-deferred.md` as deferred work and keep appending to it; never overwrite it with an adapters table.
- **`human/` was the docs dir.** v1 chapters live in `human/NNN-<slug>.md` with the same conventions v2 uses in `docs/`. Keep writing them to `human/` in that batch.

v1 also has no `planning/`, no `verification/` dir (its checklist rows sit inline in `01-verification.md`, sharded to `verification/<item>.md` only past ~150 lines), and no `02-adapters.md`, so a v1 batch has no recorded role bindings: choose drivers per dispatch and say so in the working file. v1 stage names are `pending → in-progress → code-done → verified`; the mapping to the v2 stage sets is in `references/lifecycle.md`.
