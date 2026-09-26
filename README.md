# Rolling-wave planning

A skill family for running large software efforts with coding agents. It is for developers who ship real software, work in git, review diffs, and hand implementation to subagents.

You get an on-disk effort that survives a session exit, one file loaded per phase instead of the whole method, every skill and tool bound to a role in a file you can edit, a before-and-after flow diagram per feature so a PR can be reviewed without archaeology, and a verification ladder that says where the evidence is thin.

The unit of work is a **batch**: one directory holding the plan, the items, the features, the flows and the human verification passes.

## Quick start

### Install, path A: skills.sh

```sh
npx skills add dirghayu101/rolling-wave-planning --full-depth
```

`--full-depth` is required. Two skills are nested under `skills/`, and without the flag the CLI stops at the root `SKILL.md`. The CLI still asks which agents to install for; answer the menu once.

```sh
npx skills add <owner/repo> --list --full-depth          # see every skill, including nested ones
npx skills add <owner/repo> --full-depth --skill <name>  # one sub-skill from a repo subdirectory
npx skills list                                          # what is installed
npx skills update                                        # update installed skills
npx skills remove <name>                                 # uninstall
```

It installs into `~/.agents/skills` or `.claude/skills`, global or project-local, and supports Claude Code, Codex, Gemini CLI and Cursor. Docs: https://skills.sh

### Install, path B: clone and run the setup script

```sh
git clone https://github.com/dirghayu101/rolling-wave-planning
cd rolling-wave-planning
./setup.sh                  # macOS, Linux
```

```powershell
.\setup.ps1                 # Windows, PowerShell 7
```

The script links the skill entries into your skills directory (`~/.agents/skills` by default, `--skills-dir` to change), verifies that each link resolves, and reports which referenced skills and CLIs are present.

| Flag | What it does |
|---|---|
| `--claude` | also links into `~/.claude/skills`, the only directory Claude Code reads |
| `--check` | reports without changing anything |
| `--dry-run` | prints what would change and exits |
| `--force` | replaces a link that points somewhere else, and never deletes a real directory |

On Windows, a real symlink needs Developer Mode or an elevated shell; without either the script falls back to junctions, which load but do not appear in the Claude Code slash menu.

### First use

In a project, say what you want in your own words and invoke `pre-rolling-wave-planning`. It interviews you, then scaffolds the batch directory. From there `rolling-wave-planning` runs the batch. Quit at any point and say "continue the flow" to resume. The first batch also writes `adapters.default.md` at the project root.

## The problem

A solo, deadline-driven developer ships web, mobile and backend with agents. Three forces compound.

**The ecosystem churns.** Skills, models and tools change under you, so the best choice for a task is a moving target re-chosen by hand from memory.

**Context is the scarce resource.** Loading everything degrades the agent's reasoning and forces session exits, and work that lives only in a session dies with it.

**Trust is uneven.** Agents claim done without proof, so review time lands where it is not needed and skips where it is.

The skill answers with five things: an on-disk state machine resumed at constant cost; a router that loads one file per phase; a per-batch adapters file binding roles to the best available skill, tool or model; fresh-context subagents that load only their role's skills; and a verification ladder with two scores that directs attention where evidence is thin.

It assumes you work in git and delegate implementation to subagents. It assumes no particular model, harness, skill set or test framework. It is deliberately heavy for a one-hour change; the payoff starts when an effort spans several items and more than one session.

## What the record is, and is not

The record exists so an agent can resume and a human can review a PR. **It is not the product, and it is not reviewed.** Two layers, and only two:

- **LOG**, append-only and immutable: dispatch rows, evidence rows, review findings. Every entry carries the SHA it was true at, and is never edited, re-pinned or corrected. A fact that stopped being true gets a new entry below it.
- **HEAD**, rewritten in place and capped: `00-plan.md` STATE, a feature's stage line, scope, links, score, and exactly one resume block per item.

One writer. The orchestrator, or one light scribe it dispatches, writes the SSOT; subagents return facts and never edit it.

A reviewer is told, in the packet, that the feature file, the PR body, the flow file and the verification file are context and not subject matter, and that findings about them are not findings.

## Layout

```
<N>-<slug>/
  00-plan.md        STATE, decisions, testing plan, ledger, hand-back. 100 lines, hard cap.
  planning/         intake, acceptance, exploration, edge cases, blueprint, interview
  flows/            one file per feature: before and after Mermaid diagrams, written once
  verification/     the verification pass, run on dev: one file per feature or group
  runbooks/         the production stage: run by hand after the dev pass, plus 0-release.md
  agent/            adapters, cards, feature HEAD and LOG files, resume blocks, assets, harness
```

