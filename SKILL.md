---
name: rolling-wave-planning
description: Use when starting or resuming any large multi-item or multi-step effort (many bugs, a big spec, several features) that won't fit cleanly in one context or one session, including "continue the ongoing flow" and new items arriving in an effort whose SSOT directory already exists. Don't use for a single isolated task or a quick one-off change.
---

# Rolling-Wave Planning

Router. Read the principles, find the batch's STATE, then load **exactly one** target from the phase table. Every other file in this repo stays out of context until that target, or a rule inside it, says to load it.

## Core principles

**Stable layer vs volatile layer.** For a large effort, detailed up-front plans rot before you reach them. The stable layer (what the problem is, what was decided) does not rot, so it is recorded up front. The volatile layer (how to solve it) rots on contact, so it is generated just in time, one item at a time. Pre-planning item 7 before item 1 starts is the rot this skill exists to avoid.

**O(1) resume.** What a session must load to resume is O(1) in batch size, not O(n). Audits of nine real efforts found the old single-file `00-plan.md` design failing exactly here: plans grew to 700–1,400 lines of accumulated item cards and outcome prose, overwhelming the agents reading them, not just humans. So the durable record is sharded: a tiny entry file, one card per item, one file per feature. A resume reads the entry file, the current item's card, the current feature file and that item's working file, and nothing else, no matter how many items the batch has.

**The SSOT directory is the only memory.** If a fact is not in the batch directory, it does not exist tomorrow. Session context, scratchpads and chat are staging areas, never storage. Copy anything load-bearing in.

**Kernel plus drivers.** The kernel (SSOT layout, this router, the lifecycle, the gates) is small and stable; every skill, tool and model is a driver, detected at kickoff and bound to a role in the batch's `02-adapters.md`, which is why this repo names roles and tiers (`judge`, `heavy`, `light`) and never products.

## Find the SSOT and read STATE

1. **Locate the batch directory.** Ask the user where it is, or where it should go; suggest the project convention (for example `docs/features/<N>-<name>/`). **List sibling dirs first and take the next unused number**: a real audit found two dirs both numbered 9. The scan counts deferred stub dirs (`<M>-<slug>/README.md`) as used numbers.
2. **Read only `00-plan.md`,** and from it only the STATE block's `phase:` and `layout:` fields, before you choose a target. Cards, feature files and the ledger detail are loaded later, by the target, and only for the item in play.
3. **No SSOT directory exists** for this effort: the phase is `intake`.

## Phase → ONE target

| `phase:` | Load exactly this |
|---|---|
| `intake` | invoke skill `pre-rolling-wave-planning` |
| `exploring` | invoke skill `pre-rolling-wave-planning` |
| `edge-cases` | invoke skill `pre-rolling-wave-planning` |
| `blueprint` | invoke skill `pre-rolling-wave-planning` |
| `interview` | invoke skill `pre-rolling-wave-planning` |
| `scaffolded` | `references/lifecycle.md` |
| `executing` | `references/lifecycle.md` (it derives the current step from the ledger stage) |
| `paused` | `references/resume.md` |
| `done` | `references/verification.md`, promotion pass only |

Four rules sit around the table:

- **Any resume**, meaning "continue the flow", "pick this back up", or a cold session on an existing batch, loads `references/resume.md` **first**, runs its protocol and integrity sweep, and only then takes the phase row.
- **`layout: v1` in STATE** loads `references/ssot-layout.md` § v1 batches before any file is written, then takes the phase row. Old batches keep their layout.
- **A new item, bug or discovery arriving in an existing batch** is a mid-flight input. Load `references/resume.md` and triage it there before touching the ledger, then take the phase row.
- **A `phase:` value not in this table** is drift, not a judgement call. Stop and ask the user which phase the batch is in, and fix STATE before doing any work.

## Red flags

- Loading more than one target at this router, or reading a second reference "for context" before the first one asks for it.
- Working from what is in context after a gap instead of re-reading the SSOT files. Context is stale the moment the session breaks; the directory is the truth.
- A `phase:` value that is not in the table, or STATE with no `phase:` at all.
- A subagent dispatched without a tier (`judge`, `heavy`, `light`). Subagents inherit the driver's model, so an unstated tier silently burns the expensive one.
- An audit trigger passed without an audit packet in the dispatch record. The triggers are counted, not remembered: `references/review.md` § Audit.
- "The detail is in the session transcript / my context": if it isn't in the SSOT dir, it doesn't exist tomorrow.

## Version

This repo is versioned: see `VERSION` and `CHANGELOG.md` for the current release and what changed. Sub-skills ship under `skills/` (`pre-rolling-wave-planning`, `human-assisted-verification`, `mentor-documentation-system`) and are invoked by name, never read as files from here.
