# Rolling-wave planning

A skill family for running large software efforts with coding agents. It is for developers
who ship real software, work in git, review diffs, and hand implementation to subagents.
You get an on-disk effort that survives a session exit, one file loaded per phase instead
of the whole method, every skill and tool bound to a role in a file you can edit, and a
five-level verification ladder that shows where the evidence is thin.

The unit of work is a **batch**: one directory holding the plan, the items, the features,
the verification checklists and the reader documentation.

## Quick start

### Install, path A: skills.sh

```sh
npx skills add dirghayu101/rolling-wave-planning --full-depth
```

`--full-depth` is required. Five skills are nested under `skills/`, and without the flag
the CLI stops at the root `SKILL.md` and never sees them (verified 2026-09-16 with
`--list`). The CLI still asks which agents to install for, even with `-y`; answer the menu
once.

The root skill is the router. The other five sit under `skills/`, two of them inside the
`mentor-documentation-system` bundle, and the harness does not auto-discover nested skills.

The rest of the CLI:

```sh
npx skills add <owner/repo> --list --full-depth          # see every skill, including nested ones
npx skills add <owner/repo> --full-depth --skill <name>  # one sub-skill from a repo subdirectory
npx skills list                                          # what is installed
npx skills update                                        # update installed skills
npx skills remove <name>                                 # uninstall
```

It installs into `~/.agents/skills` or `.claude/skills`, global or project-local, and
supports Claude Code, Codex, Gemini CLI and Cursor. Docs: https://skills.sh and
https://github.com/vercel-labs/skills

### Install, path B: clone and run the setup script

Clone anywhere you like, then run the script for your platform:

```sh
git clone https://github.com/dirghayu101/rolling-wave-planning
cd rolling-wave-planning
./setup.sh                  # macOS, Linux
```

```powershell
.\setup.ps1                 # Windows, PowerShell 7
```

The script links the six skill entries into your skills directory (`~/.agents/skills` by
default, `--skills-dir` to change), verifies that each link resolves, reports which
referenced skills are present or missing with the install command for each, and reports
which of `agent-browser`, `graphify`, `node` and `git` are on PATH.

| Flag | What it does |
|---|---|
| `--claude` | also links into `~/.claude/skills`, the only directory Claude Code reads |
| `--check` | reports without changing anything; the health check after either install path |
| `--dry-run` | prints what would change and exits |
| `--force` | replaces a link that points somewhere else, and never deletes a real directory |

