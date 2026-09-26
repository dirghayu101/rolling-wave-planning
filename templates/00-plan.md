# <N>: <Batch title>

The batch's entry file. Copy to `<N>-<slug>/00-plan.md` at intake and replace the bracketed text.

**Hard cap 100 lines.** HEAD layer: rewritten in place, never appended to, never given a superseding section. Item cards live under `agent/`; detail never goes in a table cell.

## STATE

```
phase: intake | exploring | edge-cases | blueprint | interview | scaffolded | executing | paused | done
layout: v3
What: <one line: what this effort delivers and for whom>
Stage: <where the batch actually is, e.g. "item 3 of 7 open, feature 3.2 in review">
acceptance: <n> of <m> rows met
verification_window: <open YYYY-MM-DD: verification pass running on dev>
Next: <the single next action, concrete enough to start cold>
```

The `verification_window:` line is present **only** while a verification pass is running on dev. While it is there, no agent runs `db:apply`, reseeds dev or rehearses a schema change on dev. Delete the line when the ticks are in.

Keep the block at 10 lines or fewer. When the batch is paused, the first line becomes:

```
**PAUSED <YYYY-MM-DD>: <one-line reason>.**
Resume here: <next action> · branch: <cut from what>
```

What the developer owes lives in § Hand-back, not in the pause line.

## Decisions

| # | Decision | Choice + why | Date |
|---|---|---|---|
| 1 | <the question that was open> | <what was chosen, why, and the rejected alternative> | <YYYY-MM-DD> |

A reversed decision is rewritten in place as `was X, now Y`, with why the new evidence wins, dated.

## Adapters

Roles, tiers and tool bindings: `agent/adapters.md`. Packets read that file; never hard-code a skill, tool or model name here.

## Acceptance

The developer's requirements in their words: `planning/00-acceptance.md`. Loaded at the item PR and at batch close, not on every resume; STATE carries the count.

## Testing plan

Batch scope, written at scaffold from the interview's testing round. Each opening item copies its lines into the card's `## Test strategy`.

### Cross-item groups

| Group | Flow | Items in | Recorded on | Status |
|---|---|---|---|---|
| `<group-slug>` | <the flow that crosses those items, one sentence> | <n>, <m> | <m> | pending \| ran <YYYY-MM-DD> \| n/a |

### End-to-end flows

| Flow | Drives it | Gate |
|---|---|---|
| <the whole path through the product, one sentence> | `<role from agent/adapters.md>` | <item <n> `built` \| batch close> |

### Environment

- Bring-up: `<one line>`
- Seed data: `<path or command>`
- Reset: `<one line>`

### Load and performance

| Criterion | Tool | Gate | Status |
|---|---|---|---|
| <the number and its unit> | `<tool bound in agent/adapters.md>` | <item <n> `built` \| batch close> | pending \| ran <YYYY-MM-DD> \| n/a |

Nothing to measure? Replace the table with `none stated`.

## Status ledger

One row per item, sorted by execution slot, linking to `agent/<n>-<item>/0-card.md`.

| # | Item | Stage | Note |
|---|---|---|---|
| 1 | [<item title>](agent/1-<item-slug>/0-card.md) | open | <one sentence> |

Stages: `open` to `built` to `reviewed` to `merged`, plus `blocked` and `deferred`. `merged` is the agent terminal. `verified` is set only from the ticks in `verification/`, which run on dev.

## Hand-back

What the developer owes, in the order to do it. Struck through when done.

| # | What | File | Note |
|---|---|---|---|
| 1 | run the dev pass for <feature or group> | `verification/<n>.<f>-<slug>.md` | <time-sensitive rows first, or none> |
| 2 | run the release sequence by hand | `runbooks/0-release.md` | after the dev pass; it orders every runbook below |
| 3 | run the production step for <what> by hand | `runbooks/<k>-<slug>.md` | <where it sits in the release order> |

## Review URLs

Ceremony ON only; delete this section when ceremony is OFF.

- Batch tracking issue: <url>
- Batch branch: `<branch>`
- Batch PR: <url, or "not yet opened">

## Deferred

Work discovered here and pushed out. One forward link per sibling stub directory.

- `<M>-<slug>/README.md`: <one line> (<YYYY-MM-DD>)