The developer opens the first five. `agent/**` is marked `linguist-generated` in the repo's `.gitattributes`, so GitHub collapses it in every PR diff. Files under `agent/` are sharded per feature and target 150 lines, so a subagent packet loads one card, one HEAD file and one LOG file, whatever the batch size.

## How a batch flows

```
 intake -> exploring -> edge-cases -> blueprint -> interview -> scaffolded -> executing -> done
 |                                                          |
 +--------------- pre-rolling-wave-planning ----------------+

   during executing, at both item and feature scope:

     open -> built -> reviewed -> merged        (merged is the agent terminal)

   later, once the dev pass rows are ticked:

     merged -> verified

   side state:

     paused <-> any phase
```

The pre-phases are owned by `pre-rolling-wave-planning`, which writes one checkpoint per phase under `planning/` and sets `phase:` **before** doing the phase's work. Everything from `scaffolded` onward is the lifecycle: items open one at a time, features are decomposed only when their item opens, and each stage change is a checklist gate.

**The agent's job ends at `merged`.** It delivers the batch branch with every feature merged and every agent-side check done, plus a hand-back list. Then the code is reviewed through the PRs, the dev pass runs on `verification/`, and `runbooks/` is worked through in order: merge the batch, run the migrations, release the dashboard, tag or ship the app. The ticks on `verification/` are what reach `verified`. No agent writes a verdict cell.

## Flows

At a feature's `open` gate a `light`-tier explorer draws the **before** diagram of the flow the feature will change, pinned to the base SHA. At PR ready it draws the **after**, pinned to the head SHA. Mermaid, one file per feature under `flows/`.

Every node names a file plus a function or symbol, which does not go stale, and carries a GitHub permalink at the pinned SHA, which never rots. **The file is written once and never edited.** A later feature that changes the same flow writes its own file; the older one is history. Details live in code comments, not in the flow file.

The flow file is the human's map for reviewing the PR, and the after diagram is embedded in the PR body.

## Review

**One fresh-eyes review per feature, at the PR.** Scope: the diff, the tests, and the L3 browser evidence. The security pass rides in the same packet when the card flags a sensitive surface. Findings go to a fresh fixer, then a scoped re-review. **Two passes maximum; a third means the packet was wrong**, so the packet gets fixed rather than the loop run again.

At the item PR one short `light`-tier integrity check asks three questions and nothing else: do the stage lines agree with the ledger, are all verdict cells still `open`, is every ephemera row swept. That is the whole of the process policing.

## Verification and confidence

- **L1 unit.** Each exit point of each changed unit behaves, test-first.
- **L2 integration.** Each seam is actually exercised, not mocked on both sides.
- **L3 real surface.** The surface a user touches is driven for real: rendered state asserted, console and network captured, **geometry and focus read** wherever layout or keyboard behavior changed, screenshots at every claimed breakpoint. This is the pass that finds real defects.
- **L4 cross-feature.** The item's features run together once every feature PR has merged, in the environment the plan names.
- **L5 human-only.** What no bound tool can perform or perceive.

A layer is climbed, not skipped. Evidence is always a pointer you can reopen, and every evidence entry carries the SHA it was true at.

Confidence is **one line**: `agent N / ceiling M`. `agent` is what the L1 to L4 evidence proves today; `ceiling` is the same judgement with every L5 row assumed PASS, and it is reached only by your ticks. No re-derivation prose, no history of the number, no dated chain.

A verification file has three parts: a walkthrough order over the flow file, a short replay section marked as sanity only that does not move the score, and the judgement rows only a human can make. Verdict cells are yours.

**Two stages: verify on dev, then deploy through the runbooks.** Stage one is the dev pass, and it needs no production access: every row runs on dev, from the batch branch served locally against the dev database, before any merge. There is no deployed preview to point at, because that would need the merge that comes after the pass. Stage two is `runbooks/`, the production stage and the only place production appears: migrations in order with preflight, apply, post-check and rollback, the dashboard release and its tag, the app tag or OTA, the version bump, all run by hand and never by an agent. A runbook's post-check is the production-side verification of the same flow. A check that can only run against production is a runbook step, not a verification row. While a dev pass is running, `00-plan.md` STATE carries a `verification_window:` line and no agent rebuilds or reseeds dev.

