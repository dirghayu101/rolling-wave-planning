# Adapters for batch `12-notifications`

Edit this file to swap any binding; the skill reads it, never hard-codes.

Generated at kickoff on `2026-09-09` by `references/adapters.md`. Every row is: what was chosen, what else detection found, and the one line that invokes it. Packets resolve roles and tiers against this file and nothing else.

## Model tiers

| Tier | Alias | Used for |
|---|---|---|
| `judge` | `<judge-model-alias>` | conflicting reports, design calls, grading a gate |
| `heavy` | `<heavy-model-alias>` | hard implementation, fixes, review, security pass, drafting anything a human will execute |
| `light` | `<light-model-alias>` | mapping, search, log reduction, mechanical edits, scripted flows, captures, flow diagrams, the integrity check |

Harness override available: `yes`.

## Verification tools by surface

Surfaces this batch touches: `web, backend`.

### web

- Chosen: `agent-browser`
- Alternatives detected: `Playwright CLI`
- Invocation: `agent-browser` CLI (see `references/adapters.md`)
- Geometry and focus reads: `agent-browser eval "JSON.stringify(document.querySelector(sel).getBoundingClientRect())"` for boxes; `agent-browser eval "document.activeElement.outerHTML.slice(0,120)"` for focus
- `enabled: true`

### iOS

- Chosen: `none`
- Alternatives detected: `none`
- Invocation: `n/a, no iOS surface in this batch`
- `enabled: false`

### Android

- Chosen: `none`
- Alternatives detected: `none`
- Invocation: `n/a, no Android surface in this batch`
- `enabled: false`

### backend

- Chosen: `Supabase MCP (read-only) + supabase CLI`
- Alternatives detected: `none`
- Invocation: `supabase` CLI; Supabase MCP tools for read-only inspection
- `enabled: true`

**Uncovered surfaces:** `none`

## Environment

- Chosen: `supabase start` (Supabase local stack)
- Alternatives detected: `docker compose -f docker-compose.test.yml`, `hosted dev project`
- Invocation: `supabase start`, then `supabase db reset` before each L4 run
- Seed data: `supabase/seed.sql`
- Seed convention: `supabase/seeds/<n>-<slug>.sql`, numbered in apply order; applied by `supabase db reset`, which runs them in order; each file opens with a `current_setting('app.env')` guard that aborts outside local and dev; a rerun truncates and reinserts the file's own rows; a new file is registered in `supabase/config.toml` `[db.seed] sql_paths`
- Reset: `supabase db reset`
- Docker present: `yes (docker info succeeds)`
- Forbidden by project rules: `hosted dev project, see decision 4`
- `enabled: true`

## Cleanup

What takes down everything this batch's subagents start or write.

- Scratch root: `/tmp/rwp-12-notifications/` (every packet gets its own subdirectory under it)
- Teardown lines, in the order they must run:
  1. `supabase stop` (stops the local stack `supabase start` brought up)
  2. `docker volume rm $(docker volume ls -q -f name=supabase_db_) 2>/dev/null || true`
  3. `pkill -f "vite --port 5173"` (the one dev server a web packet starts per worktree)
  4. `rm -rf /tmp/rwp-12-notifications/<dispatch dir>`
- Cache to reclaim: `docker builder prune -f`
- Kept captures: `flows/assets/<f>-<slug>-<what>.png` beside the citing flow file (or the same
  under `verification/assets/`); element PNG, under 200 KB
- Ignore rules: `/tmp/rwp-12-notifications/` is outside the repo and needs no pattern; `*.log`,
  `*.har` and `docs/**/agent/assets/` in `.gitignore`; checked with
  `git check-ignore -v <path>`
- Verified on: `2026-09-10` (each line above, and the ignore rules)

## Load testing

- Chosen: `k6`
- Alternatives detected: `autocannon`
- Invocation: `k6 run tests/load/digest-scheduler.js`
- `enabled: true`

Bound because `00-plan.md` § Testing plan states a performance criterion (the digest scheduler and 500 users).

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

## Issue tracker

Where out-of-scope findings go. Independent of the ceremony level: tracking issues are ceremony, filed findings are this binding.

- Chosen: `tea` (Gitea CLI) against `example.invalid`, the host that holds the batch tracking issue
- Detection: `tea login list` shows login `example` for `https://example.invalid`, and `tea issues list --login example --repo notifications --limit 1` returned issue 12 on `2026-09-09`
- File: `tea issues create --login example --repo notifications --title "<title>" --description "$(cat <body file>)" --labels "<labels>"`
- Title form: `[12] <title>`
- Labels: `batch:12-notifications`, plus `bug` for a defect or `enhancement` for new behavior
- List: `tea issues list --login example --repo notifications --state open`
- `enabled: true`

## Skill roles

| Role | Chosen skill | Alternatives detected | When applied |
|---|---|---|---|
| `simplicity` | `ponytail` | `none` | every implementer packet |
| `tdd` | `superpowers:test-driven-development` | `none` | every packet writing production code, including fixers |
| `debugging` | `systematic-debugging` | `superpowers:systematic-debugging` | any packet starting from a symptom |
| `flow-explorer` | `none (template only)` | `none` | feature `open` and PR ready, `light` tier, from `templates/flow.md` |
| `ui-guidelines` | `ui-ux-pro-max` | `none` | blueprint phase only |
| `ui-implementation` | `frontend-design:frontend-design` | `ui-ux-pro-max, shadcn` | screen features, wireframe path in scope |
| `browser-verification` | `agent-browser` | `none` | web features at L3 |
| `mobile-verification` | `none` | `none` | iOS or Android features at L3 (none in this batch) |
| `db-backend` | `supabase` | `supabase-postgres-best-practices, supabase-security` | packets touching the database or its generated types |
| `security-review` | `supabase-security` | `security-review (harness)` | the reviewer packet on a card-flagged sensitive surface |
| `code-map` | `none` | `none` | disabled, see Code map section above |
| `review` | `superpowers:requesting-code-review` | `feature-dev:code-reviewer` | the one reviewer packet per feature |

Stack-conditional rows. Present only when detection found the trigger in the project manifest.

| Role | Manifest trigger | Chosen skill | Alternatives detected | When applied |
|---|---|---|---|---|
| `framework` | `next` | `next-best-practices` | `next-cache-components, vercel:react-best-practices` | packets writing application code in the dashboard app |
