# Scenario 2: Quit mid-interview

## Fixture

`fixtures/13-onboarding/` (`tests/fixtures/13-onboarding/` in this repo, a pre-scaffold SSOT dir).
`00-plan.md` has `phase: interview`, `layout: v3`. `planning/00-intake.md`,
`planning/01-exploration.md` and `planning/02-edge-cases.md` are all written.
`planning/04-interview.md` has round 1 (2 questions, settled) and round 2 (1 question, settled)
with their decision-table rows already reflected in `00-plan.md`. There is **no** `agent/`
directory and **no** `agent/adapters.md`: the interview has not reached its final round.

## Prompt

Give the fresh agent exactly this, filling `<FIXTURE>` with the absolute path of a fresh COPY of
`fixtures/13-onboarding/`:

> You are working in an existing rolling-wave-planning effort at `<FIXTURE>`, which has not been
> scaffolded into items yet. Invoke the `rolling-wave-planning` skill and pick this back up. There
> is no human present to answer interview questions right now, so do not actually ask them or wait
> for an answer. Instead, report: (1) which skill and phase you routed to and why, (2) confirm
> which rounds are already settled and that you would not re-ask them, (3) draft the exact
> numbered questions you would ask in the next round, with their options, trade-offs and your
> recommendation for each, (4) state explicitly whether you would create any item cards right now,
> and (5) say what the interview's last two rounds cover and which files they write. Do not create,
> edit, or scaffold any file. Do not open anything under the skill repo's `tests/` directory. End
> your answer with a list titled "Files I read" naming every file you opened, in the order you
> opened them.

## Pass criteria

- [ ] Routes to the `pre-rolling-wave-planning` skill (via `SKILL.md`'s phase table, `phase:
  interview` invokes `pre-rolling-wave-planning`), not to `references/lifecycle.md` or any
  executing-phase file.
- [ ] Identifies the next round as round 3, and its drafted questions cover progress persistence
  and the data-source step's provider scope (the two items `planning/02-edge-cases.md` graduates
  to the interview and `planning/04-interview.md` marks "not yet asked"), not a repeat of round 1
  or round 2's questions.
- [ ] States explicitly that rounds 1 and 2 are settled and will not be re-asked, and does not
  redo Phase 1 (exploration) or Phase 2 (edge-cases) work. "Files I read" shows those checkpoint
  files were read, not re-run.
- [ ] Names the **testing round** (three fixed questions: the flows to prove end to end and the
  items each spans, how the stack under test runs and where seed data comes from, and the
  non-functional criteria with numbers) as the round before last, and says its answers become
  `00-plan.md` § Testing plan at Phase 5.
- [ ] Names the **final** round as the adapter and ceremony round, per `pre-rolling-wave-planning`
  Phase 4, and says it writes `agent/adapters.md`. An answer naming `02-adapters.md` as the path
  is a fail: that is the template's name, not the file's home.
- [ ] Confirms no item cards are created now. Cards are scaffolded only in Phase 5, after the
  interview closes, under `agent/<n>-<item>/0-card.md`.

**Most likely to fail if the skill is broken:** the "does not re-ask settled questions" clause. If
the resume rule in `pre-rolling-wave-planning` Phase 4 (or its cross-reference from
`references/resume.md`'s phase table) has rotted, the agent re-derives round 1 and 2 from scratch
instead of reading the existing transcript.

## Exercises

`SKILL.md` (router), `references/resume.md`, `skills/pre-rolling-wave-planning/SKILL.md`.
