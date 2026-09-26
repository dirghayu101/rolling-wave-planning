# v3 acceptance criteria

One row per thing the 3.0.0 release must hold. The agent fills **Evidence** with a pointer
something can be reopened from: a file and section, a command with its output, a scenario run.
The developer fills **Verdict**. `v3.0.0` is tagged only when every verdict reads PASS or ACCEPTED.

An agent never writes in the Verdict column. Every row starts `open`.

| # | Must hold | Where it lives | Evidence | Verdict |
|---|---|---|---|---|
| 1 | The layout is v3: five directories the developer opens (`00-plan.md`, `planning/`, `flows/`, `verification/`, `runbooks/`) and `agent/` for every piece of machinery | `references/ssot-layout.md`, `templates/00-plan.md` | | open |
| 2 | `agent/` holds `adapters.md`, `<n>-<item>/0-card.md`, a HEAD file and a `.log.md` per feature, exactly one `resume.md` per item, plus `assets/` and `harness/` | `references/ssot-layout.md`, `templates/feature.md` | | open |
| 3 | `00-plan.md` is capped at 100 lines, carries `layout: v3` in STATE and a § Hand-back section listing what the developer owes | `templates/00-plan.md`, `references/ssot-layout.md` | | open |
| 4 | The scaffold adds one `.gitattributes` line marking `agent/**` generated, so GitHub collapses the machinery in every PR diff | `skills/pre-rolling-wave-planning/SKILL.md` Phase 5, `references/ssot-layout.md` | | open |
| 5 | Four stages, at both feature and item scope: `open`, `built`, `reviewed`, `merged`, plus `blocked` and `deferred`. `merged` is the agent terminal; `verified` is set only from the ticks in `verification/` | `references/lifecycle.md` | | open |
| 6 | The retired stage names appear nowhere as live vocabulary: `pending`, `in-progress`, `agent-verified`, `documented`, `complete`, `code-done` | every reference, template and fixture | | open |
| 7 | Every feature carries `flows/<n>.<f>-<slug>.md` with a before and an after Mermaid diagram, each node naming a file plus a symbol and carrying a permalink pinned to a SHA, written once and never edited | `templates/flow.md`, `references/lifecycle.md` feature gates | | open |
| 8 | The `flow-explorer` role exists, runs at `light` tier, and is dispatched at the feature `open` gate and again when the PR is ready | `references/dispatch.md`, `templates/02-adapters.md` | | open |
| 9 | Exactly one review per feature, on the feature PR, by an agent that did not write the code, with a hard limit of two passes | `references/review.md` | | open |
| 10 | The reviewer packet states, in those words, that the feature file, the PR body, the flow file and the verification file are context and not subject matter, and that findings about them are not findings | `references/review.md` § The record is not reviewable material | | open |
| 11 | The verification file has three parts (walkthrough over the flow file, replay that explicitly does not move the score, judgement rows), every verdict cell reads `open` when the agent hands over, and every row carries the exact query or command to run by hand | `templates/verification-feature.md`, `references/verification.md` | | open |
| 12 | Confidence is one line, `Confidence: agent N / ceiling M`, overwritten in place, with no re-derivation prose, no history and no dated chain | `references/verification.md`, `templates/feature.md` | | open |
| 13 | The record splits into LOG and HEAD and nothing else: LOG is append-only with the SHA on every entry and is never edited or re-pinned; HEAD is rewritten in place and never grows an addendum or a superseding section | `SKILL.md` § Core principles, `templates/feature.md`, `references/ssot-layout.md` | | open |
| 14 | One short `light`-tier integrity check runs at the item PR, asking three questions and nothing else, read-only, and is not a review | `templates/integrity-check.md`, `references/review.md` | | open |
| 15 | What 3.0.0 removed is gone from the skill and its templates: `01-verification.md`, `working/<item>.agent.md`, the `docs/` docset with its `docs-conventions` and `docs-verify` roles, the audit ceremony and its packet, confidence re-derivation prose, and dated corrections inside `agent/` files | the whole repo | | open |
| 16 | What 3.0.0 kept is intact: ceremony and the PR ladder, the pause protocol, execution-slot numbering, the resume integrity sweep, TDD as the fixed default, the adapters file with roles and tiers, the acceptance list, the batch Testing plan, and the packet Ephemera slot | `references/ceremony.md`, `references/resume.md`, `references/lifecycle.md`, `references/dispatch.md` | | open |
| 17 | Commit rules hold: code and tests commit as they land; `agent/` files commit at gates only; `flows/`, `verification/` and `runbooks/` ride the feature PR; no commit whose whole diff is a record edit between gates | `references/lifecycle.md` § Commits, `references/ceremony.md` | | open |
| 18 | The concurrency constraints are stated and are the only ones: one implementer per branch, a worktree for an overlapping in-flight feature, one dev server per worktree, a schema feature running exclusively, and a packet naming the in-flight exports it assumes with the SHA it read them at | `references/dispatch.md` § Concurrency | | open |
| 19 | A v1 or v2 batch is migrated once, by `references/migration-3.md`, and never run in place | `SKILL.md` router rules, `references/migration-3.md` | | open |
| 20 | The repo is materially smaller than 2.6.0: fewer files and fewer total lines, with the drop accounted for by what 3.0.0 removed rather than by detail silently lost | `git diff --stat daad1ec..HEAD` (the last commit before the rewrite; 2.6.0 was never committed or tagged), `CHANGELOG.md` 3.0.0 | | open |
| 21 | No em dash appears anywhere in the repo | a repo-wide grep for the character | | open |
| 22 | All eight release-gate scenarios pass against the v3 fixtures, each graded from a fresh subagent's written answer | `tests/README.md`, `tests/scenarios/*` | | open |
| 23 | No verification file names production: no production console, no production credential, no `*:prod` command, no migration push, and no production post-check copied in as a human row. Every row runs on dev, against the app started locally from the batch branch | `references/verification.md` § Two stages, `templates/verification-feature.md`, `skills/human-assisted-verification/SKILL.md`, and every `verification/` file in a batch | | open |
| 24 | A batch PR does not open without `runbooks/0-release.md`, and every feature with a production step carries its own numbered `runbooks/<k>-<slug>.md` | `references/lifecycle.md` batch scope and the `reviewed → merged` gate, `templates/release-runbook.md`, `templates/runbook.md` | | open |

