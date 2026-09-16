---
name: pre-rolling-wave-planning
description: Use when kicking off a large multi-item effort (several features, a big spec, a bug batch) whose SSOT plan directory does NOT yet exist and whose requirements, edge cases, or design decisions are still unsettled — e.g. the user asks to "plan out" / "set up" a brand-new batch of work. If the effort's SSOT directory already exists, use rolling-wave-planning instead. Don't use for a single small task.
---

# Pre-Rolling-Wave Planning

## Overview

Front-loads the **stable layer** of a rolling-wave effort: explore the ground with cheap agents, surface edge cases, settle design decisions with the developer, choose the execution discipline, then scaffold the SSOT directory and hand off to `rolling-wave-planning`. The output that matters is a decisions table plus evidence-grounded item cards — NOT detailed per-item plans. Those are volatile; writing them now is the trap this pipeline exists to avoid.

**Token economy:** the orchestrator does judgment only — decomposition, synthesis, the interview, final review. Reading-heavy work (repo exploration, doc sweeps, log reduction) goes to cheaper models with self-contained handoff packets: objective, scope, evidence format to return (files, line refs, uncertainties), stop conditions. Treat subagent reports as leads: reopen the cited files for anything a decision will rest on.

## Phase 1 — Agentic exploration

Dispatch parallel cheap agents (see `dispatching-parallel-agents`) to map: current behavior and the files that own it; constraints (schema, auth, platform, project rules); prior art in the repo; anything the effort's premises depend on. Agents return evidence, not recommendations.

**Verify every premise the effort rests on.** If a premise can be settled by a query, a file read, or fetched vendor docs, settle it now — a plan anchored on a false premise fails silently at verification time, when the evidence may already be gone.

## Phase 2 — Edge cases & risks

From the evidence (not imagination alone), enumerate per item: edge cases (inputs, states, platforms, roles), blast radius (shared types, DB shapes, downstream consumers), and open premises → back to Phase 1 or into the interview.

Run a premortem: "the effort failed three weeks from now — why?" Mid-flight discoveries, deadline scope cuts, and reversed decisions are the norm, not the exception — note where the plan is expected to bend, so bending is an edit to STATE, not a crisis.

Use `superpowers:brainstorming` for genuinely fuzzy feature shapes.

## Phase 3 — Design-decision interview

Run the `grilling` frontier method over the open decisions: each round, present every currently-answerable question, numbered, each with the realistic options, the trade-offs of each side, and your recommendation. Only genuine decisions go to the developer — anything look-up-able you look up first. Challenge the developer's framing before building on it; "you're ~80% right, but the mechanism is X" beats agreement. When decisions deserve durable ADRs, suggest the user run `/grill-with-docs` (it is user-invoked only — an agent cannot trigger it).

Every settled question lands in the decisions table with its why and its rejected alternative, dated.

## Phase 4 — Execution discipline

Decide and record before any item starts (these audits showed improvised-later discipline evaporates under pressure):

- **TDD** is the default for every code item (`superpowers:test-driven-development`); exceptions stated per card.
- **Review cadence**: per-item spec review then code-quality review (the `subagent-driven-development` pattern), or an explicitly lighter cadence — chosen now, not negotiated at close-out.
- **Verification strategy**: which items need `human-assisted-verification` (no automatable surface, fire-and-forget effects), which are machine-provable; seed `01-verification.md` accordingly.
- **Human-docs cadence**: a `human/` chapter per item/phase close, following the `human-engineering-docs` conventions (read `~/.agents/skills/mentor-documentation-system/skills/human-engineering-docs/SKILL.md`); diagrams wherever a flow beats prose.
- **Ceremony level** (git/GitHub — branches, PR ladder, tracking issues; see `rolling-wave-planning`'s `ceremony.md`): **ON** by default for feature efforts, **lighter** for bug batches, **OFF** only if the developer asks.
- **Model tiering defaults**: heavy (e.g. `opus`) for hard implementation, code review, security review and the rogue-check; light (e.g. `sonnet`, `haiku`) for mapping, search, log reduction and mechanical edits. Every dispatch carries an **explicit model** — subagents inherit the driver's otherwise.

## Phase 5 — Scaffold & hand off

Create the SSOT dir (check sibling numbering) with the sharded structure `rolling-wave-planning` defines:

- `00-plan.md` — STATE, decisions table, status ledger. Hard cap 100 lines.
- `rollout/<n>-<item-slug>/0-card.md` — one dir per item, numbered in execution order: problem, files, evidence, acceptance criteria, sensitive-surface flags (≤100 lines). **No feature files** — features are decomposed when the item opens.
  `<n>` is an **execution slot, not an identity**: an item added mid-flight takes the slot it will actually run in and shifts the later `pending` items, so scaffold the numbers in the order the work will happen. See `rolling-wave-planning`'s "Item numbers are execution slots".
- `01-verification.md` skeleton; `02-deferred.md` stub; `human/000-index.md` seed.
- Copy interview and exploration evidence worth keeping into the dir (`assets/` for binaries) — external pointers die with the session.

With ceremony ON, also **open the batch tracking issue at kickoff** (`[<N>] <batch title>`, labelled `batch:<N>-<slug>`) — it is the developer's home page for the effort. See `ceremony.md`.

Then invoke `rolling-wave-planning` and run its loop.

## Red flags

- Writing step-by-step plans for item 7 before item 1 starts.
- Asking the developer something a query or file read would answer.
- A decision recorded without its why and rejected alternative.
- Exploration reports trusted without reopening the load-bearing citations.
- The orchestrator reading whole subsystems itself instead of dispatching.
- Scaffolding item numbers as stable identities rather than execution slots.
