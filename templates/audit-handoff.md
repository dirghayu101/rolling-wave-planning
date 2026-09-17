# Audit packet: batch `<N>-<slug>`

The fifth review point. Copy this file, fill the bracketed text, dispatch it to a **fresh context**. The auditor did not do the work it is auditing, and reads nothing but the files listed below: an auditor that reads the code starts reviewing the code, which is what the other four review points are for. When it fires and why: `references/review.md` § Audit.

`Tier:` `heavy`
`Roles → skills:` `<none, unless 02-adapters.md binds a role for this>` (resolved from `02-adapters.md`; invoke each named skill yourself before you start)

## Objective

Report where this batch has drifted from the rolling-wave workflow, and name the realignment action for each drift. You are not fixing anything and not reviewing any code. Your output is a findings table plus a realignment list the orchestrator can act on without re-deriving your reasoning.

Trigger that fired this audit: `<N dispatches since the last audit row | pause | before the batch PR>`.

## Scope files

In scope, read only, in this order:

- `00-plan.md` (STATE, decisions, Testing plan, status ledger)
- `planning/00-acceptance.md`
- `working/<item>.agent.md` for the item at `in-progress` (its `## Dispatch record` and its `## Ephemera` ledger)
- `02-adapters.md`

Out of scope, do not open: the repo's source, the `rollout/` tree beyond what the ledger rows say, `docs/`, `verification/`, every other item's working file. Changing any file is out of scope: you report, the orchestrator edits.

## Ephemera

Everything you write outside the repo and the SSOT goes in ONE scratch directory:

`<scratch dir under the scratch root in 02-adapters.md § Cleanup, e.g. <scratch-root>/audit-<date>/>`

An audit normally starts nothing and writes nothing, so its "Ephemera started" list normally reads `none`. Say so explicitly; a missing list is not the same as an empty one.

## The checks

One finding per drift, each with the file and the line or row it was read from. A check with nothing to report gets a `clean` row, not silence: silence and "I did not run it" look identical on the other side.

1. **Phase and stage consistency.** Does STATE's `phase:` match what the ledger shows (`executing` with no item at `in-progress`, `done` with an item at `pending`, a feature stage ahead of its item's stage)? Does the `Stage:` line describe where the ledger actually is?
2. **Every dispatch recorded, with a tier.** Does every dispatch row in `## Dispatch record` carry a Date, a Packet, a **Tier** and its `Roles → skills`? A blank tier cell is a finding. A model name in place of a tier is a finding.
3. **Tiers as bound.** Read the tiers used against `02-adapters.md` § Model tiers and the role table: hard implementation, review and security on `heavy` or `judge`, mapping and mechanical work on `light`. A batch whose implementers all ran `light`, or whose formatting ran `judge`, has drifted from its own kickoff.
4. **Acceptance rows advancing.** Count the rows in `planning/00-acceptance.md` by verdict, and compare with STATE's `acceptance: <n> of <m> rows met`. Flag: a stale count; rows with no `Agent check` evidence while the items that serve them are closed; a struck row deleted rather than kept with its reason; a requirement the developer added mid-effort with no row.
5. **Ephemera swept.** In `## Ephemera`: a row with an empty `Teardown` cell, a row swept in name but with no date, a row older than the item's current stage with an empty `Swept on` and no `kept: <reason>`. Name what is presumed still running.
6. **No work outside the SSOT.** Does any ledger note, decision or dispatch outcome point at a file outside the batch directory as the record of something (a session transcript, a scratchpad path, a chat message, a code comment holding a finding)? The SSOT directory is the only memory; a pointer out of it is a finding.
7. **No machine-specific binding where it does not belong.** Bindings live in `02-adapters.md` only. Flag any model-vendor or product name written into `00-plan.md`, a card, the acceptance file or a dispatch row where a tier or a role belongs.

## Evidence to return

- **Findings table**, exactly this shape:

  | # | Check | Finding | Read from | Severity |
  |---|---|---|---|---|
  | 1 | `<check number and name>` | `<what is wrong, one sentence, or "clean">` | `<file: line or row>` | `<blocker \| drift \| note>` |

- **Realignment actions**, one line per finding that is not `clean`, phrased as a command the orchestrator can execute: what to edit, in which file, to what value. Order them: blockers first, then drift, then notes.
- **Ephemera started:** one row per container, background process, temp dir or temp file you created, with its teardown command, or `none`.
- Uncertainties, listed explicitly. An empty list means you are certain, so do not write one unless you are.

## Stop conditions

Stop and report `BLOCKED: <what, where, what would unblock it>` when any of these is true. Do not improvise past one.

- A file in the scope list is missing (no `02-adapters.md`, no working file for the item the ledger says is `in-progress`).
- STATE's `phase:` is not one of the values in the router's phase table.
- The ledger and the card directories disagree about which items exist.
- Answering a check would need a file outside the scope list.

---

## What the orchestrator does with this

1. Write the realignment actions into `00-plan.md` STATE as the next order of business: the `Resume here:` block when the batch is paused, otherwise the `Next:` line, with the rest of the list kept in order under it. Blockers are done before the step the audit interrupted.
2. Re-count `acceptance: <n> of <m> rows met` in STATE if finding 4 says it is stale.
3. Record the audit in `working/<item>.agent.md` § Dispatch record with `audit` in the Packet cell. **That row is what resets the dispatch counter**, so an audit that is not recorded will fire again immediately, and one that is not run will never fire at all.

| Date | Packet | Tier | Roles → skills | Outcome |
|---|---|---|---|---|
| `<date>` | `audit` | `heavy` | `<none>` | `<n findings, m realigned>` |

---

## Dispatch record

Paste this row into `working/<item>.agent.md` under `## Dispatch record` at dispatch time, and fill `Outcome` when the auditor returns. The `audit` Packet cell is what resets the dispatch count.

| Date | Packet | Tier | Roles → skills | Outcome |
|---|---|---|---|---|
| `<date>` | `audit` (`<trigger>`) | `heavy` | `none` | `<n findings, m realignment actions written to STATE, or BLOCKED: reason>` |
