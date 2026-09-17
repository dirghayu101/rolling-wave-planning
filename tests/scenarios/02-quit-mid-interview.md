# Scenario 2 — Quit mid-interview

## Fixture

`fixtures/13-onboarding/` (`tests/fixtures/13-onboarding/` in this repo, a pre-scaffold SSOT dir). `00-plan.md` has
`phase: interview`, `layout: v2`. `planning/00-intake.md`, `planning/01-exploration.md`, and
`planning/02-edge-cases.md` are all written. `planning/04-interview.md` has round 1 (2 questions,
settled) and round 2 (1 question, settled) with their decision-table rows already reflected in
`00-plan.md`. There is **no** `rollout/` and **no** `02-adapters.md` — the interview has not
reached its final round yet.

## Prompt

Give the fresh agent exactly this, filling `<FIXTURE>` with the absolute path of a fresh COPY of
`fixtures/13-onboarding/`:

> You are working in an existing rolling-wave-planning effort at `<FIXTURE>`, which has not been
> scaffolded into items yet. Invoke the `rolling-wave-planning` skill and pick this back up. There
> is no human present to answer interview questions right now, so do not actually ask them or wait
> for an answer — instead, report: (1) which skill and phase you routed to and why, (2) confirm
> which rounds are already settled and that you would not re-ask them, (3) draft the exact
> numbered questions you would ask in the next round, with their options, trade-offs and your
> recommendation for each, (4) state explicitly whether you would create any `rollout/` cards
> right now, and (5) say what the interview's final round covers and which file it writes. Do not create, edit, or scaffold any file. Do not open anything under the skill repo's `tests/` directory. End your answer with a list titled "Files I
> read" naming every file you opened, in the order you opened them.

## Pass criteria

(Corrected 2026-09-16: the prompt gained item (5) because the fourth criterion below tests
knowledge the prompt never asked for; a runner that read the skill correctly still failed it.)

- [ ] Routes to the `pre-rolling-wave-planning` skill (via `SKILL.md`'s phase table, `phase:
  interview` → invoke `pre-rolling-wave-planning`), not to `references/lifecycle.md` or any
  executing-phase file.
- [ ] Identifies the next round as round 3, and its drafted questions cover progress persistence
  and the data-source step's provider scope (the two items `planning/02-edge-cases.md` graduates
  to the interview and `planning/04-interview.md` marks "not yet asked") — not a repeat of round 1
  or round 2's questions.
- [ ] States explicitly that rounds 1 and 2 are settled and will not be re-asked, and does not
  redo Phase 1 (exploration) or Phase 2 (edge-cases) work — "Files I read" shows those checkpoint
  files were read, not re-run.
- [ ] Names that the **final** interview round (not round 3) is the adapter-and-ceremony round,
  per `pre-rolling-wave-planning`'s Phase 4, and that `02-adapters.md` gets written then.
- [ ] Confirms no `rollout/` cards are created now — cards are scaffolded only in Phase 5, after
  the interview closes.

**Most likely to fail if the skill is broken:** the "does not re-ask settled questions" clause —
if the resume rule in `pre-rolling-wave-planning`'s Phase 4 (or its cross-reference from
`references/resume.md`'s phase table) has rotted, the agent will re-derive round 1/2 from scratch
instead of reading the existing transcript.

## Exercises

`SKILL.md` (router), `references/resume.md`, `skills/pre-rolling-wave-planning/SKILL.md`.
