---
name: pre-rolling-wave-planning
description: Use when kicking off a large multi-item effort (several features, a big spec, a bug batch) whose SSOT plan directory does NOT yet exist and whose requirements, edge cases, or design decisions are still unsettled, e.g. the user asks to "plan out" / "set up" a brand-new batch of work. If the effort's SSOT directory already exists, use rolling-wave-planning instead. Don't use for a single small task.
---

# Pre-Rolling-Wave Planning

## Overview

Front-loads the **stable layer** of a rolling-wave effort: capture the developer's raw framing, explore the ground with cheap agents, surface edge cases, settle the screens, settle design decisions and adapter bindings with the developer, then scaffold the SSOT directory and hand off to `rolling-wave-planning`. The output that matters is a decisions table plus evidence-grounded item cards: NOT detailed per-item plans. Those are volatile; writing them now is the trap this pipeline exists to avoid.

**Token economy:** the orchestrator does judgment only: decomposition, synthesis, the interview, final review. Reading-heavy work (repo exploration, doc sweeps, log reduction) goes to cheaper models with self-contained handoff packets: objective, scope, evidence format to return (files, line refs, uncertainties), stop conditions. Treat subagent reports as leads: reopen the cited files for anything a decision will rest on.

**Paths in this file, such as `templates/00-plan.md` and `references/blueprint.md`, resolve against the `rolling-wave-planning` skill directory (the directory of that name in the same skills folder; the repo root when reading inside the repo).** That holds whether the family is read inside the repo or installed with skills.sh, which drops each sub-skill beside `rolling-wave-planning/` rather than under it. Other skills are named, never read as files.

## Phases and checkpoints

| Phase | `phase:` value | Checkpoint file |
|---|---|---|
| 0 Intake | `intake` | `planning/00-intake.md`, then `planning/00-acceptance.md` |
| 1 Exploration | `exploring` | `planning/01-exploration.md` |
| 2 Edge cases and risks | `edge-cases` | `planning/02-edge-cases.md` |
| 3 Blueprint (only with a screen) | `blueprint` | `planning/03-blueprint/` |
| 4 Interview | `interview` | `planning/04-interview.md` |
| 5 Scaffold and hand off | `scaffolded` | the SSOT tree itself |

**Write the checkpoint file and set `phase:` in the `00-plan.md` STATE block BEFORE doing the phase's work**, then fill the checkpoint as the work produces findings. A session that exits at any point resumes at the phase named, with the partial checkpoint in hand.

**Resume rule.** Read `00-plan.md`, jump to the phase its STATE names, and read `planning/00-intake.md`, the checkpoint files of the phases already completed (they are the current phase's inputs: an interview question rests on exploration findings and graduated edge cases), and the current phase's own checkpoint. Nothing else loads, and no completed phase is re-run. Continue where the checkpoint stops: an interview resumes at the next unanswered round, exploration resumes with the packets not yet dispatched. (Corrected 2026-09-16: previously "only that phase's checkpoint file plus intake", which made a resumed interview draft questions without the exploration evidence; a test runner then flagged its own question as a lookup dressed as a decision.)

## Phase 0: Intake

The developer rants: the problem, the ideas they already have, the constraints, in their own words. Do not tidy it into requirements yet, and do not start answering it.

**First action, before any exploration or discussion:**

1. **Create the SSOT directory.** Ask the user where it goes; suggest the project convention (for example `docs/features/<N>-<name>/`). **List sibling dirs first and take the next unused number**: a real audit found two dirs both numbered 9. The scan counts deferred stub dirs (`<M>-<slug>/README.md`) as used numbers.
2. **Write `00-plan.md`** from `templates/00-plan.md`, with `phase: intake` and `layout: v2` in the STATE block.
3. **Write `planning/00-intake.md`** from `templates/intake.md`: the rant verbatim first, then the extracted goals, constraints, unknowns and premises to verify, the surfaces touched (web / iOS / Android / backend), and the origin.
4. **Write `planning/00-acceptance.md`** from `templates/00-acceptance.md`, straight from the rant, before any exploration. One row per requirement **in the developer's own words**, quoted or lightly trimmed and never paraphrased into agent vocabulary, plus the fixed block of implicit rows the template carries (security pass on card-flagged surfaces, tested as far as L1 to L4 allow with the batch Testing plan run, every feature documented, no machine-specific binding in shared skill files, the developer's standing rules honoured). A long rant carries fifteen to twenty rows; a sentence holding two requirements becomes two rows; a requirement you do not yet understand still gets a row, marked for the interview. Every verdict starts `open`, and stays `open` until the developer sets it.