Every feature that needs a production step ships a numbered `runbooks/<k>-<slug>.md`: what it does in plain words, preflight, dry run, apply, post-check, rollback, known consequences. At the batch PR, `runbooks/0-release.md` sequences the whole release: merge order, the runbooks in order, the dashboard release and its tag, the app tag or OTA push, and the version bump. It links your project's release conventions rather than restating them.

## Adapters and roles

Two layers. **Project defaults** live at `<project root>/adapters.default.md`; **batch bindings** live at `agent/adapters.md` inside the batch directory, and that is the file packets read.

At kickoff the defaults are read, detection runs (CLIs via `command -v`, MCP servers by whether their tool names are visible in the harness right now, skills by reading frontmatter descriptions, stack by reading the project manifest), and the interview's final round presents **only the delta**.

Stable roles: `simplicity`, `tdd`, `debugging`, `flow-explorer`, `ui-guidelines`, `ui-implementation`, `browser-verification`, `mobile-verification`, `db-backend`, `security-review`, `code-map`, `review`. Two more are stack-conditional: `payments` and `framework`.

Tiers are bound the same way, by what the work needs. The skill never names a model; the bindings live only in the two adapters files:

| Tier | Used for |
|---|---|
| `orchestrator` | the session model: decomposition, packets, vetting, synthesis |
| `judge` | escalations on the triggers in `references/dispatch.md` § Escalating to the judge; inert when bound to the same model as `orchestrator` |
| `heavy` | hard implementation, fixes, review, security pass, drafting anything a human will execute |
| `light` | mapping, search, log reduction, mechanical edits, scripted flows, captures, flow diagrams, the integrity check |

**This repo ships no drivers.** It ships the role contract (`references/dispatch.md`) and the detection procedure (`references/adapters.md`). When a better browser tool lands, nothing in the kernel is wrong and the fix is one edited line in one batch file.

**Surface coverage.** Before the file is written, the batch's surfaces are read off the item cards and mapped to the tool that covers each. A surface with no tool becomes a dated decision: install it now, verify by hand instead, or accept the gap with a stated reason, which caps the `ceiling` for features on that surface.

## Concurrency

The orchestrator decides what runs in parallel. Only the constraints that always hold are written down: a branch holds one implementer; an in-flight feature that overlaps another gets its own git worktree; one dev server per worktree, started and killed by the packet that needs it; a feature that changes the schema runs exclusively; and a packet that assumes another in-flight feature's exports names them and the SHA it read them at, so a review finding that changes them means a rebase.

No model-specific, harness-specific or token-budget limits. Those change; these do not.

## Commits

Code and tests commit as they land. `agent/` files commit at gates only: feature `merged`, and the item PR. `flows/`, `verification/` and `runbooks/` ride the feature PR that produced them. **Never a commit whose whole diff is a record edit, made between gates.** Read history with `git log --first-parent`.

## Migrating an older batch

A batch whose STATE reads `layout: v1` or `layout: v2` is migrated once, not run in place. `references/migration-3.md` is the ordered procedure: the moves, the split of each working file into one resume block plus LOG entries, the strip of dated corrections and `Previously:` chains, the `.gitattributes` line, and the three commits to make.

## Tests

Fresh-agent scenarios live under `tests/scenarios/`. Each hands a brand-new `light`-tier subagent nothing but the scenario's prompt and an absolute path to a fresh copy of a fixture from `tests/fixtures/`. The subagent ends its answer with a list of every file it opened, and the orchestrator grades that written answer against the scenario's checklist by reading the transcript. There is no runner script by design: a script that drove the subagent or parsed its output would test the harness, not the skill.

The installer has its own runner, `tests/setup/run.sh`, which executes both setup scripts inside Docker containers.

The acceptance checklist for this release is `tests/acceptance/v3-criteria.md`: the agent fills the evidence column, the developer fills the verdict column, and the tag waits for that.

## Versioning

Semver. `VERSION` holds the current release, `CHANGELOG.md` records what each release changed, and every release is a git tag. Work deliberately parked sits in `TODO.md`.

Pin a version by installing from a tag:

```sh
git clone --branch v2.6.0 git@github.com:dirghayu101/rolling-wave-planning.git
```

Read `CHANGELOG.md` for what a newer release breaks before you move forward.

## License

MIT. See `LICENSE`.