Claude Code reads personal skills from `~/.claude/skills/<skill-name>/SKILL.md`
(https://code.claude.com/docs/en/skills.md) and follows symlinked skill folders, so
`--claude` is what makes the family visible there.

On Windows, a real symlink needs Developer Mode enabled or an elevated shell. Without
either, the script falls back to junctions. Junctions load the skill, but it will not
appear in the Claude Code desktop slash menu: see github.com/anthropics/claude-code issue
37590.

### Which directory your harness reads

| Directory | Read by |
|---|---|
| `~/.claude/skills`, `.claude/skills` | Claude Code |
| `~/.agents/skills` | Codex, Gemini CLI, Copilot CLI |

### First use

In a project, say what you want in your own words and invoke `pre-rolling-wave-planning`.
It interviews you, then scaffolds the batch directory. From there `rolling-wave-planning`
runs the batch. Quit at any point and say "continue the flow" to resume. The first batch
also writes `adapters.default.md` at the project root.

## Referenced skills

Every skill named anywhere in the kernel, with where it comes from. Names on packets are
resolved through `02-adapters.md`, so treat the defaults below as defaults, not
requirements. `./setup.sh --check` prints this list with present or missing per skill.

**Ships in this repo.** Invoked by name, never read as files.

| Skill | Role it fills |
|---|---|
| `rolling-wave-planning` | the router and the kernel itself |
| `pre-rolling-wave-planning` | phases 0 to 5: intake, exploration, edge cases, blueprint, interview, scaffold |
| `human-assisted-verification` | writes the L5 human-only rows |
| `human-engineering-docs` | the `docs-conventions` role: reader-facing chapters, one per feature |
| `senior-mentor` | teaching and post-task explanation; ships in the `mentor-documentation-system` bundle, not called by the kernel |
| `mentor-documentation-system` | the bundle holding the two skills above |

**Superpowers plugin.** Namespaced in the harness listing.

| Skill | Role it fills |
|---|---|
| `superpowers:test-driven-development` | default for the `tdd` role |
| `superpowers:systematic-debugging` | alternative for the `debugging` role |
| `superpowers:requesting-code-review` | default for the `review` role |
| `superpowers:receiving-code-review` | carried by the agent that fixes review findings |
| `superpowers:brainstorming` | used in the pre-phases for genuinely fuzzy feature shapes |
| `feature-dev:code-reviewer` | alternative for the `review` role |
| `frontend-design:frontend-design` | default for the `ui-implementation` role |

**Installed separately, typically via skills.sh.**

| Skill | Role it fills |
|---|---|
| `ponytail` | the `simplicity` role, on every implementer packet |
| `systematic-debugging` | default for the `debugging` role |
| `ui-ux-pro-max` | default for `ui-guidelines`, lookup only during blueprint |
| `adhd-design-expert`, `web-design-guidelines`, `shadcn`, `shadcn-ui` | alternatives for the UI roles |
| `agent-browser` | default for `browser-verification` |
| `supabase` | default for `db-backend` |
| `supabase-security` | default for `security-review` |
| `supabase-postgres-best-practices` | alternative for both database roles |
| `documentation-writer` | alternative for `docs-conventions` |
| `stripe-best-practices`, `stripe-projects` | the `payments` role |
| `next-best-practices`, `next-cache-components`, `vercel-react-best-practices`, `tanstack-query-best-practices` | the `framework` role on a Next.js manifest |
| `vercel-react-native-skills`, `react-native-animations`, `expo-cicd-workflows`, `sentry-react-native-sdk` | the `framework` role on a React Native or Expo manifest |
| `grilling` | the interview method in phase 4 |
| `grill-with-docs` | user-invoked only, for decisions that deserve durable ADRs |
| `dispatching-parallel-agents` | parallel exploration packets in phase 1 |
| `subagent-driven-development` | the shape of the review and fix loop |
| `efficient-fable` | the handoff-packet craft that `references/dispatch.md` points at |
| `graphify` | the `code-map` role |

`graphify` is the exception to the table above. `graphify install` writes it as a global
skill into your skills directory rather than adding it as a skill repo, and Claude Code
users link it from there into `~/.claude/skills`.

**Harness built-in.** `security-review`, listed as an alternative for the
`security-review` role.

## The problem

A solo, deadline-driven developer ships web, mobile and backend with agents. Three forces
compound.

**The ecosystem churns.** Skills, models and tools change under you, so the best choice
for a given task is a moving target that gets re-chosen by hand, every time, from memory.

**Context is the scarce resource.** Loading everything degrades the agent's reasoning and
forces session exits, and work that lives only in a session dies with it.

**Trust is uneven.** Agents claim done without proof, so review time lands where it is not
needed and skips the places where it is.

The skill answers with five things:

1. An on-disk state machine resumed at constant cost.
2. A router that loads one file per phase.
3. A per-batch adapters file binding roles to the best available skill, tool or model.
4. Fresh-context subagents that load only their role's skills.
5. A verification ladder with two scores that directs attention where evidence is thin.

It assumes you work in git and delegate implementation to subagents. It assumes no
particular model, harness, skill set or test framework. It is deliberately heavy for a
one-hour change; the payoff starts when an effort spans several items and more than one
session.

## Kernel plus drivers

The kernel is the part that does not change: the SSOT directory layout, the router, the
lifecycle stages, and the gate checklists between them. It is small. `SKILL.md` is 57
lines and the largest reference file is 157.

Everything else is a driver. The browser tool, the mobile tool, the database inspector,
the TDD skill, the review skill, the docs writer, the code map, the model behind each
tier: all of them are detected at kickoff and bound to a **role** in the batch's
`02-adapters.md`. The kernel names roles and tiers (`judge`, `heavy`, `light`) and never
products. A packet resolves `simplicity` or `browser-verification` against that file, and
the subagent invokes whatever skill the row names.

**This repo ships no drivers.** It ships the role contract (`references/dispatch.md`) and
the detection procedure (`references/adapters.md`). That is the whole reason the skill can
stay this small while the ecosystem churns: when a better browser tool lands, nothing in
the kernel is wrong, and the fix is one edited line in one batch file. Skills are named on
packets, never paraphrased into this repo, so an updated skill takes effect immediately
instead of being forked into stale prose here.

## How a batch flows

```
 intake -> exploring -> edge-cases -> blueprint -> interview -> scaffolded -> executing -> done
 |                                                          |
 +--------------- pre-rolling-wave-planning ----------------+

   during executing:

     item    : pending -> in-progress -> agent-verified -> documented -> complete
     feature : pending -> in-progress -> reviewed -> agent-verified -> documented -> merged

   side state:

     paused  <-> any phase   (STATE keeps the phase, adds a PAUSED line and "Resume here:")
```

The pre-phases are owned by the `pre-rolling-wave-planning` sub-skill, which writes one
checkpoint file per phase under `planning/` and sets `phase:` in `00-plan.md` **before**
doing the phase's work. Everything from `scaffolded` onward is the lifecycle: items open
one at a time, features are decomposed only when their item opens, and each stage change
is a checklist gate, not a feeling.

Quit at any point and resume means something specific here. The phase is a field in the
STATE block of `00-plan.md`. The partial work of the current phase is in that phase's
checkpoint file: `planning/00-intake.md`, `planning/01-exploration.md`,
`planning/02-edge-cases.md`, `planning/03-blueprint/`, `planning/04-interview.md`. An
interview three rounds in resumes at round four with settled questions never re-asked, and
an exploration that dispatched two of five packets resumes with the other three.
During execution the ledger row and the feature index row are the program counter, and
`working/<item>.agent.md` holds the in-flight scratch for the open item. A resume reads
`00-plan.md`, runs an integrity sweep that compares every stage claim against the evidence
behind it, and states the next action before editing anything.

## What loads when

The router reads `00-plan.md`, takes the `phase:` field, and loads exactly one target.

| `phase:` | Loads | Lines today |
|---|---|---|
| `intake`, `exploring`, `edge-cases`, `blueprint`, `interview` | skill `pre-rolling-wave-planning` | 120 |
| `scaffolded` | `references/lifecycle.md` | 133 |
| `executing` | `references/lifecycle.md` | 133 |
| `paused` | `references/resume.md` | 78 |
| `done` | `references/verification.md`, promotion pass only | 157 |

The rest of the repo is reached only from inside one of those, at a named transition:

| Reached at | File | Lines today |
|---|---|---|
| a subagent dispatch | `references/dispatch.md` | 99 |
| a review point | `references/review.md` | 139 |
| a verification transition | `references/verification.md` | 157 |
| branch and PR work, once per item | `references/ceremony.md` | 152 |
| a screen in the blueprint phase | `references/blueprint.md` | 41 |
| kickoff, or a rebind mid-batch | `references/adapters.md` | 150 |
| scaffolding, or `layout: v1` | `references/ssot-layout.md` | 87 |
| writing the human-only rows | skill `human-assisted-verification` | 98 |

A resume reads `00-plan.md` plus one card, one feature file and one working file,
regardless of how many items the batch has. Nine items cost the same as three.

The context-budget argument is plain. Only a skill's frontmatter description sits in the
agent's context every turn, whether or not the skill fires; that is the cost you always
pay. The router body loads when the description matches. From there, each phase pulls one
file, and every other file in the repo stays out of context behind a pointer that names
the condition for reaching it. The design came out of an audit of nine real efforts where
a single growing plan file reached 700 to 1,400 lines and started degrading the agents
reading it, not just the humans.

## Adapters and roles

Two layers.

**Project defaults** live at `<project root>/adapters.default.md`, at the git root of the
project or monorepo. A project usually holds several feature and spec directories, each
with its own SSOT, so the root is the one place kickoff can find the defaults without
searching. It is the accumulated answer from earlier batches in the same project.

**Batch bindings** live at `02-adapters.md` inside the batch directory. That is the file
packets read, and it can diverge from the defaults for the life of one batch.

At kickoff the defaults file is copied in, detection runs (CLIs via `command -v`, MCP
servers by whether their tool names are visible in the harness right now, skills by
reading frontmatter descriptions, stack by reading the project manifest), and the
interview's final round presents **only the delta**: newly installed things that could
replace a binding, and bindings whose tool has gone missing. Unchanged rows carry over
silently. On the first batch in a project there is no defaults file, so the bindings come
from detection alone and are saved back as the new default.

The stable roles, from `references/dispatch.md`:

`simplicity`, `tdd`, `debugging`, `ui-guidelines`, `ui-implementation`,
`browser-verification`, `mobile-verification`, `db-backend`, `security-review`,
`docs-conventions`, `code-map`, `review`.

Two more roles are stack-conditional. They appear only when detection finds the dependency
in the project manifest: `payments` (a `stripe` dependency) and `framework` (a `next`,
`react-native` or `expo` dependency).

Tiers are bound the same way, by what the work needs rather than by a model name:

| Tier | Used for |
|---|---|
| `judge` | conflicting evidence, design calls, grading a gate |
| `heavy` | hard implementation, review, security pass, rogue-check, docs drafting |
| `light` | mapping, search, log reduction, mechanical edits, scripted flows, screenshots |

Swapping a driver is one line. The `ui-implementation` row ships with
`frontend-design:frontend-design` as its default, with `ui-ux-pro-max`,
`adhd-design-expert`, `shadcn`, `shadcn-ui` and `web-design-guidelines` as the detected
alternatives. Edit the chosen-skill cell in `02-adapters.md` and every later packet for a
screen feature names the new skill. Nothing in the kernel mentions either one.

**Surface coverage.** Before the file is written, the batch's surfaces are read off the
item cards (web, iOS, Android, backend) and mapped to the tool that covers each. A surface
with no tool bound is not allowed to pass silently: it becomes a dated decision in
`00-plan.md`, with candidates and their install commands offered from
`references/adapters.md` (for mobile, that list is `@mobile-next/mobile-mcp`, Maestro,
`ios-simulator-mcp`, Appium and Detox). The three acceptable answers are install it now,
verify that surface by hand instead, or accept the gap with a stated reason. Accepting the
gap caps the `ceiling` score for features on that surface, which is what the score is for.

**Code map toggle.** The `code-map` row is the graphify on and off switch. It carries
`enabled: true|false`. When it is true and a built graph exists on disk, exploration and
implementer packets carry the line "query the code map first, open only cited files" and
opening an item refreshes the graph. Set it to false and both behaviors stop. That is the
entire off switch; nothing has to be uninstalled.

**The code map as an example driver.** `graphify` builds a queryable map of a repository
so agents can ask where something lives instead of reading files blind:

```sh
uv tool install graphifyy
graphify install                     # writes a skill dir and a CLAUDE.md block into the
                                     # config dir named by CLAUDE_CONFIG_DIR; git hooks stay opt-in
graphify extract . --code-only       # build the graph without any LLM extraction
graphify query "where is X" --budget 4000
```

Put secrets and build output in a `.graphifyignore` (gitignore syntax) before the first
build. Refresh with a clean rebuild, not `graphify update`, which re-includes markdown and
doubles a code-only graph:

```sh
rm -rf graphify-out && graphify extract . --code-only
```

Then set the `code-map` row in the project's adapters file to `enabled: true` and add
`graphify-out/` to `.gitignore`. This is an illustration of what a driver looks like, not
a recommendation: the kernel works with the row set to `false` and no code map installed
at all.

## Verification and confidence

- **L1 unit.** Each exit point of each changed unit behaves, test-first.
- **L2 integration.** Each seam the feature crosses is actually exercised, not mocked on
  both sides.
- **L3 real surface.** The surface a user touches is driven for real, through the bound
  browser or mobile adapter.
- **L4 cross-feature.** The item's features run together once every feature PR has merged.
- **L5 human-only.** What no bound tool can perform or perceive.

A layer is climbed, not skipped. Everything an agent can observe belongs to L1 through L4
and is finished before anything reaches a human, so an L5 row holding a check an agent
could have run is a review finding rather than a thorough checklist. Evidence is always a
pointer to something you can reopen: a test path, a CI run, a screenshot, the query plus
the row it returned. The L5 checklist has zero agent steps, each row carries the exact
query, command or console path so you can run it yourself, and ticking every row is the
only path from `documented` to `complete`.

Two scores come off one rubric of five dimensions (unit coverage of exit points,
integration seams exercised, real-surface verification, review findings raised versus
resolved, unverifiable effects honestly listed). `agent` is scored on the L1 to L4
evidence that exists today. `ceiling` is scored with every L5 row assumed PASS. A wide gap
says the remaining assurance is parked on you; a low ceiling says no amount of human
ticking will fix it and the raise has to be built. Both carry a date and are re-derived
whenever new evidence lands.

## Tests

Five fresh-agent scenarios live under `tests/scenarios/`. Each one hands a brand-new
light-tier subagent nothing but the scenario's prompt and an absolute path to a fresh copy
of a fixture from `tests/fixtures/`. The subagent acts on that alone, with no README, no
plan, and no other scenario in view. It ends its answer with a list of every file it
opened. The orchestrator then grades that written answer against the scenario's checklist
by reading the transcript, never against what it assumes happened. There is no runner
script, by design: a script that drove the subagent or parsed its output for grading would
test the harness, not the skill.

The scenarios are built to pressure the skill, not to read through it: a cold resume
mid-item, an interview cut off before its final round, a dispatch packet for a feature
already at `reviewed`, a verification file with nothing yet on disk. A read-through would
have confirmed the files exist and sound right. It would not have caught a runner guessing
a fixture path, inventing a feature slug, or pre-filling human verdicts, things a fresh
agent under a real prompt actually did. The table below records what each scenario found
and what changed in response.

The installer has its own runner. `tests/setup/run.sh` executes both setup scripts inside
Docker containers, Ubuntu for bash and the official PowerShell image for pwsh, and covers
a fresh install, an idempotent re-run, an in-place repo, check mode, safety against a real
directory that is not a link, and dry run. On Apple silicon the PowerShell image runs
under amd64 emulation with a memory cap, which the runner sets itself. The Windows junction
fallback is the one path the suite cannot reach; it needs a Windows host.

### Run one

1. Pick the scenario under `tests/scenarios/`.
2. Copy the fixture it names to a scratch directory, e.g. `cp -r tests/fixtures/12-notifications /tmp/scratch-12`.
3. Launch a fresh light-tier subagent with only the scenario's `## Prompt` text, replacing
   `<FIXTURE>` with the absolute path to that scratch copy. A relative path makes the
   runner guess, and the committed fixture itself must never be edited.
4. Read the subagent's transcript and grade it against the scenario's `## Pass criteria`
   yourself.

### 2.0.0 release, 2026-09-16

| Scenario | First run | What it found | What changed | Re-run |
|---|---|---|---|---|
| 01 cold resume | Invalid | The orchestrator never filled `<FIXTURE>`; the runner guessed a path inside the repo and reported files as missing. | Fixtures moved into the repo under `tests/fixtures/`; scenarios now say to hand the runner an absolute path to a fresh copy. | PASS: read `00-plan.md`, the resume protocol, item 4's card, its feature file and working file, the verification index and adapters, nothing from the other eight items; correct next action. |
| 02 quit mid-interview | PASS | Routed to `pre-rolling-wave-planning`, resumed at round 3, did not re-ask settled questions, created no cards before the interview closed. | Re-run three times on 2026-09-16 after the path changes. Run one never named the final adapter round because the prompt never asked, so the prompt gained item (5). Run two drafted questions without the exploration evidence because the pre-planning resume rule loaded only the current checkpoint; the rule now loads every completed checkpoint. The fixture also gained its missing blueprint checkpoint. | PASS: run three routed correctly, drafted three grounded questions, named the adapter round and `02-adapters.md`, created no cards. |
| 03 dispatch packet shape | FAIL | The runner invented a feature slug the card does not list, and the criteria described a feature the fixture holds at a different stage. | The packet template gained a required "Feature (verbatim from the card)" slot. On 2026-09-16 the criteria were corrected to match the fixture and prompt: feature 4.3 at `pending`, so an implementer packet, and `agent-browser` belongs to the later L3 packet. | PASS: the 2026-09-16 re-run produced the implementer packet for 4.3 with the card's slug, all seven slots filled, `heavy` tier, ponytail, superpowers:test-driven-development, frontend-design:frontend-design and next-best-practices resolved from `02-adapters.md`, exactly three SSOT paths, no vendor names, L3 deferred to a separate agent. |
| 04 verification file shape | FAIL, twice | First: the runner pre-filled PASS on every human verdict and logged L5 evidence before any human had run anything. Fixed, then the re-run found rows duplicating checks L1 and L3 already proved, and the runner never invoked `human-assisted-verification`. | Verdict cells became the human's to fill, in the template, the skill, and the verification reference, with the agent handing over `open`. Then the template gained a required "Excluded because L1 to L4 prove them" slot, and the lifecycle gate now names the skill. | PASS: both skills invoked, zero duplicated rows. |
| 05 problem fit | PASS | Named the three forces, the five mechanisms, and one file per phase, from README and SKILL.md alone. | None. | Not needed. |

The acceptance checklist for this release lives at `tests/acceptance/v2-criteria.md`: the
agent fills the evidence column for each requirement, the developer fills the verdict
column, and the tag waits for the developer to do that.

## Versioning

Semver. `VERSION` holds the current release, `CHANGELOG.md` records what each release
changed, and every release is a git tag.

`v1.0.0` is the pre-restructure snapshot: the four skills exactly as they were before they
became one repo, committed with no content edits. It exists to be reverted to.

Pin a version by installing from a tag:

```sh
git clone --branch v1.0.0 git@github.com:dirghayu101/rolling-wave-planning.git
```

Revert an existing clone with `git checkout v1.0.0`, and read `CHANGELOG.md` for what a
newer release breaks before you move forward again. Batches created under an older layout
keep it: `00-plan.md` carries a `layout:` field, and the router sends a `layout: v1` batch
through the compatibility section of `references/ssot-layout.md` before anything is
written.

## License

MIT. See `LICENSE`.
