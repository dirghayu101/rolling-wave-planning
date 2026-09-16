# Adapters

Loaded once per batch, at kickoff, by the interview's final round. It turns "what is installed on this machine, in this project, today" into the batch's `02-adapters.md`: one binding per role, written down so every later packet resolves a role to a concrete skill, tool or model alias without re-detecting anything.

**Kernel plus drivers.** This repo ships no drivers. It ships the role contract (`references/dispatch.md`) and the detection procedure below. Every skill, tool and model is a driver, chosen per project and swapped by editing one file. That is why model-vendor names appear in this file only as examples of an option family, and in `templates/02-adapters.md` only as `<placeholders>`.

Also loaded mid-batch when a dispatch needs a role that `02-adapters.md` has no row for, or when the user installs something and asks for the bindings to be refreshed.

## Two config layers

1. **Project defaults**: `<features-dir>/adapters.default.md` (the same directory the batch dirs are siblings in; the project's `CLAUDE.md` or `AGENTS.md` may carry a one-line pointer to it). It is the accumulated answer from earlier batches in this project.
2. **Batch bindings**: `02-adapters.md` inside the batch directory. This is what packets read. It can diverge from the defaults for the life of one batch.

Kickoff procedure:

1. Read `<features-dir>/adapters.default.md` if it exists. If it does not, this is the project's first v2 batch: skip to step 2 and generate from detection alone.
2. Run detection (below).
3. Diff detection against the defaults file. **Present only the delta** in the interview's final round: newly installed skills or tools that could replace a current binding, and bindings whose tool is now missing. Numbered options, each with a one-line trade-off and **your recommendation**. Unchanged rows are not a question; carry them over silently.
4. Write `02-adapters.md` from `templates/02-adapters.md` with the answers.
5. Save the result back to `<features-dir>/adapters.default.md` (from `templates/adapters.default.md` on first creation), so the next batch starts from today's answers and its delta is genuinely small.

A missing defaults file is normal, not an error. So is a delta of zero rows: then the adapter round is one sentence confirming the carry-over.

## Option families

Candidates researched 2026-09-16. Presence of a candidate here is not an endorsement, and the list is not exhaustive. **Verify an install command against the tool's own README before running it.**

### Model tiers

Three role tiers, bound to whatever aliases this harness exposes: `judge`, `heavy`, `light`. Examples of the alias strings a harness might expose: `opus`, `sonnet`, `haiku`, and non-Anthropic driver CLIs such as `codex` or `gemini` where the harness can dispatch to them. Bind by capability, not by name recognition: the `light` tier must still be able to run a scripted browser flow and report exact output.

Detection: the model names the harness accepts on a subagent dispatch. If the harness exposes no override, record `judge/heavy/light → <harness default>` and note that tiering is unavailable, so every packet still carries a tier for the record even though it resolves to one model.

### Browser verification (web surface)

| Candidate | Exposure | Detection | Install |
|---|---|---|---|
| `agent-browser` | CLI | `command -v agent-browser`; the `agent-browser` skill in the skills listing | already the standing tool on this machine |
| Playwright CLI | CLI | `command -v playwright`, or `playwright` in the project's devDependencies | `npm i -D @playwright/test && npx playwright install` |

On this machine a standing rule makes `agent-browser` the only browser tool; record it and move on.

### Mobile verification (iOS, Android surfaces)

| Candidate | Exposure | Detection | Install |
|---|---|---|---|
| `@mobile-next/mobile-mcp` | MCP | mobile tool names visible in the harness | MCP server entry running `npx -y @mobile-next/mobile-mcp@latest` |
| Maestro + `maestro mcp` | CLI + MCP | `command -v maestro` | `curl -Ls https://get.maestro.mobile.dev \| bash` |
| `ios-simulator-mcp` | MCP | simulator tool names visible in the harness | MCP server entry running `npx -y ios-simulator-mcp` |
| Appium | CLI | `command -v appium` | `npm i -g appium` |
| Detox (React Native) | CLI | `detox` in the project's devDependencies | `npm i -D detox` |

### Backend and database inspection

| Candidate | Exposure | Detection | Install |
|---|---|---|---|
| Supabase MCP (read-only) | MCP | `supabase` tool names visible in the harness | configure the MCP server read-only |
| `supabase` CLI | CLI | `command -v supabase` | `brew install supabase/tap/supabase` |

### Docs writer

An external CLI on PATH that can take a self-contained prompt on stdin and write a file, or a subagent. Detection: `type <candidate>` for each CLI the user names, remembering that **an alias resolves only in a profile-initialized shell**, so `command -v` alone can report absent for a CLI the user reaches daily.

**The subagent fallback is not a failure state.** When no external CLI is bound, the docs row reads `subagent` and `templates/doc-handoff.md` is dispatched to a `heavy`-tier subagent with the identical prompt. Nothing downstream changes.

### Load and performance testing

| Candidate | Exposure | Detection | Install |
|---|---|---|---|
| k6 | CLI | `command -v k6` | `brew install k6` |
| autocannon | CLI | `command -v autocannon` | `npm i -g autocannon` |
| oha | CLI | `command -v oha` | `brew install oha` |
| Lighthouse CI | CLI | `command -v lhci` | `npm i -g @lhci/cli` |

Bind this row only when the batch has a performance acceptance criterion. Otherwise record `none (no performance criteria in this batch)`.

### Visual diff

| Candidate | Exposure | Detection | Install |
|---|---|---|---|
| odiff | CLI | `command -v odiff` | `npm i -g odiff-bin` |
| pixelmatch | library | `pixelmatch` in the project's dependencies | `npm i pixelmatch` |
| BackstopJS | CLI | `command -v backstop` | `npm i -g backstopjs` |

Used by the blueprint phase's L3 comparison: screenshot through the browser adapter, diff against `planning/03-blueprint/<screen>.html` through this one.

### Code map

`safishamsi/graphify`. Install `uv tool install graphifyy`, then `graphify install`, then `/graphify .` to build. Queries: `graphify query`, `graphify path`, `graphify explain`. Refresh: `graphify update .`. Output lands in `graphify-out/`, which belongs in `.gitignore`.

Detection: `command -v graphify` **and** `graphify-out/graph.json` exists in the project. A graph that was never built is the same as no code map.

**The `enabled: true|false` toggle.** The code-map row in `adapters.default.md` and `02-adapters.md` carries this flag, and it is the documented off switch: flipping it to `false` is the whole disable procedure, with no uninstall required. Two conditions must both hold before the code map influences anything:

- `enabled: true` in `02-adapters.md`, and
- `graphify-out/graph.json` exists.

When both hold: every exploration and implementer packet carries the line *"query the code map first, open only cited files"*, and opening an item runs the incremental update (`graphify update .`) first. When either fails, packets carry no code-map line and no refresh runs. Do not treat a stale graph as absent: refresh it, or set `enabled: false` and say why in the row.

Build code only. Docs and media extraction is what triggers LLM calls, so leave that unconfigured. Check `graphify --help` or the README for the exclusion mechanism before building a monorepo root that holds secrets (env files, keystores, auth keys); if no exclusion mechanism exists, build per package instead, which excludes root secrets by construction. Git hooks are a separate opt-in (`graphify hook install|uninstall|status`) and stay off.

### Skill roles

The role list is fixed in `references/dispatch.md`; the binding is generated here. For each stable role, and for each stack-conditional role whose manifest trigger fired, write a row: role, chosen skill, alternatives detected, when applied.

## Detection procedure

Run all four sweeps, then assemble.

1. **CLIs**: `command -v <name>` for each candidate, and `type <name>` as well when the user mentions reaching a tool by an alias. Aliases resolve only in a profile-initialized shell, so a bare `command -v` can report absent for a tool that works interactively. When in doubt, ask the user to run `type <name>` and paste the output rather than concluding absent.
2. **MCP servers**: presence means **the tool names are visible in this harness right now**. Not a config file on disk, not a server the user believes is installed. If the names are not in the tool listing, the MCP is absent for this batch.
3. **Skills**: list `~/.agents/skills` and read each `SKILL.md` frontmatter `description`; then scan the harness skill listing for plugin skills, which are namespaced (`superpowers:test-driven-development`, `feature-dev:code-reviewer`, `frontend-design:frontend-design`) and do not appear in that directory. Match candidates to roles **by what the description says it triggers on**, never by the skill's name.
   `awk '/^description:/{print FILENAME": "$0}' ~/.agents/skills/*/SKILL.md`
4. **Stack**: read the project manifest. In `package.json` dependencies and devDependencies, look for `next`, `expo`, `react-native`, `stripe`, `@supabase/*`. Each hit either fires a stack-conditional role (`payments`, `framework`) or points at a backend adapter. A monorepo has one manifest per package: sweep them all, and record which package each stack-conditional row applies to.

## Surface coverage check

Before writing the file, list the **surfaces this batch touches**: web, iOS, Android, backend. Read them off the item cards, not off the repo as a whole; a batch can live entirely in one surface of a three-surface project.

Then map surface to tool:

| Surface | Covered by |
|---|---|
| web | the browser-verification binding |
| iOS | the mobile-verification binding |
| Android | the mobile-verification binding |
| backend | the backend/DB inspection binding |

**An uncovered surface is a recorded kickoff decision, not a silent gap.** Put it to the user in the adapter round with the candidates from the family above and their install commands, and record the answer in the decisions table of `00-plan.md` with its date. The three acceptable answers:

- **Install now.** Record which candidate, then re-run detection for that row.
- **Human-only verification for that surface.** Every feature touching it carries its L3 evidence as L5 human rows instead; the verification ladder must show this, so it is visible where the confidence score is read rather than buried here.
- **Accept the gap.** Only with a stated reason. The `ceiling` score for features on that surface is then capped by unverifiable effects, which is exactly what the score is for.

Silence is not one of the three. A surface with no row is what produces a feature marked verified with nothing behind it.

## What the rogue-check reads

`references/review.md`'s rogue-check treats this file as evidence: the chosen model tiers and role bindings here, against the actual `Tier` and `Roles → skills` values in `working/<item>.agent.md`'s dispatch record. A batch whose kickoff bound `heavy` to hard implementation and whose dispatch record shows every implementer on `light` has drifted, and the rogue-check is where that surfaces.

## Red flags

- A `02-adapters.md` written from what the agent assumes is installed rather than from a detection sweep run in this session.
- An MCP recorded as present because a config file mentions it, without its tool names visible in the harness.
- A CLI recorded as absent on `command -v` alone when the user reaches it through an alias.
- A surface touched by the batch with no tool row and no recorded decision.
- A skill bound to a role because its name sounded right, with its description unread.
- `code-map: enabled: true` with no `graphify-out/graph.json`, or packets carrying the code-map line while the row reads `false`.
- A model-vendor name written into a skill body, a packet, or a card. Tiers go in those places; the alias lives only in `02-adapters.md`.
- Detection re-run at dispatch time because nobody wrote the file at kickoff.
