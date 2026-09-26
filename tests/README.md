# Release-gate scenarios

Eight fresh-agent scenarios must pass before tagging `v3.0.0`. This directory holds the scenario
prompts and the fixtures they run against; there is deliberately **no runner script**.

The release checklist itself is `acceptance/v3-criteria.md`: one row per thing 3.0.0 must hold,
with an evidence column the agent fills and a verdict column the developer fills.

## How a scenario runs

1. The orchestrator (whoever is cutting the release) launches a **fresh light-tier subagent** with
   no prior context and no memory of this repo work.
2. The subagent receives **only** the scenario's `## Prompt` text and an absolute path to a fresh
   copy of the fixture named in `## Fixture`. It is not shown this README, the plan, or any other
   scenario.
3. The subagent does the task the prompt describes, then ends its answer with a list titled
   **"Files I read"** naming every file it opened.
4. The orchestrator (not the subagent) grades the scenario's `## Pass criteria` checklist against
   the subagent's written answer, never against what the orchestrator assumes happened.
5. A run whose "Files I read" list includes anything under this repo's `tests/` directory is void:
   the scenario file is the answer key. Re-run with a fresh agent; do not grade it.
6. A release is tagged only when **all eight** scenarios pass. A failing scenario is a bug in the
   skill repo (`SKILL.md`, a `references/*.md` file, a template, or a sub-skill), not in the
   fixture: fix the repo, rerun the scenario fresh (a new subagent, not the same one continuing).

## Scenarios

| # | Scenario | Fixture | What it pressures |
|---|---|---|---|
| 01 | [Cold resume](scenarios/01-cold-resume.md) | `12-notifications` | O(1) resume: the single resume block, per-item sharding, the integrity sweep, the four stage names |
| 02 | [Quit mid-interview](scenarios/02-quit-mid-interview.md) | `13-onboarding` | Pausing and resuming inside a pre-planning phase; the testing round and the adapter round that writes `agent/adapters.md` |
| 03 | [Dispatch packet shape](scenarios/03-dispatch-packet-shape.md) | `12-notifications` | The eight packet slots, exactly three SSOT paths, role resolution, tiers instead of vendor names, and the separate `flow-explorer` dispatch at the feature `open` gate |
| 04 | [Verification file shape](scenarios/04-verification-file-shape.md) | `12-notifications` | The three-part L5 file (walkthrough, replay, judgement), zero agent steps, verdicts left `open`, and the one-line confidence |
| 05 | [Problem fit](scenarios/05-problem-fit.md) | none (the repo's own front door) | Whether `README.md` and `SKILL.md` still explain the problem, the record split and the router truthfully |
| 06 | [Testing plan shape](scenarios/06-testing-plan-shape.md) | `12-notifications` | Where item-level, cross-item and end-to-end testing live, and that the environment is not the tool bindings |
| 07 | [Acceptance list from the rant](scenarios/07-acceptance-from-the-rant.md) | none (empty dir) | Phase 0 turning the rant into `planning/00-acceptance.md` in the developer's words, its implicit rows, and what Phase 5 scaffolds |
| 08 | [Ephemera and the integrity check](scenarios/08-ephemera-and-integrity-check.md) | `12-notifications` | The packet Ephemera slot bound to the scratch root, the `## Ephemera` table in the feature log, and the three-question item-PR check |

## Why no runner script

The thing being tested is whether a **cold, unaided agent**, reading only what the skill repo
itself tells it to read, behaves correctly. A script that drove the subagent, fed it extra context,
or parsed its output for grading would test the harness, not the skill. Grading is a judgment call
(did it read the right files, in the right order, and stop at the right point) that an orchestrator
makes by reading the transcript, the same way a human reviewer would.

## Fixtures

Both fixtures are built from this repo's own `templates/*` and carry `layout: v3`.

`fixtures/12-notifications/` is a batch mid-execution. It has the full v3 tree: `00-plan.md` under
the 100-line cap with a § Hand-back section, `planning/`, two `flows/` files, two `verification/`
files with every verdict cell reading `open`, and `agent/` holding `adapters.md`, nine item
directories, a HEAD and a `.log.md` per built feature, and one `resume.md` for the open item. Nine
items: 1 to 3 `merged`, 4 `open` (4.1 `merged`, 4.2 `reviewed`, 4.3 not opened), 5 to 9 `open` and
not started.

`fixtures/13-onboarding/` is a pre-scaffold batch, stopped mid-interview at round 2 of 4. It has
`00-plan.md` and `planning/` only: no `agent/` directory, no adapters file, no cards.

Before a run, copy the fixture to a scratch directory and hand the runner that absolute path as
`<FIXTURE>`: runs must never modify the committed fixture, and a runner given a relative path will
guess, so every prompt states the fixture's path explicitly.

Scenarios 05 and 07 are the exceptions. Scenario 05 reads the repo's own `README.md` and `SKILL.md`
and nothing else. Scenario 07 gets a fresh empty directory, because Phase 0 starts from nothing.
