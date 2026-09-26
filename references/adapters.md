# Adapters

Loaded once per batch, at kickoff, by the interview's final round. It turns "what is installed on this machine, in this project, today" into the batch's `agent/adapters.md`: one binding per role, written down so every later packet resolves a role to a concrete skill, tool or model alias without re-detecting anything.

**Kernel plus drivers.** This repo ships no drivers. It ships the role contract (`references/dispatch.md`) and the detection procedure below. Every skill, tool and model is a driver, chosen per project and swapped by editing one file.

Also loaded mid-batch when a dispatch needs a role `agent/adapters.md` has no row for, or when the user installs something and asks for a refresh.

## Two config layers

1. **Project defaults**: `<project root>/adapters.default.md`, at the git root. It is the accumulated answer from earlier batches in this project.
2. **Batch bindings**: `agent/adapters.md` inside the batch directory. This is what packets read, and it can diverge from the defaults for the life of one batch.

Kickoff procedure:

1. Read `<project root>/adapters.default.md` if it exists. If it does not, this is the project's first batch: generate from detection alone.
2. Run detection (below).
3. Diff detection against the defaults. **Present only the delta** in the interview's final round: newly installed skills or tools that could replace a binding, and bindings whose tool is now missing. Numbered options, each with a one-line trade-off and your recommendation. Unchanged rows are not a question.
4. Write `agent/adapters.md` from `templates/02-adapters.md`.
5. Save the result back to `<project root>/adapters.default.md` (from `templates/adapters.default.md` on first creation).

A missing defaults file is normal. So is a delta of zero rows.

## Option families

Presence of a candidate here is not an endorsement, and the list is not exhaustive. **Verify an install command against the tool's own README before running it.**

### Model tiers

Four tiers, each bound explicitly in `adapters.default.md` and the batch's `agent/adapters.md`: `orchestrator` (the session model), `judge`, `heavy`, `light`. **The skill never names a model.** Swapping a model is an edit to those two tables and nothing else. Bind by capability, not by name recognition: the `light` tier must still be able to run a scripted browser flow and report exact output.

There is no "one tier above" rule: each binding is written down. When `judge` and `orchestrator` are bound to the same model, the judge is inert, and its Used-for cell says so (`references/dispatch.md` § Escalating to the judge).

Detection: record which model aliases the harness accepts on a subagent dispatch, and which one the session runs on. If the harness exposes no override, record every tier as `<harness default>`, which makes the judge inert; every packet still carries a tier for the record.

### Browser verification (web surface)

| Candidate | Exposure | Detection | Install |
|---|---|---|---|
| `agent-browser` | CLI | `command -v agent-browser`; the skill in the listing | per its README |
| Playwright CLI | CLI | `command -v playwright`, or `playwright` in devDependencies | `npm i -D @playwright/test && npx playwright install` |

The binding must support **geometry and focus reads**, not only screenshots: the L3 pass measures boxes and focus order, and a tool that cannot report them caps L3 at "it rendered".

### Mobile verification (iOS, Android surfaces)

| Candidate | Exposure | Detection | Install |
|---|---|---|---|
| `@mobile-next/mobile-mcp` | MCP | mobile tool names visible in the harness | MCP server running `npx -y @mobile-next/mobile-mcp@latest` |
| Maestro + `maestro mcp` | CLI + MCP | `command -v maestro` | `curl -Ls https://get.maestro.mobile.dev \| bash` |
| `ios-simulator-mcp` | MCP | simulator tool names visible in the harness | MCP server running `npx -y ios-simulator-mcp` |
| Appium | CLI | `command -v appium` | `npm i -g appium` |
| Detox (React Native) | CLI | `detox` in devDependencies | `npm i -D detox` |

### Backend and database inspection

| Candidate | Exposure | Detection | Install |
|---|---|---|---|
| Supabase MCP (read-only) | MCP | `supabase` tool names visible in the harness | configure the MCP server read-only |
| `supabase` CLI | CLI | `command -v supabase` | `brew install supabase/tap/supabase` |

### Environment: where the stack under test runs

| Candidate | Exposure | Detection | Install |
|---|---|---|---|
| Docker | CLI + daemon | `docker info` (a CLI with a dead daemon is not an environment) | Docker Desktop, or `brew install colima docker && colima start` |
| A compose file in the repo | file | `find . -maxdepth 3 -name '*compose*.y*ml'` | already present, or write one |
| Supabase local stack | CLI, requires Docker | `command -v supabase` **and** `supabase/config.toml` present | `brew install supabase/tap/supabase`, then `supabase start` |
| testcontainers | library | the dependency in the project manifest | `npm i -D testcontainers` |
| A remote dev project | hosted | the project's committed apply and seed scripts plus the project rules naming the dev target | already provisioned; reset is the project's apply script |
| Staging deployment | URL | the project's environment config or its agent-instructions pointer. **Never read `.env`**: ask the user | already deployed |

Each chosen row records three things: the chosen value, the line that brings it up, and the line that resets it to a known state.

The Environment row is also what the dev pass runs against: the app is served locally from the batch branch against the dev database, so the start command recorded here is the one that pass uses. A deployed preview is not a candidate, because it would need a merge to dev that has not happened while the pass runs.

**Read the project's own rules before choosing a row.** A candidate the project forbids detects exactly as cleanly as an allowed one, and is recorded as `present, forbidden by <rule, file>` and never chosen. **A seed line is recorded only when the seed file it names exists**: open the path and check.

