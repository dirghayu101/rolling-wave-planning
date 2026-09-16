# <N> — <Batch title>

The batch's entry file. Copy to `<N>-<slug>/00-plan.md` at intake and replace the bracketed text.

**Soft target 100 lines.** Item cards do NOT live here; that is what kept every audited plan file growing without bound. Only STATE, decisions, the adapters pointer, the ledger, the review URLs and the deferred forward links. **Edited in place on every re-plan — never append a superseding "new plan" section.** History lives in git; four stacked re-plan narratives are what made one audited 969-line plan unskimmable. **Detail never goes in table cells**, it goes in the card, the feature file or `working/`.

## STATE

```
phase: intake | exploring | edge-cases | blueprint | interview | scaffolded | executing | paused | done
layout: v2
What: <one line: what this effort delivers and for whom>
Stage: <where the batch actually is, e.g. "item 3 of 7 in-progress, feature 3.2 in review">
Next: <the single next action, concrete enough to start cold>
```

Keep the block at 10 lines or fewer. When the batch is paused, the first line becomes:

```
**PAUSED <YYYY-MM-DD> — <one-line reason>.**
Resume here: <next action> · owed by the developer: <verification rows, secrets, devices> · branch: <cut from what>
```

A resume reads STATE first, clears the PAUSED line, and only then takes the phase row.

## Decisions

| # | Decision | Choice + why | Date |
|---|---|---|---|
| 1 | <the question that was open> | <what was chosen, why, and the rejected alternative> | <YYYY-MM-DD> |

**Reversal convention:** when a decision is reversed, rewrite its Choice cell in place as `was X → now Y`, why the new evidence wins, dated. A stale decision sitting above a contradicting ledger row is drift.

## Adapters

Roles, tiers and tool bindings for this batch: `02-adapters.md`. Packets read that file; never hard-code a skill, tool or model name here.

## Status ledger

One row per item, sorted by execution slot, linking to `rollout/<n>-<item-slug>/0-card.md`.

| # | Item | Stage | Note |
|---|---|---|---|
| 1 | [<item title>](rollout/1-<item-slug>/0-card.md) | pending | <one sentence> |

Stages: `pending` → `in-progress` → `agent-verified` → `documented` → `complete`, plus `triage` (unclassified mid-flight input), `blocked` (with the reason in the note) and `deferred`. `documented` is the agent terminal stage; `complete` is set only when every human verification row for the item reads PASS.

## Review URLs

Ceremony ON only; delete this section when ceremony is OFF.

- Batch tracking issue: <url>
- Batch branch: `<branch>`
- Batch PR: <url, or "not yet opened">
- Item PRs: recorded on each item's card, not here.

## Deferred

Work discovered in this batch and pushed out of it. Each line is a forward link to the sibling stub directory that carries the context.

- `<M>-<slug>/README.md` — <one line: what it is and why it is out of scope here> (<YYYY-MM-DD>)
