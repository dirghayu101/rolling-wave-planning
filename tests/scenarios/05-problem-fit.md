# Scenario 5 — Problem fit

Per plan § 19. Unlike scenarios 1-4, this one exercises no fixture batch: it checks that the
repo's own front door explains itself correctly to a cold reader.

## Fixture

None. The "fixture" is the repo itself, restricted to two files: `README.md` and `SKILL.md` at
the repo root (`/Users/joshi/.agents/skills/rolling-wave-planning/`).

## Prompt

Give the fresh agent exactly this, filling `<REPO>` with the absolute path to the repo root:

> Read only `<REPO>/README.md` and `<REPO>/SKILL.md`. Do not open, list, or grep any other file
> or directory in `<REPO>` or anywhere else. Then answer, from those two files alone: (1) what
> problem this repo solves, (2) who it is for, (3) by what mechanism it solves that problem, and
> (4) if you were resuming a paused batch, what you would load, naming one file per phase. End
> your answer with a list titled "Files I read" naming every file you opened.

## Pass criteria

- [ ] "Files I read" contains exactly `README.md` and `SKILL.md` — no `references/*`,
  `templates/*`, or `skills/*` file, and no directory listing beyond what the fresh agent's own
  file-read tool reports opening.
- [ ] The problem answer names the three forces from the README's "The problem" section:
  the ecosystem churns (best tool/skill/model choice is a moving target), context is the scarce
  resource (loading everything degrades reasoning and forces session exits), and trust is uneven
  (agents claim done without proof, so review time lands in the wrong place) — not a paraphrase
  that drops one of the three or invents a fourth.
- [ ] The "who it is for" answer matches the README's opening paragraph (corrected 2026-09-16:
  the "Who this is for" heading became the lede when setup moved to the top): a developer shipping
  real software with agents across more than one session, who works in git and delegates
  implementation to subagents.
- [ ] The mechanism answer names the five things the README lists as the answer: an on-disk state
  machine resumed at constant cost, a router loading one file per phase, a per-batch adapters
  file binding roles to skills/tools/models, fresh-context subagents loading only their role's
  skills, and a two-score verification ladder — not just "it uses a router and some templates".
- [ ] The resume answer names one file per phase, matching the router's phase table in
  `SKILL.md` (`pre-rolling-wave-planning` for the pre-phases, `references/lifecycle.md` for
  `scaffolded`/`executing`, `references/resume.md` for `paused`, `references/verification.md`
  for `done`) — not a made-up file name and not "it depends, read everything".

**Most likely to fail if the skill is broken:** the three-forces clause — a README that has
drifted from `SKILL.md`'s actual behavior (for example, claiming a router file it no longer
loads) will still let the agent recite a plausible-sounding problem statement, but the per-phase
file list is what exposes the drift, since it must match `SKILL.md`'s table exactly.

## Exercises

`README.md`, `SKILL.md`.
