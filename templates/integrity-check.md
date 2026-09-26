# Integrity check: item `<N>.<i>`

The one process check in this skill. Copy this file, fill the bracketed text, dispatch to a **fresh context**. It runs once per item, at the item PR, and nowhere else.

`Tier:` `light`
`Roles → skills:` `none`

## Objective

Answer three questions about this item's record and return one table. You are not reviewing code, not reading a diff, and not fixing anything. You report; the orchestrator edits.

## Scope files

Read only, and nothing else:

- `00-plan.md` (STATE, ledger, hand-back)
- `agent/<n>-<item>/0-card.md`
- every `agent/<n>-<item>/<f>-<slug>.log.md` for this item, § Ephemera only
- every `verification/` file this item's features own

Out of scope: the repo's source, the diff, other items, `planning/`, `flows/`. Opening any of them is the failure this scope list exists to prevent.

## The three questions

1. **Do the stage lines agree with the ledger?** The card's feature index stage for each feature, against the `00-plan.md` ledger row for the item. A feature at `merged` in one and not the other is a finding. An item whose ledger stage is ahead of its features is a finding.
2. **Are all verdict cells still `open`?** Every verdict cell in every `verification/` file this item owns. A cell reading PASS, FAIL or anything else, written before the developer has run the pass, is a fabricated human result and a blocker.
3. **Is every ephemera row swept?** Every row of every § Ephemera table for this item has a `Swept on` date or `kept: <reason>`, and a non-empty Teardown cell. Name what is presumed still running.

## Evidence to return

One table, exactly this shape. A question with nothing to report gets a `clean` row, not silence.

| # | Question | Finding | Read from | Severity |
|---|---|---|---|---|
| 1 | stage lines vs ledger | `<what is wrong, one sentence, or "clean">` | `<file: row>` | `<blocker \| drift \| note>` |
| 2 | verdict cells untouched | `<...>` | `<file: row>` | `<...>` |
| 3 | ephemera swept | `<...>` | `<file: row>` | `<...>` |

Then one line per non-clean row, phrased as a command the orchestrator can execute: what to edit, in which file, to what value. Blockers first.

**Ephemera started:** `none` (this check starts nothing and writes nothing). Say it explicitly.

## Stop conditions

Stop and report `BLOCKED: <what, where, what would unblock it>` when:

- A file in the scope list is missing.
- The ledger and the `agent/` directories disagree about which items exist.
- Answering a question would need a file outside the scope list.

## What the orchestrator does with this

1. Act on the realignment lines, blockers first, before the item PR merges.
2. Append one entry to the item's lowest-numbered feature `.log.md` under `## Dispatch`, with the SHA checked and the finding counts. Never edit an earlier entry.
