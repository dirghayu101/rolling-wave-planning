---
name: rolling-wave-planning
description: Use when starting or resuming any large multi-item or multi-step effort (many bugs, a big spec, several features) that won't fit cleanly in one context or one session, including "continue the ongoing flow" and new items arriving in an effort whose SSOT directory already exists. Don't use for a single isolated task or a quick one-off change.
---

# Rolling-Wave Planning

Router. Read the principles, find the batch's STATE, then load **exactly one** target from the phase table. Every other file in this repo stays out of context until that target, or a rule inside it, says to load it.

## Core principles

**Stable layer vs volatile layer.** Detailed up-front plans rot before you reach them. The stable layer (what the problem is, what was decided) is recorded up front. The volatile layer (how to solve it) is generated just in time, one item at a time. Pre-planning item 7 before item 1 starts is the rot this skill exists to avoid.

**O(1) resume.** What a session loads to resume is O(1) in batch size. A resume reads `00-plan.md`, the open item's card, the open feature's file and that item's resume block, and nothing else, whatever the batch size.

**Two record layers, and only two.**

- **LOG**: append-only and immutable. Dispatch rows, evidence rows, review findings. Every entry carries the SHA it was true at. Never edited, never re-pinned, never corrected.
- **HEAD**: rewritten in place and capped. `00-plan.md` STATE, a feature's stage line, scope, links, score, and ONE resume block per item.

A record entry is one or the other. A file that is edited to stay current is HEAD; a file that is appended to is LOG. Re-pinning a LOG entry to a newer commit is the failure this split exists to prevent.

**The record is not the product.** The record exists so an agent can resume and a human can review a PR. It is not reviewed, not audited for internal agreement, and never grows a correction chain. Code and tests are the product.

**One writer.** The orchestrator, or one light scribe it dispatches, writes the SSOT. Subagents return facts; they never edit SSOT files.

**Kernel plus drivers.** The kernel (layout, router, lifecycle, gates) is small and stable. Every skill, tool and model is a driver, detected at kickoff and bound to a role in `agent/adapters.md`, which is why this repo names roles and the four tiers (`orchestrator`, `judge`, `heavy`, `light`) and never products. The session runs on the `orchestrator` binding; the other three are dispatched.

## Find the SSOT and read STATE

1. **Locate the batch directory.** Ask the user where it is, or where it should go; suggest the project convention (for example `docs/features/<N>-<name>/`). **List sibling dirs first and take the next unused number.** The scan counts deferred stub dirs (`<M>-<slug>/README.md`) as used numbers.
2. **Read only `00-plan.md`,** and from it only STATE's `phase:` and `layout:` fields, before choosing a target.
3. **No SSOT directory exists** for this effort: the phase is `intake`.

## Phase to ONE target

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

Stages inside `executing`, at both feature and item scope: `open` to `built` to `reviewed` to `merged`, plus `blocked` and `deferred`. `merged` is the agent terminal at both scopes. Only the ticks on the `verification/` files, made by hand on dev, reach `verified`, and they usually land later. `references/lifecycle.md` owns the gates.

**Two stages: verify on dev, then deploy through the runbooks.** The dev pass runs from the batch branch served locally against dev, before any merge, and needs no production access. `runbooks/` is the production stage: procedures run by hand, never by an agent, after the dev pass and the merge, and their post-checks are the production-side verification of the same flow. `references/verification.md` owns that split.

Four rules sit around the table:

- **Any resume**, meaning "continue the flow", "pick this back up", or a cold session on an existing batch, loads `references/resume.md` **first**, runs its protocol and integrity sweep, and only then takes the phase row.
- **`layout: v2` or `layout: v1` in STATE** loads `references/migration-3.md` before any file is written. Old batches are migrated once, not run in place.
- **A new item, bug or discovery arriving in an existing batch** is a mid-flight input. Load `references/resume.md` and triage it there before touching the ledger, then take the phase row.
- **A `phase:` value not in this table** is drift, not a judgement call. Stop and ask the user which phase the batch is in, and fix STATE before doing any work.

## Red flags

- Loading more than one target at this router, or reading a second reference "for context" before the first one asks for it.
- Working from what is in context after a gap instead of re-reading the SSOT files.
- A `phase:` value that is not in the table, or STATE with no `phase:` at all.
- A subagent dispatched without a tier (`judge`, `heavy`, `light`). Subagents inherit the session's model, so an unstated tier silently spends it on work a cheaper tier could do.
- A judge dispatch answering a decision that is the developer's, or a `judge` binding equal to `orchestrator` with no note that the tier is inert.
- A LOG entry edited, re-pinned or "corrected". Append a new entry; leave the old one standing with its SHA.
- A HEAD file that has grown an addendum, a superseding section or a dated correction chain. HEAD is rewritten in place.
- A commit whose whole diff is a record edit, made between gates.
- A `verification/` row naming production, or a production post-check copied into a verification file. That work is a runbook step.
- An agent running `db:apply`, a dev reseed or a schema rehearsal while a `verification_window:` line is open in STATE.
- "The detail is in the session transcript / my context": if it is not in the SSOT dir, it does not exist tomorrow.

## Version

This repo is versioned: see `VERSION` and `CHANGELOG.md`. Sub-skills ship under `skills/` (`pre-rolling-wave-planning`, `human-assisted-verification`) and are invoked by name, never read as files from here.