**Why this file exists.** A rant is read once and then compressed into goals, and the compression silently drops requirements that were stated plainly. The acceptance list is the uncompressed version, checked at every gate, and it is what the batch `done` gate reads before the effort can close.

If a deferred stub `README.md` exists for this effort (a `<M>-<slug>/README.md` sibling written when an earlier batch deferred this work), **it is the intake seed**: copy its description, its context-to-pick-up-cold and its related decisions into `planning/00-intake.md` before the developer adds to them, and link the originating batch under Origin.

Only when those four files exist do you continue to Phase 1. The rant lives in the session until it is written down, and the session is not storage.

## Phase 1: Agentic exploration

Set `phase: exploring` and open `planning/01-exploration.md` first.

Dispatch parallel cheap agents (see `dispatching-parallel-agents`) to map: current behavior and the files that own it; constraints (schema, auth, platform, project rules); prior art in the repo; anything the effort's premises depend on. Agents return evidence, not recommendations.

**Verify every premise the effort rests on.** If a premise can be settled by a query, a file read, or fetched vendor docs, settle it now: a plan anchored on a false premise fails silently at verification time, when the evidence may already be gone. Mark each premise from the intake settled or still open.

When the `code-map` role is bound and enabled (in the project's `<project root>/adapters.default.md`, or in `02-adapters.md` once it exists) and its graph file is present, every exploration packet carries the line: query the code map first, open only the files it cites.

`planning/01-exploration.md` holds the findings that survive: file paths with line refs, the settled premises with the evidence that settled them, the open ones, and one line per dispatched packet so a resume knows what is already covered.

## Phase 2: Edge cases and risks

Set `phase: edge-cases` and open `planning/02-edge-cases.md` first.

From the evidence (not imagination alone), enumerate per item: edge cases (inputs, states, platforms, roles), blast radius (shared types, DB shapes, downstream consumers), and open premises → back to Phase 1 or into the interview.

Run a premortem: "the effort failed three weeks from now: why?" Mid-flight discoveries, deadline scope cuts, and reversed decisions are the norm, not the exception: note where the plan is expected to bend, so bending is an edit to STATE, not a crisis.

Use `superpowers:brainstorming` for genuinely fuzzy feature shapes.

`planning/02-edge-cases.md` holds the enumeration, the premortem answers, and the questions that graduate to the interview.

## Phase 3: Blueprint

Run this phase only when the effort has a screen. Set `phase: blueprint`, create `planning/03-blueprint/`, then load `references/blueprint.md` and follow it: one plain-HTML wireframe per screen plus a control and state inventory that feeds the item cards.

No UI in this effort? Say so explicitly in one STATE line ("blueprint skipped: no screen in this batch") and go to Phase 4. A skipped phase that leaves no trace looks like an unfinished phase to the next session.

## Phase 4: Design-decision interview

Set `phase: interview` and open `planning/04-interview.md` first.

**The first round is the acceptance round, and it comes before any design question.** Read `planning/00-acceptance.md` back to the developer, numbered, and ask exactly three things: which requirements are missing, which rows you read wrong, and which rows they strike. Then edit the file: add the missing rows in their words, correct the misread ones, and **mark a struck row `struck: <their reason>` rather than deleting it**, so the record shows it was considered. Fill the § Interview round 1 record block with what changed and the date, and append the round to `planning/04-interview.md` like any other. A design decision taken before the list is confirmed is taken against a requirement set the developer has never seen.

Then run the `grilling` frontier method over the open decisions: each round, present every currently-answerable question, numbered, each with the realistic options, the trade-offs of each side, and your recommendation. Only genuine decisions go to the developer: anything look-up-able you look up first. Challenge the developer's framing before building on it; "you're ~80% right, but the mechanism is X" beats agreement. When decisions deserve durable ADRs, suggest the user run `/grill-with-docs` (it is user-invoked only. An agent cannot trigger it).

Every settled question lands in the decisions table with its why and its rejected alternative, dated.

**The transcript accumulates round by round** in `planning/04-interview.md`: the questions as asked, the developer's answers, and which decision-table row each answer produced. Append the round before asking the next one, so a quit mid-interview resumes at the next round with no question re-asked.

**The round before the adapter round is the testing round.** Three fixed questions, asked once, whose answers become `00-plan.md` § Testing plan at Phase 5:

1. **Which flows must be proven end to end, and which items does each span?** A flow that only exists once two or more items are in becomes a **cross-item group**, with a slug, the items it spans and the later item it is recorded on. A flow that spans the whole batch becomes an **end-to-end flow**, with the `02-adapters.md` role that drives it and the gate it runs at.
2. **How does the stack under test run, and where does seed data come from?** A compose file, the local Supabase stack, testcontainers, or a staging deployment, with its bring-up line and its reset line. Detection from `references/adapters.md` § Environment supplies the candidates, so this is a choice between detected options, not an open question. Never read `.env` for it.
3. **Which non-functional criteria exist, with numbers?** Latency, throughput, concurrency, bundle or page budgets. A criterion without a number is not one; press for the number or record `none stated`. Each criterion carries the item whose gate it is measured at.

**The final round is the adapter and ceremony round.** Follow the procedure in `references/adapters.md`: read `<project root>/adapters.default.md` if it exists, run detection over installed skills and tools, and present as numbered options only the **delta** (roles whose binding changed, newly detected alternatives, roles with nothing installed) plus the ceremony level, each with a recommendation. Then:

- Write `02-adapters.md` from `templates/02-adapters.md` with the agreed bindings.
- Save the result back as the project's `<project root>/adapters.default.md` (create it when this is the project's first batch).
- Record the surface coverage decision in the decisions table: each surface the batch touches (web / iOS / Android / backend) with the role and tool that covers it, and an uncovered surface named as a decision with install suggestions.

