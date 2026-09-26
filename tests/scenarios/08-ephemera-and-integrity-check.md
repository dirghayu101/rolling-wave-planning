# Scenario 8: Ephemera slot and the item-PR integrity check

## Fixture

`fixtures/12-notifications/` (same fixture as scenarios 1, 3, 4 and 6). Two things in it matter
here:

- `agent/adapters.md` § Cleanup binds a scratch root (`/tmp/rwp-12-notifications/`) and four
  teardown lines, in the order they must run. No other path in the batch is a scratch root.
- Both built features carry a filled `## Ephemera` table in their `.log.md` (columns What, Where,
  Teardown, Swept on), one of them with a `kept:` reason instead of a date. There is no working
  file and no separate ephemera ledger: v3 keeps ephemera in the feature log.

Item 4 is `open`: feature 4.1 is `merged`, 4.2 is `reviewed`, and 4.3 (`quota-upgrade-modal`) has
not had its own `open` gate taken. Item 4 reaches its item PR only once 4.3 merges, so the
integrity check has not run yet.

## Prompt

Give the fresh agent exactly this, filling `<FIXTURE>` with the absolute path of a fresh COPY of
`fixtures/12-notifications/`:

> You are working in an existing rolling-wave-planning batch at `<FIXTURE>`. Invoke the
> `rolling-wave-planning` skill. Item 4's remaining feature is 4.3. Write out, pasted in full in
> your answer: (a) every packet you would dispatch to take feature 4.3 from where it is now to
> `merged`, and (b) the packet that runs on item 4's own PR once 4.3 has merged. Resolve every
> role, tier and path against the batch's own files yourself, leave no placeholder, and do not
> dispatch or invoke any subagent. Then say, for each packet that can start ephemera, exactly
> where the returned list of started ephemera gets recorded and what sweeps it. Do not create or
> edit any file. Do not open anything under the skill repo's `tests/` directory. End your answer
> with a list titled "Files I read" naming every file you opened, in the order you opened them.

## Pass criteria

- [ ] Every packet has an `## Ephemera` slot naming **one** scratch directory under the root bound
  in `agent/adapters.md` § Cleanup, for example `/tmp/rwp-12-notifications/4.3-implement/`. A path
  inside the repo, a path beside the component, or "the session scratchpad" with no path is a fail,
  and so is a scratch root the runner invented rather than read.
- [ ] Every packet's evidence section requires an **"Ephemera started"** list from the subagent,
  with a teardown command on every row, or `none` stated explicitly. A slot that asks the subagent
  to "clean up after itself" without requiring the list and the commands is a fail: the point is
  that the next agent can sweep what this one abandoned.
- [ ] The packet that starts a dev server says so, and carries the one-server-per-worktree rule
  from `references/dispatch.md` § Concurrency: the packet that starts it kills it.
- [ ] The answer says returned ephemera rows are transcribed into `## Ephemera` in the feature's
  `agent/4-quota/3-quota-upgrade-modal.log.md`, with the four columns What, Where, Teardown and
  Swept on, and that `Swept on` is the one cell in a LOG file written twice, only from empty to a
  date or to `kept: <reason>`. A run that invents a working file, a batch-level ephemera ledger or
  a new report file for this fails.
- [ ] The item-PR packet is the **integrity check**, written from `templates/integrity-check.md`,
  at tier `light`, on fresh context, with `Roles → skills: none`.
- [ ] It asks **exactly three questions and nothing else**: do the card's feature-index stage lines
  agree with the `00-plan.md` ledger, are all verdict cells in this item's `verification/` files
  still `open`, and does every `## Ephemera` row have a `Swept on` date or a `kept:` reason with a
  non-empty Teardown cell. A fourth question, a code-quality question or a "does the record read
  well" question is a fail.
- [ ] Its scope list is read-only and closed: `00-plan.md`, `agent/4-quota/0-card.md`, the
  `## Ephemera` sections of this item's feature logs, and this item's `verification/` files.
  It states that the repo source, the diff, `planning/` and `flows/` are out of scope, and that it
  reports while the orchestrator edits.
- [ ] The answer says plainly that the integrity check **is not a review**: the one review per
  feature already happened on the feature PR, and the check opens no source file and reads no diff.
- [ ] No model-vendor name (opus, sonnet, haiku, codex, gemini, claude) appears in any packet.
  Tiers are named as `judge`, `heavy` or `light` only.
- [ ] Reading budget holds: no file under `agent/1-push-tokens/`, `agent/2-notif-prefs/`,
  `agent/3-digest-scheduler/`, or `agent/5-mute-channels/` through `agent/9-notif-analytics/` was
  opened.
- [ ] "Files I read" contains nothing under the skill repo's `tests/` directory. If it does, the
  run is void (README rule 5): re-run with a fresh agent, do not grade it.

## Grading

Packet shape in general is scenario 3's job; grade this one on the ephemera slots and the
integrity check. If the runner produces correct packets but never names the bound scratch root,
that is the single most valuable failure this scenario reports.

**Most likely to fail:** the three-questions clause. An agent handed "write the packet for the item
PR" reaches for a review by default, and a check that grows a fourth question is how process
policing creeps back in. The second cheapest tell is a scratch path the runner invented instead of
reading out of § Cleanup.

## Exercises

`references/dispatch.md` (the Ephemera slot, tiers, concurrency), `templates/handoff.agent.md`,
`templates/integrity-check.md`, `agent/adapters.md` § Cleanup, `references/review.md` § The
integrity check is not a review, `references/lifecycle.md` item `built` to `reviewed` gate.
