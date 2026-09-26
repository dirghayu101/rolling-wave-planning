# Adapters defaults for `<project>`

Edit this file to swap any binding; the skill reads it, never hard-codes.

> **This is the project-level seed, not a batch file.** It lives at `<project root>/adapters.default.md`, at the git root of the project or monorepo. Kickoff reads it, runs detection from `references/adapters.md`, and presents **only the delta** in the interview's final round. The answers are written to the batch's `agent/adapters.md`, then saved back here.
>
> Editing this file changes the starting point for future batches. It does **not** change a batch already running: edit that batch's `agent/adapters.md` instead.
>
> Record a one-line pointer to this path in the project's `CLAUDE.md` or `AGENTS.md`.

Last detection sweep: `<date>`. Every row is: what was chosen, what else detection found, and the one line that invokes it.

## Model tiers

| Tier | Alias | Used for |
|---|---|---|
| `orchestrator` | `<orchestrator-model-alias>` | the session model: decomposition, packets, vetting, synthesis |
| `judge` | `<judge-model-alias>` | escalations per `dispatch.md` § Escalating to the judge; one per feature by default |
| `heavy` | `<heavy-model-alias>` | hard implementation, fixes, review, security pass, drafting anything a human will execute |
| `light` | `<light-model-alias>` | mapping, search, log reduction, mechanical edits, scripted flows, captures, flow diagrams, the integrity check |

Harness override available: `<yes | no>`. <If no: every packet still carries a tier for the record; all four resolve to the same model.> When `judge` and `orchestrator` resolve to the same model the judge is inert: write `inert, orchestrator decides` in its Used-for cell.

## Verification tools by surface

Surfaces this project has: `<web, iOS, Android, backend>`.

### web

- Chosen: `<tool>`
- Alternatives detected: `<tool, tool | none>`
- Invocation: `<one-line command or MCP tool name>`
- Geometry and focus reads: `<the command or API that reports element boxes and focus order>`
- `enabled: <true | false>`

### iOS

- Chosen: `<tool | none>`
- Alternatives detected: `<tool, tool | none>`
- Invocation: `<one-line command or MCP tool name>`
- `enabled: <true | false>`

### Android

- Chosen: `<tool | none>`
- Alternatives detected: `<tool, tool | none>`
- Invocation: `<one-line command or MCP tool name>`
- `enabled: <true | false>`

### backend

- Chosen: `<tool | none>`
- Alternatives detected: `<tool, tool | none>`
- Invocation: `<one-line command or MCP tool name>`
- `enabled: <true | false>`

**Uncovered surfaces:** `<none | surface + the standing reason>`. A batch that actually touches an uncovered surface records its own dated decision in that batch's `00-plan.md`.

## Environment

Where the stack under test runs for L2 to L4. This is the project's standing answer; each batch records the environment it actually uses in its own `00-plan.md` § Testing plan § Environment.

- Chosen: `<compose file | local stack | testcontainers | staging <url> | none (mocks only)>`
- Alternatives detected: `<candidate, candidate | none>`
- Invocation: `<one-line command that brings it up; also the command that serves the app locally from the batch branch against dev for the dev pass>`
- Seed data: `<path or command | none>` <only when the file it names exists>
- Reset: `<one-line command that returns it to a known state>`
- Docker present: `<yes (docker info succeeds) | no>`
- Forbidden by project rules: `<candidate + the rule and file | none>`
- `enabled: <true | false>`

## Cleanup

The project's standing answer for taking down everything a batch's subagents start or write. Each batch copies it into its own `agent/adapters.md`.

- Scratch root: `<the ONE directory every packet's Ephemera slot points under>`
- Teardown lines, in the order they must run:
  1. `<line that stops the stack the Environment row brings up>`
  2. `<line that removes its containers and volumes>`
  3. `<line that kills a dev server started per worktree>`
  4. `rm -rf <scratch root>/<dispatch dir>`
- Cache to reclaim: `<line that drops the safe-to-drop caches | none>`
- Verified on: `<date each line above was actually run once against this environment>`

A teardown line nobody has run is a claim, not a binding.

## Load testing

- Chosen: `<tool | none (no performance criteria in this project)>`
- Alternatives detected: `<tool, tool | none>`
- Invocation: `<one-line command>`
- `enabled: <true | false>`

## Visual diff

- Chosen: `<tool | none>`
- Alternatives detected: `<tool, tool | none>`
- Invocation: `<one-line command>`
- `enabled: <true | false>`

## Code map

- `enabled: <true | false>`
- Tool: `<tool | none>`
- Build: `<one-line command>`
- Refresh: `<one-line command, run when an item opens>`
- Query: `<one-line command>`
- Graph present: `<path to graph.json | absent>`

Both `enabled: true` and a present graph are required before packets carry "query the code map first, open only cited files". Flipping `enabled` to `false` is the whole off switch.

## Skill roles

One row per role. Roles are defined in `references/dispatch.md`; only the binding is decided here.

| Role | Chosen skill | Alternatives detected | When applied |
|---|---|---|---|
| `simplicity` | `<skill>` | `<skill, skill or none>` | every implementer packet |
| `tdd` | `<skill>` | `<skill or none>` | every packet writing production code, including fixers |
| `debugging` | `<skill>` | `<skill or none>` | any packet starting from a symptom |
| `flow-explorer` | `none (template only)` | `<skill or none>` | feature `open` and PR ready, `light` tier, from `templates/flow.md` |
| `ui-guidelines` | `<skill>` | `<skill, skill or none>` | blueprint phase only |
| `ui-implementation` | `<skill>` | `<skill, skill or none>` | screen features, wireframe path in scope |
| `browser-verification` | `<skill>` | `<skill or none>` | web features at L3 |
| `mobile-verification` | `<skill or none>` | `<skill or none>` | iOS or Android features at L3 |
| `db-backend` | `<skill>` | `<skill, skill or none>` | packets touching the database or its generated types |
| `security-review` | `<skill>` | `<skill, skill or none>` | the reviewer packet on a card-flagged sensitive surface |
| `code-map` | `<skill or none>` | `<skill or none>` | only while the Code map section reads `enabled: true` and the graph exists |
| `review` | `<skill>` | `<skill or none>` | the one reviewer packet per feature |

Stack-conditional rows. Present only when detection found the trigger in the project manifest.

| Role | Manifest trigger | Chosen skill | Alternatives detected | When applied |
|---|---|---|---|---|
| `payments` | `<dependency>` | `<skill>` | `<skill or none>` | `<packets touching …>` |
| `framework` | `<dependency>` | `<skill>` | `<skill, skill or none>` | `<packets writing application code in …>` |

Roles added mid-batch by the description-grep fallback in `references/dispatch.md` reach this file when kickoff saves a batch's answers back. Do not hand-add a role here that no batch has used.
