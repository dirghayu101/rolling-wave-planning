# Item <n>: <Item title>

The item's **stable layer**: what the problem is and what "done" means, not how to solve it. Copy to `agent/<n>-<item>/0-card.md` at scaffold time.

**HEAD layer.** Rewritten in place when the premise changes. No correction block, no dated marker, no `Previously:` chain. Soft target 150 lines; past it, shard the item.

Batch: `../../00-plan.md` · Stage: **open | built | reviewed | merged** (plus `blocked`, `deferred`; `verified` is the developer's)
<renumbered <YYYY-MM-DD> from <n>>   ← keep this bridge line whenever the slot changed

## Problem

<What is wrong or missing, in behaviour the developer can observe. Two to five lines.>

## Files involved

- `<path>`: <what it owns, why this item touches it>

## Evidence

- <log line, query result, capture in `../assets/`, reproduction steps, with its date>

## Acceptance criteria

`Acceptance rows served:` <row numbers from `planning/00-acceptance.md`, e.g. `3, 7, 12`, or `none (supporting work)`>

- [ ] <observable behaviour that must hold, phrased so a test or a human step can check it>
- [ ] <backend need carried over from `planning/03-blueprint/inventory.md`, when this item has a screen>

## Test strategy

Filled from `00-plan.md` § Testing plan when the item opens, except the last line, filled at `built`.

- **L4 flow:** <the flow that exercises this item's features together> · <cross-item group slug, or `no group`>
- **Environment:** <where L2 to L4 run, taken from the plan's Testing plan>
- **Non-functional:** <the stated criterion with its number and the load tool that measures it | none stated>
- **How it was tested:** <three lines at most: what ran at L1 to L4, in which environment, and where the evidence entries are>

## Sensitive surfaces

<none | RLS | auth | payments | secrets | PII | migrations>. A flagged surface puts the security pass in the same reviewer packet.

## Standing rules for this item's packets

Present tense, current only. A rule that stops being true is deleted, not superseded.

- <one line each: a project constraint every packet for this item must carry>

## Feature index

Filled when the item opens; features are decomposed then, never at scaffold time.

| # | Feature | Stage | Flow | Confidence |
|---|---|---|---|---|
| <n>.1 | [<feature title>](<f>-<feature-slug>.md) | open | [`flows/<n>.1-<slug>.md`](../../flows/<n>.1-<slug>.md) | agent – / ceiling – |

## Outcome

Five bullets or fewer, appended when the item reaches `merged`: what shipped and what it cost.

- <...>
