# Handoff packet: `<item>.<feature>` `<implement | review | verify | explore | docs>`

Copy this file, fill every slot, dispatch. The subagent has no chat context and cannot recover what is left blank. Contract and role list: `references/dispatch.md`.

`Tier:` `<judge | heavy | light>`
`Roles → skills:` `<role → skill>`, `<role → skill>`, `<role → skill>` (resolved from `02-adapters.md`; invoke each named skill yourself before you start)

## Feature (verbatim from the card)

<Copy the feature's row from the item card's feature index, unchanged: `<n>.<f>` · `<slug>` · stage. The packet's feature number and slug must match this row character for character; a packet that names a feature the card does not list is a defect, not a rename (found 2026-09-16 under test).>

## Objective

`<One sentence naming the finished state, not the activity.>`

Acceptance criteria, copied from the item card:

- [ ] `<criterion>`
- [ ] `<criterion>`

## Scope files

In scope, may be read and changed:

- `<path>`
- `<path>`
- `<wireframe path, for a screen feature: planning/03-blueprint/<screen>.html>`

Out of scope, do not change: `<paths or areas>`

`<Code-map line, only while 02-adapters.md reads enabled: true and graphify-out/graph.json exists: "Query the code map first, open only cited files. Query command: <command>.">`

## Ephemera

Everything you write outside the repo and the SSOT directory goes in ONE scratch directory, and nowhere else:

`<scratch dir under the Scratch root bound in 02-adapters.md § Cleanup, e.g. <scratch-root>/<item>.<feature>/>`

Screenshots, diff images, captured logs, temp files, dumps: all of it lands there, never beside the code and never in a directory of your own choosing. Anything that becomes evidence is copied into `assets/` before you report; everything else is torn down.

Containers, background processes and stacks you start are ephemera too. Bring them up with the invocation in `02-adapters.md` § Environment and tear them down with the matching line in `02-adapters.md` § Cleanup.

## SSOT paths to read

- `rollout/<n>-<item>/0-card.md`
- `rollout/<n>-<item>/<f>-<feature>.md`
- `working/<item>.agent.md`

Read these three and no others. Not the rest of `rollout/`, not `00-plan.md`.

## Evidence to return

- Files touched, with a line ref behind every claim
- Exact commands run, with their output
- `<Surface evidence: screenshots at <breakpoints>, console and network capture, query results, test output>`
- **Ephemera started:** one row per container, background process, temp dir or temp file you created, with the command that tears it down. Write `none` only if you started nothing. This list is required; a report without it is incomplete.
- Uncertainties, listed explicitly. An empty list means you are certain, so do not write one unless you are.

## Stop conditions

Stop and report `BLOCKED: <what, where, what would unblock it>` when any of these is true. Do not improvise past one.

- The code does not match this packet's premise.
- A command fails after one reasonable retry.
- The work needs a file outside the scope list.
- Two readings of the acceptance criteria disagree.
- `<Task-specific stop condition.>`

---

## Dispatch record

Paste this row into `working/<item>.agent.md` under `## Dispatch record` at dispatch time, and fill `Outcome` when the agent returns.

| Date | Packet | Tier | Roles → skills | Outcome |
|---|---|---|---|---|
| `<date>` | `<item>.<feature> <kind>` | `<tier>` | `<role → skill, role → skill>` | `<returned or BLOCKED: reason>` |

## Ephemera ledger

Paste one row per line of the returned "Ephemera started" list into `working/<item>.agent.md` under `## Ephemera`, when the agent returns. `Swept on` stays empty until the teardown command has actually been run.

| What | Where | Teardown | Swept on |
|---|---|---|---|
| `<container, process, temp dir, screenshot set>` | `<path or container name>` | `<the one command that removes it>` | `<YYYY-MM-DD, or kept: reason>` |