## Phase 5: Scaffold and hand off

Set `phase: scaffolded`, then build the rest of the SSOT tree that `rolling-wave-planning` defines:

- `00-plan.md`: STATE, decisions table, adapters pointer, testing plan, status ledger. Already created at intake; fill the ledger now.
- `00-plan.md` § Testing plan, written from the testing round's three answers: the cross-item groups table (every group at `pending`), the end-to-end flows table, the environment with its bring-up, seed and reset lines, and the load-and-performance table or `none stated`. Cards copy their own lines out of this section when each item opens, so a group left out here has no home later.
- `rollout/<n>-<item>/0-card.md`: one dir per item from `templates/0-card.md`, numbered in execution order: problem, files, evidence, acceptance criteria, sensitive-surface flags. Each card's `Acceptance rows served:` line carries the row numbers from `planning/00-acceptance.md` that this item answers, and each row's `Where it lives` cell is filled with the item that took it. **A confirmed row no card names is either an item nobody scaffolded or a row that should read `deferred:`; settle it now, not at the batch `done` gate.** **No feature files**: features are decomposed when the item opens.
  `<n>` is an **execution slot, not an identity**: an item added mid-flight takes the slot it will actually run in and shifts the later `pending` items, so scaffold the numbers in the order the work will happen. See `rolling-wave-planning`'s "Item numbers are execution slots".
- `01-verification.md` skeleton and an empty `verification/` directory for the per-feature human checklists.
- `docs/000-index.md` seed for the reader-facing chapters.
- Copy interview and exploration evidence worth keeping into the dir (`assets/` for binaries): external pointers die with the session.

With ceremony ON, also **open the batch tracking issue at kickoff** (`[<N>] <batch title>`, labelled `batch:<N>-<slug>`): it is the developer's home page for the effort. See `references/ceremony.md`.

Then invoke `rolling-wave-planning` and run its loop.

## Execution discipline is not a phase

TDD on every code item, the review cadence, and the verification ladder are fixed defaults of the main skill, not kickoff questions: they live in `references/lifecycle.md`, `references/review.md` and `references/verification.md`, and the interview only records per-card exceptions.

## Red flags

- Writing step-by-step plans for item 7 before item 1 starts.
- Leaving intake with no `planning/00-acceptance.md`, or with rows written in agent vocabulary instead of the developer's words. The list is the check on the compression, so a compressed list checks nothing.
- A design question asked before the acceptance round confirmed the list, or a struck row deleted instead of kept with its reason.
- A confirmed acceptance row that no card names and no `deferred:` verdict covers.
- Asking the developer something a query or file read would answer.
- A decision recorded without its why and rejected alternative.
- Exploration reports trusted without reopening the load-bearing citations.
- The orchestrator reading whole subsystems itself instead of dispatching.
- Scaffolding item numbers as stable identities rather than execution slots.
- Leaving a phase without its checkpoint file written and `phase:` advanced. The next session then resumes into work that is already done.
- Asking the developer adapter questions the detection already answered. The round presents the delta, not the whole roster.
- Scaffolding cards before the interview closes. Decisions still open become cards that need rewriting.
- A scaffold whose Testing plan has empty cross-item groups while two cards name the same screen or the same table. Two items on one surface is exactly the flow that only exists once both are in.
