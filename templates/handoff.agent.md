# Handoff packet: `<item>.<feature>` `<implement | fix | review | verify | explore | flow>`

Copy this file, fill every slot, dispatch. The subagent has no chat context and cannot recover what is left blank. Contract and role list: `references/dispatch.md`.

`Tier:` `<judge | heavy | light>`
`Roles → skills:` `<role → skill>`, `<role → skill>` (resolved from `agent/adapters.md`; invoke each named skill yourself before you start)

**You never edit SSOT files.** Return facts; the orchestrator writes them down.

## Feature (verbatim from the card)

<Copy the feature's row from the card's feature index, unchanged: `<n>.<f>` · `<slug>` · stage. The packet's feature number and slug must match this row character for character.>

## Objective

`<One sentence naming the finished state, not the activity.>`

Acceptance criteria, copied from the item card:

- [ ] `<criterion>`
- [ ] `<criterion>`

## Scope files

In scope, may be read and changed:

- `<path>`
- `<wireframe path, for a screen feature: planning/03-blueprint/<screen>.html>`

Out of scope, do not change: `<paths or areas>`

`<Cross-feature dependency, when another feature is in flight: "This packet assumes <exports> from <feature>, read at <sha>. If they differ, stop and report BLOCKED.">`

`<Code-map line, only while agent/adapters.md reads enabled: true and the graph exists: "Query the code map first, open only cited files. Query command: <command>.">`

## Ephemera

Everything you write outside the repo and the SSOT goes in ONE scratch directory, and nowhere else:

`<scratch dir under the Scratch root bound in agent/adapters.md § Cleanup>`

Containers, background processes, dev servers and stacks you start are ephemera too. Bring them up with the invocation in `agent/adapters.md` § Environment and tear them down with the matching line in § Cleanup. **One dev server per worktree, started and killed by this packet.**

## SSOT paths to read

- `agent/<n>-<item>/0-card.md`
- `agent/<n>-<item>/<f>-<slug>.md`
- `agent/<n>-<item>/<f>-<slug>.log.md`

Read these three and no others. Not the rest of `agent/`, not `00-plan.md`.

## Evidence to return

- Files touched, with a line ref behind every claim
- Exact commands run, with their output
- `<Surface evidence: the rendered state asserted, console and network capture, geometry and focus reads, screenshots at <breakpoints>, query results, test output>`
- **Ephemera started:** one row per container, process, temp dir or temp file you created, with the command that tears it down. Write `none` only if you started nothing.
- Uncertainties, listed explicitly.

## Stop conditions

Stop and report `BLOCKED: <what, where, what would unblock it>` when any of these is true. Do not improvise past one.

- The code does not match this packet's premise.
- A command fails after one reasonable retry.
- The work needs a file outside the scope list.
- Two readings of the acceptance criteria disagree.
- `<Task-specific stop condition.>`

---

## Log rows the orchestrator appends

Into `agent/<n>-<item>/<f>-<slug>.log.md`. Append only.

`## Dispatch`

| Date | SHA | Packet | Tier | Roles → skills | Outcome |
|---|---|---|---|---|---|
| `<date>` | `<sha at dispatch>` | `<item>.<feature> <kind>` | `<tier>` | `<role → skill>` | `<returned or BLOCKED: reason>` |

`## Ephemera`, one row per line of the returned list. `Swept on` stays empty until the teardown has run.

| What | Where | Teardown | Swept on |
|---|---|---|---|
| `<container, process, temp dir, capture set>` | `<path or name>` | `<the one command that removes it>` | `<YYYY-MM-DD, or kept: reason>` |
