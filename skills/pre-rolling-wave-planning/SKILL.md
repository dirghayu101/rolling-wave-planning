---
name: pre-rolling-wave-planning
description: Use when kicking off a large multi-item effort (several features, a big spec, a bug batch) whose SSOT plan directory does NOT yet exist and whose requirements, edge cases, or design decisions are still unsettled — e.g. the user asks to "plan out" / "set up" a brand-new batch of work. If the effort's SSOT directory already exists, use rolling-wave-planning instead. Don't use for a single small task.
---

# Pre-Rolling-Wave Planning

## Overview

Front-loads the **stable layer** of a rolling-wave effort: capture the developer's raw framing, explore the ground with cheap agents, surface edge cases, settle the screens, settle design decisions and adapter bindings with the developer, then scaffold the SSOT directory and hand off to `rolling-wave-planning`. The output that matters is a decisions table plus evidence-grounded item cards — NOT detailed per-item plans. Those are volatile; writing them now is the trap this pipeline exists to avoid.

**Token economy:** the orchestrator does judgment only — decomposition, synthesis, the interview, final review. Reading-heavy work (repo exploration, doc sweeps, log reduction) goes to cheaper models with self-contained handoff packets: objective, scope, evidence format to return (files, line refs, uncertainties), stop conditions. Treat subagent reports as leads: reopen the cited files for anything a decision will rest on.

**Paths in this file are relative to the repo root**, two levels up from `skills/pre-rolling-wave-planning/`. So `templates/00-plan.md` means `<repo root>/templates/00-plan.md`. Other skills are named, never read as files.

## Phases and checkpoints

| Phase | `phase:` value | Checkpoint file |
|---|---|---|
| 0 Intake | `intake` | `planning/00-intake.md` |
| 1 Exploration | `exploring` | `planning/01-exploration.md` |
| 2 Edge cases and risks | `edge-cases` | `planning/02-edge-cases.md` |
| 3 Blueprint (only with a screen) | `blueprint` | `planning/03-blueprint/` |
| 4 Interview | `interview` | `planning/04-interview.md` |
| 5 Scaffold and hand off | `scaffolded` | the SSOT tree itself |

**Write the checkpoint file and set `phase:` in the `00-plan.md` STATE block BEFORE doing the phase's work**, then fill the checkpoint as the work produces findings. A session that exits at any point resumes at the phase named, with the partial checkpoint in hand.

**Resume rule.** Read `00-plan.md`, jump to the phase its STATE names, and read only that phase's checkpoint file plus `planning/00-intake.md`. Nothing else from the batch loads. Continue where the checkpoint stops: an interview resumes at the next unanswered round, exploration resumes with the packets not yet dispatched.

## Phase 0 — Intake

The developer rants: the problem, the ideas they already have, the constraints, in their own words. Do not tidy it into requirements yet, and do not start answering it.

**First action, before any exploration or discussion:**

1. **Create the SSOT directory.** Ask the user where it goes; suggest the project convention (for example `docs/features/<N>-<name>/`). **List sibling dirs first and take the next unused number** — a real audit found two dirs both numbered 9. The scan counts deferred stub dirs (`<M>-<slug>/README.md`) as used numbers.
2. **Write `00-plan.md`** from `templates/00-plan.md`, with `phase: intake` and `layout: v2` in the STATE block.
3. **Write `planning/00-intake.md`** from `templates/intake.md`: the rant verbatim first, then the extracted goals, constraints, unknowns and premises to verify, the surfaces touched (web / iOS / Android / backend), and the origin.

If a deferred stub `README.md` exists for this effort (a `<M>-<slug>/README.md` sibling written when an earlier batch deferred this work), **it is the intake seed**: copy its description, its context-to-pick-up-cold and its related decisions into `planning/00-intake.md` before the developer adds to them, and link the originating batch under Origin.

Only when those three files exist do you continue to Phase 1. The rant lives in the session until it is written down, and the session is not storage.

## Phase 1 — Agentic exploration

Set `phase: exploring` and open `planning/01-exploration.md` first.

Dispatch parallel cheap agents (see `dispatching-parallel-agents`) to map: current behavior and the files that own it; constraints (schema, auth, platform, project rules); prior art in the repo; anything the effort's premises depend on. Agents return evidence, not recommendations.

**Verify every premise the effort rests on.** If a premise can be settled by a query, a file read, or fetched vendor docs, settle it now — a plan anchored on a false premise fails silently at verification time, when the evidence may already be gone. Mark each premise from the intake settled or still open.

