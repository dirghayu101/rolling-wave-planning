# Adapters defaults for `<project>`

Edit this file to swap any binding; the skill reads it, never hard-codes.

> **This is the project-level seed, not a batch file.** It lives at `<project root>/adapters.default.md`, at the git root of the project or monorepo, not inside any feature or spec directory. Kickoff reads it, runs detection from `references/adapters.md`, and presents **only the delta** (newly installed skills or tools, bindings whose tool has gone missing) in the interview's final round. The answers are written to the batch's `02-adapters.md`, then saved back here, so the next batch starts from today's answers.
>
> Editing this file changes the starting point for future batches. It does **not** change a batch already running: edit that batch's `02-adapters.md` instead.
>
> Record a one-line pointer to this path in the project's `CLAUDE.md` or `AGENTS.md`, so an agent finds the toggles without searching.

Last detection sweep: `<date>`. Every row is: what was chosen, what else detection found, and the one line that invokes it.

## Model tiers

| Tier | Alias | Used for |
|---|---|---|
| `judge` | `<judge-model-alias>` | conflicting evidence, design calls, grading a gate |
| `heavy` | `<heavy-model-alias>` | hard implementation, review, security pass, rogue-check, docs drafting |
| `light` | `<light-model-alias>` | mapping, search, log reduction, mechanical edits, scripted flows, screenshots |

Harness override available: `<yes | no>`. <If no: every packet still carries a tier for the record; all three resolve to the same model.>

## Verification tools by surface

Surfaces this project has: `<web, iOS, Android, backend>`.

### web

- Chosen: `<tool>`
- Alternatives detected: `<tool, tool | none>`
- Invocation: `<one-line command or MCP tool name>`
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

## Docs writer

- Chosen: `<docs-writer-command> | subagent`
- Alternatives detected: `<command | none>`
- Invocation: `<how templates/doc-handoff.md is delivered, e.g. cat <prompt-file> | <docs-writer-command>>`
- `subagent` is a normal value, not a fallback failure. It means the same prompt goes to a `heavy`-tier subagent.

## Environment

Where the stack under test runs for L2 to L4. This row is the project's standing answer; each batch records the environment it actually uses in its own `00-plan.md` § Testing plan § Environment.

- Chosen: `<docker compose -f <file> | supabase start | testcontainers | staging <url> | none (mocks only)>`
- Alternatives detected: `<candidate, candidate | none>`
- Invocation: `<one-line command that brings it up>`
- Seed data: `<path or command | none>`
- Reset: `<one-line command that returns it to a known state, e.g. supabase db reset, docker compose down -v>`
- Docker present: `<yes (docker info succeeds) | no>`
- `enabled: <true | false>`

Docker present is what lets L2 and L4 cross real seams instead of mocks on both sides, and it is what makes a load number mean anything.

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

Both `enabled: true` and a present graph are required before packets carry the line "query the code map first, open only cited files". Flipping `enabled` to `false` is the whole off switch.

## Skill roles

One row per role. Roles are defined in `references/dispatch.md`; only the binding is decided here.

| Role | Chosen skill | Alternatives detected | When applied |
|---|---|---|---|
| `simplicity` | `<skill>` | `<skill, skill or none>` | every implementer packet |
| `tdd` | `<skill>` | `<skill or none>` | every packet writing production code |
| `debugging` | `<skill>` | `<skill or none>` | any packet starting from a symptom |
| `ui-guidelines` | `<skill>` | `<skill, skill or none>` | blueprint phase only |
| `ui-implementation` | `<skill>` | `<skill, skill or none>` | screen features, wireframe path in scope |
| `browser-verification` | `<skill>` | `<skill or none>` | web features at L3 |
| `mobile-verification` | `<skill or none, bound to the mobile tool row>` | `<skill or none>` | iOS or Android features at L3 |
| `db-backend` | `<skill>` | `<skill, skill or none>` | packets touching the database or its generated types |
| `security-review` | `<skill>` | `<skill, skill or none>` | reviewer packets on a card-flagged sensitive surface |
| `docs-conventions` | `<skill>` | `<skill or none>` | the docs packet at feature `documented` |
| `code-map` | `<skill or none>` | `<skill or none>` | only while the Code map section reads `enabled: true` and the graph exists |
| `review` | `<skill>` | `<skill or none>` | every reviewer packet |

Stack-conditional rows. Present only when detection found the trigger in the project manifest.

| Role | Manifest trigger | Chosen skill | Alternatives detected | When applied |
|---|---|---|---|---|
| `payments` | `<dependency>` | `<skill>` | `<skill or none>` | `<packets touching …>` |
| `framework` | `<dependency>` | `<skill>` | `<skill, skill or none>` | `<packets writing application code in …>` |

Roles added mid-batch by the description-grep fallback in `references/dispatch.md` reach this file when kickoff saves a batch's answers back. Do not hand-add a role here that no batch has used.
