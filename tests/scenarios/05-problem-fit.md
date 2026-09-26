# Scenario 5: Problem fit

Unlike scenarios 1 to 4, this one exercises no fixture batch: it checks that the repo's own front
door explains itself correctly to a cold reader.

## Fixture

None. The "fixture" is the repo itself, restricted to two files: `README.md` and `SKILL.md` at the
repo root.

## Prompt

Give the fresh agent exactly this, filling `<REPO>` with the absolute path to the repo root:

> Read only `<REPO>/README.md` and `<REPO>/SKILL.md`. Do not open, list, or grep any other file
> or directory in `<REPO>` or anywhere else. Then answer, from those two files alone: (1) what
> problem this repo solves, (2) who it is for, (3) by what mechanism it solves that problem, (4)
> what the record is and is not, and (5) if you were resuming a paused batch, what you would load,
> naming one file per phase. Do not open anything under the skill repo's `tests/` directory. End
> your answer with a list titled "Files I read" naming every file you opened.

## Pass criteria

- [ ] "Files I read" contains exactly `README.md` and `SKILL.md`. No `references/*`, `templates/*`
  or `skills/*` file, and no directory listing beyond what the agent's own file-read tool reports
  opening.
- [ ] The problem answer names the three forces from the README § The problem: the ecosystem churns
  (the best tool, skill or model is a moving target re-chosen from memory), context is the scarce
  resource (loading everything degrades reasoning and forces session exits), and trust is uneven
  (agents claim done without proof, so review time lands in the wrong place). Not a paraphrase
  that drops one of the three or invents a fourth.
- [ ] The "who it is for" answer matches the README's opening paragraph: a developer who ships real
  software, works in git, reviews diffs, and hands implementation to subagents, across more than
  one session.
- [ ] The mechanism answer names the five things the README lists as the answer: an on-disk state
  machine resumed at constant cost, a router that loads one file per phase, a per-batch adapters
  file binding roles to the best available skill, tool or model, fresh-context subagents that load
  only their role's skills, and a verification ladder with two scores. Not just "it uses a router
  and some templates".
- [ ] The record answer names the two layers and gets them the right way round: LOG is append-only
  and immutable with a SHA on every entry, HEAD is rewritten in place and capped. It also says the
  record is not the product and is not reviewed.
- [ ] The resume answer names one file per phase, matching the router's phase table in `SKILL.md`:
  `pre-rolling-wave-planning` for `intake` through `interview`, `references/lifecycle.md` for
  `scaffolded` and `executing`, `references/resume.md` for `paused`, `references/verification.md`
  for `done`. It also says a resume loads `references/resume.md` first, before the phase row. Not
  a made-up file name and not "it depends, read everything".

**Most likely to fail if the skill is broken:** the three-forces clause. A README that has drifted
from `SKILL.md`'s actual behaviour will still let the agent recite a plausible problem statement,
but the per-phase file list is what exposes the drift, since it must match `SKILL.md`'s table
exactly.

## Exercises

`README.md`, `SKILL.md`.
