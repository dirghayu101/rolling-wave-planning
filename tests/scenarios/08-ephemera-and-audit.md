# Scenario 8: Ephemera slot and audit trigger

## Fixture

`fixtures/12-notifications/` (same fixture as scenarios 1, 3, 4 and 6), with two additions made for
this scenario and left in place for the others:

- `02-adapters.md` carries a `## Cleanup` section (scratch root `assets/tmp/`, teardown commands
  `supabase stop` and `rm -rf assets/tmp/<packet-dir>`) and a `## Audit` section with
  `dispatches_per_audit: 8`, counted on the open item's working file since its last audit row.
  **Orchestrator step for this scenario only:** after copying the fixture, edit the copy's
  `02-adapters.md` so it reads `dispatches_per_audit: 6`. The committed fixture keeps 8 so that
  scenarios 1, 3, 4 and 6, which resume the same batch, do not trip the trigger. (Corrected
  2026-09-17: the fixture first carried 6 and a resume-time trigger, which would have fired the
  audit in every scenario on this fixture.)
- `working/4-quota.agent.md`'s dispatch record holds **exactly six dispatch rows** and no audit row,
  so the trigger has fired. (The seventh row is the draft-PR row, explicitly marked
  `ceremony (no dispatch, mechanical step)` with tier `–`; it is not a dispatch.)
- `planning/00-acceptance.md` exists with four rows, two `met` and two `open`, and `00-plan.md`
  STATE carries `acceptance: 2 of 4 rows met`.

Item 4 is `in-progress`; feature 4.2 (`quota-settings`) is at stage `reviewed` and STATE's `Next:` line
asks for its L3 pass, which is the packet the prompt calls due. (Corrected 2026-09-17: the prompt first
named feature 4.3 as due, and the baseline runner rightly refused because 4.2 had not merged; a
scenario must not contradict its fixture.) The working file ships an empty `## Ephemera` ledger (added 2026-09-17 so scenario 1's integrity sweep does not flag the fixture).

## Prompt

Give the fresh agent exactly this, filling `<FIXTURE>` with the absolute path of a fresh COPY of
`fixtures/12-notifications/`:

> You are working in an existing rolling-wave-planning batch at `<FIXTURE>`. Invoke the
> `rolling-wave-planning` skill. The batch is executing and the next packet is due: the one
> STATE's `Next:` line names, driving feature 4.2, `quota-settings`, on item 4 through L3. Do what the workflow requires next, writing the
> packet or packets you would dispatch as files under `<FIXTURE>/working/`, fully filled in, with
> every role resolved against `02-adapters.md` yourself. Do not dispatch or invoke any subagent and
> do not write any production code. Then report what you wrote and why, and list every file you
> read. Do not open anything under the skill repo's `tests/` directory. End your answer with a list
> titled "Files I read" naming every file you opened, in the order you opened them.

## Pass criteria

- [ ] Every packet written (the audit packet, and the L3 verification packet for 4.2 if the runner
  writes it too) has an `## Ephemera` slot naming **one** scratch directory under the Cleanup
  section's scratch root, for example `assets/tmp/4.2-quota-settings/` or `assets/tmp/audit-<date>/`.
  Not the repo root, not a path beside the component, not "the session scratchpad" with no path.
- [ ] Every packet's Evidence-to-return section requires an **"Ephemera started"** list from the
  subagent, with a teardown command on every row (or `none`, stated explicitly). A slot that asks the subagent to "clean up after
  itself" without requiring the list and the commands is a fail: the point is that the next agent
  can sweep what this one abandoned.
- [ ] The empty `## Ephemera` ledger in `working/4-quota.agent.md` (columns what, where, teardown,
  swept on) is left intact, and any packet that can start ephemera carries the ledger paste block
  with those four columns, so the returned list has a row shape to land in.
- [ ] Before or instead of the feature packet, the runner recognises that **the audit trigger has
  fired**: six or more dispatches recorded, `02-adapters.md` § Audit binds `dispatches_per_audit: 6`, and no
  audit row exists yet. It says so explicitly and writes an **audit packet**.
- [ ] The audit packet is at tier `heavy`, runs in a fresh context, and its SSOT read list is
  exactly `00-plan.md` (its STATE and status ledger), `planning/00-acceptance.md`, the open item's
  `working/4-quota.agent.md` (its dispatch and ephemera ledgers) and `02-adapters.md`. Not the
  `rollout/` tree, not the feature files, not `docs/`.
- [ ] The audit packet lists the checks it performs: phase and stage consistency, every dispatch
  recorded with its tier, tiers as bound in `02-adapters.md`, acceptance rows advancing, ephemera
  swept, and no work outside the SSOT. It also says its findings and realignment actions go into
  `00-plan.md` STATE under "Resume here", not into a new report file.
- [ ] The audit packet ends with its dispatch-record row (Packet cell `audit`), ready to paste into
  `working/4-quota.agent.md`, or the row is already there; either way the next count of six
  starts from it. (The prompt forbids dispatching, so the row need not be in the working file yet.)
- [ ] No model-vendor name (opus, sonnet, haiku, codex, gemini) appears in either packet. Tiers are
  named as `judge` / `heavy` / `light` only.
- [ ] "Files I read" contains nothing under the skill repo's `tests/` directory. If it does, the run
  is void (README rule 5): re-run with a fresh agent, do not grade it.
- [ ] Reading budget holds: no file under `rollout/1-push-tokens/`, `rollout/2-notif-prefs/`,
  `rollout/3-digest-scheduler/`, or `rollout/5-mute-channels/` through `rollout/9-notif-analytics/`
  was opened. The audit is a constant-cost pass, not a sweep of the batch.

## Grading

**Baseline expectation (what a run looks like without the new skill content):** the runner reads
the plan, the card and the working file, writes one clean L3 verification packet for 4.2 with the seven
standard slots and dispatch-record row, and never mentions ephemera or the audit at all. The
`## Cleanup` and `## Audit` sections sit in `02-adapters.md` unread or read and ignored, because
nothing in the skill tells the runner what to do with them. Criteria 1, 2, 4, 5 and 6 fail. Criteria 7 through 9 usually pass even at
baseline, since they test rules that already exist.

**Most likely to fail once the change is in:** criterion 4, noticing the trigger. The prompt names a
feature packet as the due work and says nothing about auditing, which is the realistic case: the
trigger is an observable in the files, and a skill that only mentions the audit in a section the
runner has no reason to open will not fire it. If the audit fires but the feature packet is dropped
entirely with no statement of what happens to it, grade criterion 4 as a pass and note the gap; if
neither is written, it is a fail.

## Exercises

`references/dispatch.md` (the Ephemera slot and the audit packet), `templates/handoff.agent.md`,
`templates/02-adapters.md` § Cleanup and § Audit, `references/resume.md` STATE "Resume here",
`references/lifecycle.md` (the sweep at the item and batch gates).
