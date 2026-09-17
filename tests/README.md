# Release-gate scenarios

Six fresh-agent scenarios must pass before tagging `v2.0.0` (plan decision 8, § 19, plus scenario 06 added 2026-09-17). This
directory holds the scenario prompts and fixtures; there is deliberately **no runner script**.

## How a scenario runs

1. The orchestrator (Fable, or whoever is cutting the release) launches a **fresh light-tier
   subagent** with no prior context and no memory of this repo work.
2. The subagent receives **only** the scenario's `## Prompt` text and the fixture path named in
   `## Fixture`. It is not shown this README, the plan, or any other scenario.
3. The subagent does the task the prompt describes, then ends its answer with a list titled
   **"Files I read"** naming every file it opened.
4. The orchestrator (not the subagent) grades the scenario's `## Pass criteria` checklist against
   the subagent's written answer, never against what the orchestrator assumes happened.
5. A release is tagged only when **all six** scenarios pass. A failing scenario is a bug in the
   skill repo (SKILL.md, a `references/*.md` file, a template, or a sub-skill), not in the
   fixture: fix the repo, rerun the scenario fresh (a new subagent, not the same one continuing).

## Why no runner script

The thing being tested is whether a **cold, unaided agent**, reading only what the skill repo
itself tells it to read, behaves correctly. A script that drives the subagent, feeds it extra
context, or parses its output for grading would test the harness, not the skill. Grading is a
judgment call (did it read the right files, in the right order, and stop at the right point) that
a orchestrator makes by reading the transcript, the same way a human reviewer would.

## Fixtures

`fixtures/12-notifications/` and `fixtures/13-onboarding/` (built from this repo's own
`templates/*`) live under `tests/fixtures/` in this repo. Before a run, copy the fixture to a scratch directory and hand the runner that absolute path as `<FIXTURE>`: runs must never modify the committed fixture, and a runner given a relative path will guess.
fixture's path explicitly in its prompt.
