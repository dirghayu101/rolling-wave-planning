# Adapters for batch `12-notifications`

Edit this file to swap any binding; the skill reads it, never hard-codes.

Generated at kickoff on `2026-09-09` by `references/adapters.md`. Every row is: what was chosen, what else detection found, and the one line that invokes it.

## Model tiers

| Tier | Alias | Used for |
|---|---|---|
| `judge` | `<judge-model-alias>` | conflicting evidence, design calls, grading a gate |
| `heavy` | `<heavy-model-alias>` | hard implementation, review, security pass, rogue-check, docs drafting |
| `light` | `<light-model-alias>` | mapping, search, log reduction, mechanical edits, scripted flows, screenshots |

Harness override available: `yes`.

## Verification tools by surface

Surfaces this batch touches: `web, backend`.

### web

- Chosen: `agent-browser`
- Alternatives detected: `Playwright CLI`
- Invocation: `agent-browser` CLI (see `references/adapters.md`)
- `enabled: true`

### iOS

- Chosen: `none`
- Alternatives detected: `none`
- Invocation: `n/a — no iOS surface in this batch`
- `enabled: false`

### Android

- Chosen: `none`
- Alternatives detected: `none`
- Invocation: `n/a — no Android surface in this batch`
- `enabled: false`

### backend

- Chosen: `Supabase MCP (read-only) + supabase CLI`
- Alternatives detected: `none`
- Invocation: `supabase` CLI; Supabase MCP tools for read-only inspection
- `enabled: true`

**Uncovered surfaces:** `none`

## Docs writer

- Chosen: `subagent`
- Alternatives detected: `codex (absent from PATH on this project)`
- Invocation: filled `templates/doc-handoff.md` dispatched as a `heavy`-tier subagent's entire packet
- `subagent` is a normal value, not a fallback failure.

## Load testing

- Chosen: `none (no performance criteria in this batch)`
- Alternatives detected: `k6, autocannon`
- Invocation: `n/a`
- `enabled: false`

## Visual diff

- Chosen: `none`
- Alternatives detected: `odiff`
- Invocation: `n/a`
- `enabled: false`

## Code map

- `enabled: false`
- Tool: `none`
- Build: `n/a`
- Refresh: `n/a`
- Query: `n/a`
- Graph present: `absent`

## Skill roles

| Role | Chosen skill | Alternatives detected | When applied |
|---|---|---|---|
| `simplicity` | `ponytail` | `none` | every implementer packet |
| `tdd` | `superpowers:test-driven-development` | `none` | every packet writing production code |
| `debugging` | `systematic-debugging` | `superpowers:systematic-debugging` | any packet starting from a symptom |
| `ui-guidelines` | `ui-ux-pro-max` | `none` | blueprint phase only |
| `ui-implementation` | `frontend-design:frontend-design` | `ui-ux-pro-max, shadcn` | screen features, wireframe path in scope |
| `browser-verification` | `agent-browser` | `none` | web features at L3 |
| `mobile-verification` | `none` | `none` | iOS or Android features at L3 (none in this batch) |
| `db-backend` | `supabase` | `supabase-postgres-best-practices, supabase-security` | packets touching the database or its generated types |
| `security-review` | `supabase-security` | `security-review (harness)` | reviewer packets on a card-flagged sensitive surface |
| `docs-conventions` | `human-engineering-docs` | `documentation-writer` | the docs packet at feature `documented` |
| `code-map` | `none` | `none` | disabled — see Code map section above |
| `review` | `superpowers:requesting-code-review` | `feature-dev:code-reviewer` | every reviewer packet |

Stack-conditional rows. Present only when detection found the trigger in the project manifest.

| Role | Manifest trigger | Chosen skill | Alternatives detected | When applied |
|---|---|---|---|---|
| `framework` | `next` | `next-best-practices` | `next-cache-components, vercel-react-best-practices` | packets writing application code in the dashboard app |