Docker being present is what makes L2 and L4 run against real services rather than mocks on both sides of every seam, and it is what makes a load number mean anything.

### Cleanup

The other half of the Environment row: what takes down everything the batch's subagents start or write.

| Row | What it holds | Example shape |
|---|---|---|
| Scratch root | the ONE directory every packet's Ephemera slot points under | a session scratchpad path |
| Teardown lines | one line per thing the environment brings up, in the order they must run | the stack's stop line, the compose-down line, `rm -rf <scratch root>/<dispatch dir>` |
| Cache to reclaim | caches safe to drop, with the line that drops them, or `none` | a build cache, an image cache, a browser profile dir |

**A teardown line nobody has run is a claim, not a binding:** run each one once at kickoff, against the environment it targets.

Ephemera is swept at the item PR, at batch close and at every pause.

### Load and performance testing

| Candidate | Exposure | Detection | Install |
|---|---|---|---|
| k6 | CLI | `command -v k6` | `brew install k6` |
| autocannon | CLI | `command -v autocannon` | `npm i -g autocannon` |
| oha | CLI | `command -v oha` | `brew install oha` |
| Lighthouse CI | CLI | `command -v lhci` | `npm i -g @lhci/cli` |

Bind this row only when `00-plan.md` § Testing plan holds a numbered criterion. Otherwise record `none (no performance criteria in this batch)`.

### Visual diff

| Candidate | Exposure | Detection | Install |
|---|---|---|---|
| odiff | CLI | `command -v odiff` | `npm i -g odiff-bin` |
| pixelmatch | library | `pixelmatch` in the project's dependencies | `npm i pixelmatch` |
| BackstopJS | CLI | `command -v backstop` | `npm i -g backstopjs` |

Used by the blueprint phase's L3 comparison.

### Code map

`safishamsi/graphify`. Install `uv tool install graphifyy`, then `graphify install`, then build code-only with `graphify extract . --code-only`. Queries: `graphify query "<question>" --budget N`, `graphify explain`, `graphify affected`, `graphify path`. Refresh with a clean rebuild, `rm -rf graphify-out && graphify extract . --code-only`: `graphify update` re-includes markdown and doubles a code-only graph. Output lands in `graphify-out/`, which belongs in `.gitignore`.

Detection: `command -v graphify` **and** `graphify-out/graph.json` exists. A graph that was never built is the same as no code map.

**The `enabled: true|false` toggle** is the documented off switch. Two conditions must both hold before the code map influences anything: `enabled: true` in `agent/adapters.md`, and the graph present. Then every exploration and implementer packet carries the line *"query the code map first, open only cited files"*, and opening an item runs the clean rebuild first.

Build code only. Docs and media extraction is what triggers LLM calls. Check the README for the exclusion mechanism before building a monorepo root that holds secrets; if none exists, build per package.

### Skill roles

The role list is fixed in `references/dispatch.md`; the binding is generated here. For each stable role, and each stack-conditional role whose manifest trigger fired, write a row: role, chosen skill, alternatives detected, when applied.

`flow-explorer` usually binds to no skill: it is a `light` dispatch working from `templates/flow.md` plus the `code-map` row when one is enabled. Record it as `none (template only)` rather than leaving the row out.

## Detection procedure

Run all five sweeps, then assemble.

1. **CLIs**: `command -v <name>`, plus `type <name>` when the user reaches a tool by an alias. Aliases resolve only in a profile-initialized shell.
2. **MCP servers**: presence means **the tool names are visible in this harness right now**. Not a config file on disk.
3. **Skills**: list `~/.agents/skills` and read each `SKILL.md` frontmatter `description`; then scan the harness listing for namespaced plugin skills. Match by what the description says it triggers on, never by the name.
   `awk '/^description:/{print FILENAME": "$0}' ~/.agents/skills/*/SKILL.md`
4. **Environment**: `docker info`, `find . -maxdepth 3 -name '*compose*.y*ml'`, `command -v supabase` with `supabase/config.toml`, and the manifest for testcontainers. **Read the project's rules in the same sweep** before any local stack is a candidate, and confirm that any seed file a candidate names actually exists.
5. **Stack**: read the project manifest for `next`, `expo`, `react-native`, `stripe`, `@capacitor/core`, `@supabase/*`. A monorepo has one manifest per package: sweep them all.

## Surface coverage check

Before writing the file, list the **surfaces this batch touches**, read off the item cards: web, iOS, Android, backend. Map each to its binding.

**An uncovered surface is a recorded kickoff decision, not a silent gap.** Three acceptable answers: install a candidate now, verify that surface by hand instead (its L3 work becomes L5 rows), or accept the gap with a stated reason, which caps the `ceiling` score for features on that surface. Silence is not one of them.

## Red flags

- An `agent/adapters.md` written from what the agent assumes is installed rather than a detection sweep run in this session.
- An MCP recorded as present because a config file mentions it.
- A CLI recorded as absent on `command -v` alone when the user reaches it through an alias.
- A surface touched by the batch with no tool row and no recorded decision.
- A browser binding that cannot report geometry or focus.
- A skill bound to a role because its name sounded right, with its description unread.
- `code-map: enabled: true` with no graph on disk.
- A model-vendor name written into a skill body, a packet, or a card.
- A `judge` binding equal to `orchestrator` with no note that the tier is inert.
- An Environment row reading `none (mocks only)` while `docker info` succeeds.
- An Environment row chosen against a project rule that forbids it, or a seed line naming a file that does not exist.
- A teardown or cache line written from memory, never run against the environment it claims to tear down.