When the `code-map` role is bound and enabled (in the project's `<features-dir>/adapters.default.md`, or in `02-adapters.md` once it exists) and its graph file is present, every exploration packet carries the line: query the code map first, open only the files it cites.

`planning/01-exploration.md` holds the findings that survive: file paths with line refs, the settled premises with the evidence that settled them, the open ones, and one line per dispatched packet so a resume knows what is already covered.

## Phase 2 — Edge cases and risks

Set `phase: edge-cases` and open `planning/02-edge-cases.md` first.

From the evidence (not imagination alone), enumerate per item: edge cases (inputs, states, platforms, roles), blast radius (shared types, DB shapes, downstream consumers), and open premises → back to Phase 1 or into the interview.

Run a premortem: "the effort failed three weeks from now — why?" Mid-flight discoveries, deadline scope cuts, and reversed decisions are the norm, not the exception — note where the plan is expected to bend, so bending is an edit to STATE, not a crisis.

Use `superpowers:brainstorming` for genuinely fuzzy feature shapes.

`planning/02-edge-cases.md` holds the enumeration, the premortem answers, and the questions that graduate to the interview.

## Phase 3 — Blueprint

Run this phase only when the effort has a screen. Set `phase: blueprint`, create `planning/03-blueprint/`, then load `references/blueprint.md` and follow it: one plain-HTML wireframe per screen plus a control and state inventory that feeds the item cards.

No UI in this effort? Say so explicitly in one STATE line ("blueprint skipped: no screen in this batch") and go to Phase 4. A skipped phase that leaves no trace looks like an unfinished phase to the next session.

## Phase 4 — Design-decision interview

Set `phase: interview` and open `planning/04-interview.md` first.

Run the `grilling` frontier method over the open decisions: each round, present every currently-answerable question, numbered, each with the realistic options, the trade-offs of each side, and your recommendation. Only genuine decisions go to the developer — anything look-up-able you look up first. Challenge the developer's framing before building on it; "you're ~80% right, but the mechanism is X" beats agreement. When decisions deserve durable ADRs, suggest the user run `/grill-with-docs` (it is user-invoked only — an agent cannot trigger it).

Every settled question lands in the decisions table with its why and its rejected alternative, dated.

**The transcript accumulates round by round** in `planning/04-interview.md`: the questions as asked, the developer's answers, and which decision-table row each answer produced. Append the round before asking the next one, so a quit mid-interview resumes at the next round with no question re-asked.

**The final round is the adapter and ceremony round.** Follow the procedure in `references/adapters.md`: read `<features-dir>/adapters.default.md` if it exists, run detection over installed skills and tools, and present as numbered options only the **delta** (roles whose binding changed, newly detected alternatives, roles with nothing installed) plus the ceremony level, each with a recommendation. Then:

- Write `02-adapters.md` from `templates/02-adapters.md` with the agreed bindings.
- Save the result back as the project's `<features-dir>/adapters.default.md` (create it when this is the project's first batch).
- Record the surface coverage decision in the decisions table: each surface the batch touches (web / iOS / Android / backend) with the role and tool that covers it, and an uncovered surface named as a decision with install suggestions.

## Phase 5 — Scaffold and hand off

Set `phase: scaffolded`, then build the rest of the SSOT tree that `rolling-wave-planning` defines:

- `00-plan.md` — STATE, decisions table, adapters pointer, status ledger. Already created at intake; fill the ledger now.
- `rollout/<n>-<item>/0-card.md` — one dir per item from `templates/0-card.md`, numbered in execution order: problem, files, evidence, acceptance criteria, sensitive-surface flags. **No feature files** — features are decomposed when the item opens.
  `<n>` is an **execution slot, not an identity**: an item added mid-flight takes the slot it will actually run in and shifts the later `pending` items, so scaffold the numbers in the order the work will happen. See `rolling-wave-planning`'s "Item numbers are execution slots".
- `01-verification.md` skeleton and an empty `verification/` directory for the per-feature human checklists.
- `docs/000-index.md` seed for the reader-facing chapters.
- Copy interview and exploration evidence worth keeping into the dir (`assets/` for binaries) — external pointers die with the session.

With ceremony ON, also **open the batch tracking issue at kickoff** (`[<N>] <batch title>`, labelled `batch:<N>-<slug>`) — it is the developer's home page for the effort. See `references/ceremony.md`.

Then invoke `rolling-wave-planning` and run its loop.

## Execution discipline is not a phase

TDD on every code item, the review cadence, and the verification ladder are fixed defaults of the main skill, not kickoff questions: they live in `references/lifecycle.md`, `references/review.md` and `references/verification.md`, and the interview only records per-card exceptions.

## Red flags

- Writing step-by-step plans for item 7 before item 1 starts.
- Asking the developer something a query or file read would answer.
- A decision recorded without its why and rejected alternative.
- Exploration reports trusted without reopening the load-bearing citations.
- The orchestrator reading whole subsystems itself instead of dispatching.
- Scaffolding item numbers as stable identities rather than execution slots.
- Leaving a phase without its checkpoint file written and `phase:` advanced. The next session then resumes into work that is already done.
- Asking the developer adapter questions the detection already answered. The round presents the delta, not the whole roster.
- Scaffolding cards before the interview closes. Decisions still open become cards that need rewriting.
