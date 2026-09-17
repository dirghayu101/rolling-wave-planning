# Item <n>: <Item title>

The item's **stable layer**: what the problem is and what "done" means, not how to solve it. Copy to `rollout/<n>-<item>/0-card.md` at scaffold time and replace the bracketed text.

**Soft target 100 lines.** A card approaching 100 lines means solution detail is leaking in: move it to `working/<item>.agent.md`.

Batch: `00-plan.md` · Stage: **pending | in-progress | agent-verified | documented | complete** (plus `triage`, `blocked`, `deferred`)
<renumbered <YYYY-MM-DD> from <n>>   ← keep this bridge line whenever the slot changed, so old links and old sessions still resolve

## Problem

<What is wrong or missing, in behaviour the developer can observe. Two to five lines. Written
before any solution is chosen, and left standing even after the solution changes.>

## Files involved

- `<path>`: <what it owns, why this item touches it>
- `<path>`: <...>

## Evidence

- <log line, query result, screenshot in `assets/`, reproduction steps, with its date>
- <exploration finding with file and line ref, copied in rather than linked to a session>

## Acceptance criteria

- [ ] <observable behaviour that must hold, phrased so a test or a human step can check it>
- [ ] <backend need carried over from `planning/03-blueprint/inventory.md`, when this item has a screen>

## Test strategy

The whole-item answer, filled from `00-plan.md` § Testing plan when the item opens, except the last
line, which is filled at `agent-verified`. Per-layer detail per feature stays in that feature file's
test-strategy table; these four lines are what the developer reads to know how the item was tested
without opening any of them.

- **L4 flow:** <one sentence: the flow that exercises this item's features together> · <the cross-item group slug from `00-plan.md` § Testing plan this item belongs to, or `no group`>
- **Environment:** <where L2 to L4 run, taken from `00-plan.md` § Testing plan: `compose: docker compose -f <file> up`, `supabase start` with seed `<path>`, or a staging URL>. Not the tool bindings; those stay in `02-adapters.md`.
- **Non-functional:** <the stated criterion with its number, and the load-tool binding from `02-adapters.md` § Load testing that measures it | none stated>
- **How it was tested:** <filled at `agent-verified`, three lines at most: what ran at L1 to L4 across this item's features, in which environment, and the evidence pointer (the feature files' evidence logs)>

## Sensitive surfaces

<none | RLS | auth | payments | secrets | PII | migrations>. Flagged surfaces pull in the security pass and the `security-review` role's skill at review time.

## Feature index

Filled in when the item opens; features are decomposed then, never at scaffold time.

| # | Feature | Stage | agent | ceiling |
|---|---|---|---|---|
| <n>.1 | [<feature title>](<f>-<feature-slug>.md) | pending | – | – |

Feature stages: `pending` → `in-progress` (TDD) → `reviewed` → `agent-verified` → `documented` → `merged`. `agent` is the confidence score on L1 to L4 evidence; `ceiling` is the same rubric with every L5 human row assumed PASS. Both are dated in the feature file's evidence log; these cells carry the numbers only.

## Outcome

Appended when the item reaches `agent-verified`. **Five bullets or fewer**, what actually shipped and what it cost.

- <...>

## Correction <YYYY-MM-DD>

Only when the card's premise was overturned. Never silently rewrite the Problem section; leave it and add this block.

- **Assumed:** <what the card said>
- **Actually:** <what the evidence showed, with the evidence>
- **Why it was plausible:** <what made the wrong version reasonable, so the same error is not repeated>

## Working file

Deleted at close-out by default. When it is kept, say why here:

`kept: <reason the JIT detail still earns its place, e.g. an unresolved follow-up documented nowhere else>`
