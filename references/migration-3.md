# Migrating a v1 or v2 batch to the v3 layout

Reference for `rolling-wave-planning`. Loaded when STATE reads `layout: v1` or `layout: v2`, **before any file is written**. A batch is migrated once and then runs on v3. There is no run-in-place compatibility mode.

Run these steps in order. Every step is a `git mv`, a delete, or a rewrite of one file. Do all of it on the batch branch, in the three commits named at the end.

## Step 0: preconditions

- [ ] No feature is mid-implementation. Take the open feature to its terminal stage, or record its exact stopping point first.
- [ ] Working tree clean. `git status` empty.
- [ ] `git log --first-parent -5` read, so you know the tip the moves start from.

Record the starting SHA. Every LOG entry you carry forward keeps whatever SHA it already had; entries with no SHA get the starting SHA and a `(pre-migration)` note.

## Step 1: create the v3 directories

```bash
cd <batch dir>
mkdir -p agent flows runbooks
```

`planning/` and `verification/` already exist and do not move.

## Step 2: move the machinery under `agent/`

```bash
git mv 02-adapters.md          agent/adapters.md
git mv rollout/<n>-<item>      agent/<n>-<item>      # once per item
git mv assets                  agent/assets          # if it exists
```

v1 batches have no `rollout/`: their cards sit in `00-plan.md`. Split each one out into `agent/<n>-<item>/0-card.md` from `templates/0-card.md` as you go, then delete the card sections from `00-plan.md`.

## Step 3: split each item's working file

For each `working/<item>.agent.md`:

1. **Derive the ONE resume block.** Take the **latest** addendum or pause record only, the one that says it supersedes the others. Rewrite it into `agent/<n>-<item>/resume.md` under four headings: where the item is, what is in flight, the exact next step, the facts the next step rests on. **Discard every earlier addendum.** They are superseded by construction; keeping them is the failure the single overwritten block exists to prevent.
2. **Carry the two ledgers forward as LOG.** The `## Dispatch record` rows and the `## Ephemera` rows move into the feature `.log.md` of the feature they belong to, under `## Dispatch` and `## Ephemera`. A row that belongs to no single feature goes in the item's lowest-numbered feature log. Add the SHA column; fill it with the SHA the row names if it has one, otherwise the starting SHA plus `(pre-migration)`.
3. **Delete the rest of the file.** Standing rules that are still true move into the item card, in one short list, in the present tense, with no "added <date> at audit N" prefixes. Everything else is sediment.
4. `git rm working/<item>.agent.md`.

Then `rmdir working` once it is empty.

## Step 4: split each feature file into HEAD and LOG

For each `agent/<n>-<item>/<f>-<slug>.md`:

1. **HEAD keeps**: the stage line, what and why, links, test strategy table, sensitive surfaces, the confidence line rewritten as one line `Confidence: agent N / ceiling M`, and the what-would-raise-this list.
2. **LOG takes**: the evidence log table, review findings, dispatch rows. Move them verbatim into `agent/<n>-<item>/<f>-<slug>.log.md` and add the SHA column.
3. **Delete outright**, from both files:
   - every `Corrected <date>:`, `Re-pinned <date>:`, `REVERSAL` and `Previously:` block. A correction chain is not history worth keeping: the current statement is the record, and git holds the rest.
   - every "premise check" section pinned to a tree that has moved.
   - every re-derivation paragraph under the confidence heading.
   - every line-number pin (`repository.ts:822-832`). Replace with the file plus the symbol name, which does not go stale. If the pin cannot be resolved to a symbol, delete the sentence.
   - every count propagated from another file (test totals, finding counts). Keep a count only in the one file that produced it.
4. Cap the HEAD file at 150 lines. Past it, shard the feature.

## Step 5: strip the source tree

```bash
grep -rn "^.*Previously:" --include='*.ts' --include='*.tsx' --include='*.sql' <source dirs>
```

Delete every `Previously:` demotion chain from a source file header. Keep the header's current statement of what the file is. Do this in the same commit as step 4 so the two strips read as one change.

## Step 6: rewrite `00-plan.md`

From `templates/00-plan.md`, keeping the substance and dropping the rest:

- STATE gets `layout: v3` and the current phase.
- Ledger stages are remapped:

  | v1 | v2 | v3 |
  |---|---|---|
  | `pending` | `pending` | `open` (not yet started: leave the note saying so) |
  | `in-progress` | `in-progress` | `open` |
  | (none) | `agent-verified` | `built` |
  | (none) | `documented` | `merged` |
  | `code-done` | `merged` (feature) | `merged` |
  | `verified` | `complete` | `verified` |

  A v2 item at `documented` that has not been verified by the developer is v3 `merged`, not `verified`.
- **Add the § Hand-back section.** One line per `verification/` file the developer has not run and per `runbooks/` file they have not executed. Derive it from the unticked verdict cells, not from memory.
- Delete any acceptance re-count prose, any audit trail, any superseded plan section.
- Cap at 100 lines.

## Step 7: delete what v3 does not carry

```bash
git rm 01-verification.md                 # the ledger and § Hand-back replace it
git rm -r docs/                           # only if the project has no other home for it; ASK FIRST
```

**Ask the developer before deleting `docs/`.** The docset leaves this skill, but the chapters may still be worth keeping under the project's own documentation tree. If they are kept, `git mv docs <somewhere outside the batch dir>` instead, and record where in § Hand-back.

Everything else that v3 removed (audit packets, docs-verify verdict tables, confidence re-derivations, dated corrections) is already gone after steps 3 and 4.

## Step 8: flows for what is still open

Do **not** back-fill flow diagrams for merged features. `flows/` starts empty, and the next feature to open writes the first one.

An item still `open` whose features have not been implemented gets its before diagrams at its feature `open` gates, as normal.

## Step 9: mark `agent/` generated

Append one line to the repo's `.gitattributes`:

```
<path to batch dir>/agent/** linguist-generated=true
```

Verify with `git check-attr linguist-generated -- <batch dir>/agent/adapters.md`, which must print `linguist-generated: set`.

## Step 10: the commits

Exactly three, in this order:

1. `refactor(<batch>): move the SSOT to the v3 layout` : steps 1, 2, 9. Moves only, no content edits, so the diff reads as renames.
2. `refactor(<batch>): collapse the record to HEAD and LOG` : steps 3, 4, 6, 7. Content edits.
3. `chore(<batch>): strip Previously chains from source headers` : step 5.

Then re-run the resume integrity sweep in `references/resume.md` against the migrated tree, and fix what it flags before taking the phase row.

## Verification of the migration itself

- [ ] `find <batch dir> -name '*.agent.md'` returns nothing.
- [ ] `grep -rn 'Corrected 20\|Re-pinned\|Previously:\|supersedes' <batch dir>` returns nothing.
- [ ] Every item directory under `agent/` holds exactly one `resume.md`.
- [ ] Every feature has both a HEAD file and a `.log.md`.
- [ ] `wc -l 00-plan.md` is 100 or fewer.
- [ ] `git check-attr linguist-generated` is set on `agent/`.
- [ ] Every `verification/` file with an unticked row appears in `00-plan.md` § Hand-back.

Batches migrated before 3.1.0 must also move any production-facing rows out of `verification/` into the matching runbook.
