# Scenario 1: Cold resume

## Fixture

`fixtures/12-notifications/` (`tests/fixtures/12-notifications/` in this repo, built from this
repo's `templates/*`). `00-plan.md` has `phase: executing`, `layout: v3`, 9 ledger items: 1 to 3
`merged`, item 4 `open` (feature 4.1 `merged`, feature 4.2 `reviewed`, feature 4.3 listed in the
card but not opened), 5 to 9 `open` with a "not started" note. Item 4 has one resume block at
`agent/4-quota/resume.md`, a HEAD and a `.log.md` per built feature, two `flows/` files and one
`verification/` file.

## Prompt

Give the fresh agent exactly this, filling `<FIXTURE>` with the absolute path of a fresh COPY of
`fixtures/12-notifications/`:

> You are working in an existing rolling-wave-planning batch directory at `<FIXTURE>`. Invoke the
> `rolling-wave-planning` skill and continue the flow. Do not make any edits to any file. When you
> have determined the next action, stop and report: (1) the exact order you read files in, (2)
> what the integrity sweep found, if anything, (3) the single next action you would take and why,
> and (4) your confidence that no drift exists. Do not open anything under the skill repo's
> `tests/` directory. End your answer with a list titled "Files I read" naming every file you
> opened, in the order you opened them.

## Pass criteria

- [ ] Read order starts `00-plan.md` then `references/resume.md` then `references/lifecycle.md`
  (resume loads first on "continue the flow", per `SKILL.md` and `references/resume.md`).
- [ ] "Files I read" includes `agent/4-quota/resume.md`, `agent/4-quota/0-card.md` and the open
  feature's HEAD file `agent/4-quota/2-quota-settings.md`, and **nothing** under
  `agent/1-push-tokens/`, `agent/2-notif-prefs/`, `agent/3-digest-scheduler/`, or
  `agent/5-mute-channels/` through `agent/9-notif-analytics/`. Reading
  `agent/4-quota/2-quota-settings.log.md` is allowed, not required: per `references/resume.md`
  step 3 a `.log.md` loads only when the next step needs an evidence or finding entry.
- [ ] The resume block is read as **one** block. The answer does not describe reconstructing state
  from a chain of addenda, and does not go looking for a second one.
- [ ] The answer describes running the integrity sweep against the list in `references/resume.md`
  § Integrity sweep, not just asserting "no drift". At least three of its checks are named, and
  the v3-specific ones are available to name: a `merged` item whose `verification/` file is not in
  § Hand-back, a feature at `built` with no evidence entries, a `.log.md` entry with no SHA, a
  second resume block, a `flows/` file edited after it was written.
- [ ] The sweep comes back clean. The one thing it may legitimately raise is that feature 4.3 sits
  at `open` with no `flows/` file; the card states its own `open` gate has not been taken, so
  naming it as a note rather than as drift is correct, and reporting it as a blocker is not.
- [ ] A single next action is stated before any edit is claimed, and it is the correct one: feature
  4.2 is at `reviewed`, so the `reviewed` to `merged` gate is next, which means writing
  `verification/4.2-quota-settings.md` through `human-assisted-verification` and then merging
  PR 221 into the item branch. Driving L3 again, or opening feature 4.3, is wrong: 4.2's L3
  evidence is already in its `.log.md`.
- [ ] No file is read twice for context "just in case" beyond the bounded set above (the O(1)
  resume budget), and `00-plan.md`'s STATE `Next:` line is not simply copied without verifying it
  against the ledger, the card and the resume block.

**Most likely to fail if the skill is broken:** the "nothing under items 1 to 3 or 5 to 9" clause.
If `resume.md`'s per-item sharding rule (§ Resumability protocol step 2) has rotted, the agent
reads the whole `agent/` tree "for context", and that is the cheapest tell.

## Exercises

`SKILL.md` (router), `references/resume.md`, `references/lifecycle.md`.
