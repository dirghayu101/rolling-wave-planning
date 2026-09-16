# Scenario 1 — Cold resume

## Fixture

`fixtures/12-notifications/` (`tests/fixtures/12-notifications/` in this repo, built from this repo's
`templates/*`). `00-plan.md` has `phase: executing`, `layout: v2`, 9 ledger items: 1-3
`complete`, item 4 `in-progress` (feature 4.1 `merged`, feature 4.2 `reviewed`, feature 4.3
`pending`), 5-9 `pending`. Item 4's working file (`working/4-quota.agent.md`) is live with a
dispatch record.

## Prompt

Give the fresh agent exactly this, filling `<FIXTURE>` with the absolute path of a fresh COPY of
`fixtures/12-notifications/`:

> You are working in an existing rolling-wave-planning batch directory at `<FIXTURE>`. Invoke the
> `rolling-wave-planning` skill and continue the flow. Do not make any edits to any file. When you
> have determined the next action, stop and report: (1) the exact order you read files in, (2)
> what the integrity sweep found, if anything, (3) the single next action you would take and why,
> and (4) your confidence that no drift exists. End your answer with a list titled "Files I read"
> naming every file you opened, in the order you opened them.

## Pass criteria

- [ ] Read order starts `00-plan.md` → `references/resume.md` → `references/lifecycle.md` (resume
  loads first on "continue the flow", per `SKILL.md` and `references/resume.md`).
- [ ] "Files I read" includes `rollout/4-quota/0-card.md`, the current feature file
  (`rollout/4-quota/2-quota-settings.md`, since 4.2 is the in-progress feature), and
  `working/4-quota.agent.md` — and **nothing** under `rollout/1-push-tokens/`,
  `rollout/2-notif-prefs/`, `rollout/3-digest-scheduler/`, `rollout/5-mute-channels/` through
  `rollout/9-notif-analytics/`.
- [ ] The answer describes running the integrity sweep (checks against the list in
  `references/resume.md` § Integrity sweep), not just asserting "no drift".
- [ ] A single next action is stated before any edit is claimed, and it is the correct one:
  driving feature 4.2 through L3 (agent-browser) since only L1/L2 evidence exists yet at
  `reviewed`.
- [ ] No file is read twice for context "just in case" beyond the bounded set above (the O(1)
  resume budget), and `00-plan.md`'s STATE `Next:` line is not simply copied without verifying it
  against the ledger and card.

**Most likely to fail if the skill is broken:** the "nothing under items 1-3 or 5-9" clause — if
`resume.md`'s per-item sharding rule (§ Resumability protocol step 2) has rotted, the agent will
read the whole `rollout/` tree "for context" and this is the cheapest tell.

## Exercises

`SKILL.md` (router), `references/resume.md`, `references/lifecycle.md`.