## Checks worth running before filling the evidence column

These are starting points, not the whole evidence. A row is satisfied by what the check shows, not
by the check having been run.

- `wc -l <batch dir>/00-plan.md` against the 100-line cap, and `wc -l` over `agent/` files against
  the 150-line target.
- `grep -rniE '\b(pending|in-progress|agent-verified|documented|code-done)\b'` across `references/`,
  `templates/`, `skills/` and `tests/fixtures/`, then judge each hit: a testing-plan status cell
  reading `pending` is correct, a stage line reading `pending` is not.
- `grep -rn '01-verification|working/|docs-verify|docs-conventions|audit-handoff|doc-handoff'` over
  the repo, which must return nothing outside `CHANGELOG.md`.
- `grep -rn $'\xe2\x80\x94' .` for row 21.
- `grep -rniE 'prod|production|:prod|migrate:prod' <batch dir>/verification/` for row 23, which must return nothing but a line saying production evidence lives in a runbook. Then read the `Check it yourself` column of every row and confirm each target is dev. While a pass is running, `00-plan.md` STATE carries a `verification_window:` line and no agent rebuilds dev.
- `ls <batch dir>/runbooks/0-release.md` at the batch PR for row 24, and one `runbooks/<k>-<slug>.md` per feature whose card or migration says it needs a production step.
- `git diff --stat daad1ec..HEAD` for row 20. There is no `v2.6.0` tag: that version was written and never released, and its changelog entry was absorbed into 3.0.0.
- `git check-attr linguist-generated -- <batch dir>/agent/adapters.md` for row 4.

## Scenario runs

One line per scenario run, appended as each is graded. The verdict column above for row 22 stays
`open` until all eight read PASS.

| Scenario | Run on | Graded by | Result | Notes |
|---|---|---|---|---|
| 01 cold resume | | | open | |
| 02 quit mid-interview | | | open | |
| 03 dispatch packet shape | | | open | |
| 04 verification file shape | | | open | |
| 05 problem fit | | | open | |
| 06 testing plan shape | | | open | |
| 07 acceptance from the rant | | | open | |
| 08 ephemera and integrity check | | | open | |
