# Adapters for batch `<N>-<slug>`

Edit this file to swap any binding; the skill reads it, never hard-codes.

Generated at kickoff on `<date>` by `references/adapters.md`. Every row is: what was chosen, what else detection found, and the one line that invokes it. Packets resolve roles and tiers against this file and nothing else.

## Model tiers

| Tier | Alias | Used for |
|---|---|---|
| `judge` | `<judge-model-alias>` | conflicting evidence, design calls, grading a gate |
| `heavy` | `<heavy-model-alias>` | hard implementation, review, security pass, rogue-check, docs drafting |
| `light` | `<light-model-alias>` | mapping, search, log reduction, mechanical edits, scripted flows, screenshots |

Harness override available: `<yes | no>`. <If no: every packet still carries a tier for the record; all three resolve to the same model.>

## Verification tools by surface

Surfaces this batch touches: `<web, iOS, Android, backend>`.

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

**Uncovered surfaces:** `<none | surface + the decision recorded in 00-plan.md, with its date>`

## Docs writer

- Chosen: `<docs-writer-command> | subagent`
- Alternatives detected: `<command | none>`
- Invocation: `<how templates/doc-handoff.md is delivered, e.g. cat <prompt-file> | <docs-writer-command>>`
- `subagent` is a normal value, not a fallback failure. It means the same prompt goes to a `heavy`-tier subagent.

## Environment

Where the stack under test runs for L2 to L4. This row is what is available; the one this batch uses is written into `00-plan.md` § Testing plan § Environment, and item cards copy it from there.

- Chosen: `<docker compose -f <file> | supabase start | testcontainers | staging <url> | none (mocks only)>`
- Alternatives detected: `<candidate, candidate | none>`
- Invocation: `<one-line command that brings it up>`
- Seed data: `<path or command | none>`
- Reset: `<one-line command that returns it to a known state, e.g. supabase db reset, docker compose down -v>`
- Docker present: `<yes (docker info succeeds) | no>`
- `enabled: <true | false>`

Docker present is what lets L2 and L4 cross real seams instead of mocks on both sides, and it is what makes a load number mean anything.

## Cleanup

What takes down everything this batch's subagents start or write. Packets point their Ephemera slot at the scratch root; the gates in `references/lifecycle.md` and the pause protocol in `references/resume.md` run the teardown lines.

- Scratch root: `<the ONE directory every packet's Ephemera slot points under, e.g. <session scratchpad>/<batch>/ or assets/tmp/>`
- Teardown lines, in the order they must run:
  1. `<line that stops the stack the Environment row brings up>`
  2. `<line that removes its containers and volumes>`
  3. `rm -rf <scratch root>/<dispatch dir>`
- Cache to reclaim: `<line that drops the safe-to-drop caches | none>`
- Verified on: `<date each line above was actually run once against this environment>`

A teardown line nobody has run is a claim, not a binding.

## Audit

- `dispatches_per_audit: <N, default 8>`
- Scheduler binding: `<harness hook, cron entry or git hook that fires the audit outside the flow | none>`

The count is the trigger the skill relies on; the scheduler is an optional binding of this project, never part of the skill. The audit also fires on every pause and before the batch PR opens. Packet: `templates/audit-handoff.md`.

## Load testing

- Chosen: `<tool | none (no performance criteria in this batch)>`
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

Roles added mid-batch by the description-grep fallback in `references/dispatch.md` are appended here with the same columns.
