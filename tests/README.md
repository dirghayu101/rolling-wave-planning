# Release-gate scenarios

Eight fresh-agent scenarios must pass before tagging `v2.0.0` (plan decision 8, § 19, plus scenario
06 added 2026-09-17 and scenarios 07 and 08 added 2026-09-17 for the acceptance list, the ephemera
sweep and the audit pass). This directory holds the scenario prompts and fixtures; there is
deliberately **no runner script**.

## How a scenario runs

1. The orchestrator (Fable, or whoever is cutting the release) launches a **fresh light-tier
   subagent** with no prior context and no memory of this repo work.
2. The subagent receives **only** the scenario's `## Prompt` text and the fixture path named in
   `## Fixture`. It is not shown this README, the plan, or any other scenario.
3. The subagent does the task the prompt describes, then ends its answer with a list titled
   **"Files I read"** naming every file it opened.
4. The orchestrator (not the subagent) grades the scenario's `## Pass criteria` checklist against
   the subagent's written answer, never against what the orchestrator assumes happened.
5. A run whose "Files I read" list includes anything under this repo's `tests/` directory is void:
   the scenario file is the answer key. Re-run with a fresh agent; do not grade it.
6. A release is tagged only when **all eight** scenarios pass. A failing scenario is a bug in the
   skill repo (SKILL.md, a `references/*.md` file, a template, or a sub-skill), not in the
   fixture: fix the repo, rerun the scenario fresh (a new subagent, not the same one continuing).

## Scenarios

| # | Scenario | Fixture | What it pressures |
|---|---|---|---|
| 01 | [Cold resume](scenarios/01-cold-resume.md) | `12-notifications` | O(1) resume: the per-item sharding rule and the integrity sweep |
| 02 | [Quit mid-interview](scenarios/02-quit-mid-interview.md) | `13-onboarding` | Pausing and resuming inside a pre-planning phase |
| 03 | [Dispatch packet shape](scenarios/03-dispatch-packet-shape.md) | `12-notifications` | The seven packet slots, role resolution, tiers instead of vendor names |
| 04 | [Verification file shape](scenarios/04-verification-file-shape.md) | `12-notifications` | L5 files with zero agent steps and verdicts left `open` |
| 05 | [Problem fit](scenarios/05-problem-fit.md) | `13-onboarding` | Refusing to scaffold a batch for work that is not a batch |
| 06 | [Testing plan shape](scenarios/06-testing-plan-shape.md) | `12-notifications` | Where item-level, cross-item and end-to-end testing live |
| 07 | [Acceptance list from the rant](scenarios/07-acceptance-from-the-rant.md) | none (empty dir) | Phase 0 turning the rant into `planning/00-acceptance.md`, in the developer's words |
| 08 | [Ephemera slot and audit trigger](scenarios/08-ephemera-and-audit.md) | `12-notifications` | The packet Ephemera slot, the working-file ledger, and the audit packet firing on its trigger |

## Why no runner script

The thing being tested is whether a **cold, unaided agent**, reading only what the skill repo
itself tells it to read, behaves correctly. A script that drives the subagent, feeds it extra
context, or parses its output for grading would test the harness, not the skill. Grading is a
judgment call (did it read the right files, in the right order, and stop at the right point) that
a orchestrator makes by reading the transcript, the same way a human reviewer would.

## Fixtures

`fixtures/12-notifications/` and `fixtures/13-onboarding/` (built from this repo's own
`templates/*`) live under `tests/fixtures/` in this repo. Before a run, copy the fixture to a
scratch directory and hand the runner that absolute path as `<FIXTURE>`: runs must never modify the
committed fixture, and a runner given a relative path will guess, so every prompt states the
fixture's path explicitly.

Scenario 07 is the exception: it has no fixture. The orchestrator creates an empty scratch
directory and passes that path, because Phase 0 starts from nothing.

Corrected 2026-09-17: the count read "Six" and "all six" before scenarios 07 and 08 were added, and
the Fixtures paragraph ended in a dangling fragment ("fixture's path explicitly in its prompt.") left
over from an earlier edit; the sentence is now closed where it belongs. The root `README.md` § Tests
was corrected the same day: eight scenarios, with rows 07 and 08 in its findings table.
