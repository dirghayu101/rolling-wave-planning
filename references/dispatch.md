# Dispatch

Loaded when the lifecycle reaches a step that hands work to a subagent: exploration, flow drawing, implementation, review, agent-side verification. Defines the packet, the roles, the tiers and the concurrency constraints. The bindings live in the batch's `agent/adapters.md`.

**Token economy:** the orchestrator does judgment only, meaning decomposition, synthesis, the interview and the final call. Reading-heavy work goes to cheaper tiers with self-contained packets. Treat subagent reports as leads: reopen the cited files for anything a decision will rest on.

Packet-writing craft lives in `efficient-fable` § Handoff Packets. This file states only the contract.

## The packet: eight required slots

Copy `templates/handoff.agent.md` and fill it. A missing slot is a defect: the subagent has no chat context.

1. **Objective.** One sentence naming the finished state, plus the acceptance criteria copied from the card. Not "look at X"; "make X true, proven by Y".
2. **Scope files.** What the subagent may open and change, and what is explicitly out of scope. For a screen feature, include the wireframe path.
3. **Ephemera.** ONE scratch directory, named on the packet, for everything written outside the repo and the SSOT. The scratch root comes from `agent/adapters.md` § Cleanup. Containers and stacks come up and go down through that same section.
4. **SSOT paths to read.** Exactly three by default: the card (`agent/<n>-<item>/0-card.md`), the feature's HEAD file, and the feature's `.log.md`. Never the whole `agent/` tree, and never `00-plan.md` unless the task is batch-scoped.
5. **Roles to skills.** Resolve each role against `agent/adapters.md` and write the resolved pair on the packet (`simplicity → ponytail`). The subagent invokes each named skill itself. Never paraphrase a skill into a packet.
6. **Tier.** One of `judge`, `heavy`, `light`. **A packet without a tier is a red flag**: subagents inherit the orchestrator's model, so an unset tier silently spends the session model on work a cheaper tier could do.
7. **Evidence to return.** Files touched, line refs behind every claim, exact commands with their output, captures where the surface allows, an explicit uncertainties list, and the **Ephemera started** list with a teardown command per row, or `none`.
8. **Stop conditions.** The BLOCKED contract: if the code does not match the packet's premise, a command fails after one reasonable retry, the task needs a file outside scope, or two readings of the acceptance criteria disagree, **stop and report `BLOCKED: <what, where, what would unblock it>`**.

**Subagents never edit SSOT files.** They return facts; the orchestrator, or one light scribe, writes them down. Say this on every packet.

## Tiers, by role

| Tier | Role of the work | Typical dispatches |
|---|---|---|
| `orchestrator` | The session itself: decomposition, packets, vetting, synthesis | Never dispatched |
| `judge` | Escalation on the triggers in § Escalating to the judge; dispatched; inert when bound to the same model as `orchestrator` | One judge packet per feature by default |
| `heavy` | Hard implementation, code review, security review, drafting anything a human will execute | Implementer, fixer, reviewer, verification-file author, runbook author |
| `light` | Repo mapping, search, log reduction, mechanical edits, capture, running a scripted flow, drawing a flow diagram, the integrity check | Exploration, flow-explorer, L3 browser pass, integrity check |

Tier is a property of the **role**, not the file size. A one-line change behind a subtle auth boundary is `heavy`; a 600-line mechanical rename is `light`. **Drafting a document a human will execute is `heavy`**, and so is editing one.

## Escalating to the judge

The session runs on the model bound as `orchestrator`. When it hits a judgement it may get wrong, it dispatches the `judge` tier. **When `judge` and `orchestrator` are bound to the same model, the judge is inert**: the orchestrator decides itself and says so in the Used-for cell of `agent/adapters.md`.

**Mandatory triggers.**

- **T1.** Two reports disagree on a fact a decision rests on, and reopening the cited files did not settle it.
- **T2.** A choice between two or more fixes whose correctness turns on semantics the orchestrator cannot state in one sentence (supersession, concurrency, money, auth boundaries), and no test can tell them apart before choosing.
- **T3.** Before a design-question round to the developer that changes a formula, a money path or a persisted shape, the judge vets the question set.

**Discretionary:** a reviewer finding the orchestrator is inclined to dismiss; a legibility or UX call with no measurable criterion.

**Never a judge question:** anything a test, query or browser read can settle; copy; packets; records; test triage; anything the developer owns.

**Budget:** one judge dispatch per feature by default. A second one names on its packet why the first did not settle it.

**Developer only.** These go to the developer, never to the judge: scope, pricing and money decisions, behaviour visible to customers or staff, anything touching production, trade-offs between constraints the developer stated. The judge may sharpen those questions (T3); it never answers them.

**The judge packet**, under 60 lines, replaces the eight slots above:

1. **Question.** One sentence.
2. **Options.** Two to four, one line each, with the orchestrator's current lean and why.
3. **Evidence.** `file:line` refs, and the one command output that matters.
4. **Rulings.** The developer's rulings that constrain the answer, verbatim.
5. **Constraints.**
6. **Return shape.** The block below.

The judge reads the brief and may open only the cited files. If it needs more, it returns `NEED: <file or fact>` instead of exploring. It never dispatches subagents, never writes files and never takes over the task.

**Return**, about 150 words:

```
Verdict: <one line>
Why: <at most five lines>
Confidence: <low | medium | high>
What would change my mind: <one fact>
Developer question: <yes | no>, <the one-line question>
Ruling conflict: <why>        (optional)
```

One-shot. A follow-up on the same question goes to the same agent via SendMessage, not a fresh dispatch.

**Authority.** The verdict is advisory, but the orchestrator overrules it only by stating a contradicting fact in the log row. Developer rulings always win. A `Ruling conflict` line is relayed to the developer in one sentence and never acted on.

**Recording.** One Dispatch row in the feature's `.log.md`, Tier `judge`, Outcome `verdict: <one line> · followed` or `verdict: <one line> · overruled: <fact>`. Nothing else.

## Separation of agents

- **Fresh context per packet.** One packet, one agent, one context.
- **Implementer, reviewer and fixer are three different agents.** An agent asked to find fault in its own output reliably finds none.

## Concurrency

The orchestrator decides what runs in parallel per flow. Only these constraints always hold:

- **A branch holds one implementer.** Two agents writing the same branch produce a merge nobody planned.
- **An in-flight feature that overlaps another gets its own git worktree.** Overlap means the same files, the same module, or the same generated artifact.
- **One dev server per worktree**, started and killed by the packet that needs it, and recorded as an ephemera row. A server left behind serves the wrong tree to the next browser pass.
- **A feature that changes the schema runs exclusively.** Nothing else is in flight while a migration lands, because every other worktree's generated types go stale the moment it applies.
- **A packet that assumes another in-flight feature's exports names them and the SHA it read them at.** A review finding that changes those exports means a rebase, not a patch on top.
- **No agent touches dev while a verification window is open.** While a verification pass is running on dev, `db:apply`, a dev reseed and a schema rehearsal against dev are all off, whatever else is in flight. `00-plan.md` STATE carries a `verification_window:` line for as long as the pass is open, and the orchestrator deletes it when the ticks are in.

Do not write model-specific, harness-specific or token-budget limits into a batch. Those change; these constraints do not.

## Recording the dispatch

Append one row per dispatch to the feature's `agent/<n>-<item>/<f>-<slug>.log.md` under `## Dispatch`:

```
| Date | SHA | Packet | Tier | Roles → skills | Outcome |
```

Append is the only operation. A dispatch that never appears here did not happen, as far as any later session can tell.

When the agent returns, transcribe its **Ephemera started** list into `## Ephemera` in the same file:

```
| What | Where | Teardown | Swept on |
```

`Swept on` is filled only when the teardown has been run, or replaced by `kept: <reason>`. This is the one column in a LOG file that is written twice, and only ever from empty to a date.

## Roles

Stable roles. `agent/adapters.md` is the binding; the default column is what detection typically finds.

| Role | Work it covers | Default skill | When it goes on a packet |
|---|---|---|---|
| `simplicity` | Questioning whether the work must exist, then the smallest solution that passes | `ponytail` | **Every implementer packet** |
| `tdd` | Red, green, refactor; one test per exit point | `superpowers:test-driven-development` | Every packet writing production code, including fixer packets |
| `debugging` | Root-causing a symptom before any fix is proposed | `systematic-debugging` | Any packet whose objective starts from a symptom |
| `flow-explorer` | Reading an existing flow and drawing it as a Mermaid diagram with file, symbol and permalink per node | none installed; `light` tier plus `templates/flow.md` | Feature `open` for the before diagram, PR ready for the after diagram |
| `ui-guidelines` | UX guideline lookup for a screen being designed | `ui-ux-pro-max` | Blueprint phase only |
| `ui-implementation` | Building a screen from the approved wireframe | `frontend-design:frontend-design` | Any screen feature, with the wireframe path in scope |
| `browser-verification` | Driving the real page, console and network capture, geometry and focus reads, screenshots | `agent-browser` | Every feature with a web surface, at L3 |
| `mobile-verification` | Driving the app on a simulator or a device | bound in `agent/adapters.md` | Every feature with an iOS or Android surface, at L3 |
| `db-backend` | Schema, migrations, policies, queries, logs, generated types | `supabase` | Any packet touching the database or anything generated from it |
| `security-review` | Auth boundaries, tenant isolation, key handling, policy tests | `supabase-security` | The reviewer packet for any feature the card flags |
| `code-map` | Whole-repo structural queries in place of blind file reads | `graphify` | **Only** when the code-map row reads `enabled: true` and its graph exists |
| `review` | Correctness, reuse, conventions review of a finished diff | `superpowers:requesting-code-review` | Every reviewer packet. The fixer carries `superpowers:receiving-code-review` |

Stack-conditional roles appear in `agent/adapters.md` only when detection finds the dependency in the project manifest: `payments` on a `stripe` dependency, `framework` on `next`, `react-native`, `expo` or `@capacitor/core`.

## No role fits the task shape

Do not invent a binding and do not dispatch bare.

1. Name the task shape in three to six words and pick two or three keywords.
2. Grep descriptions only: `awk '/^description:/{print FILENAME": "$0}' ~/.agents/skills/*/SKILL.md | grep -i '<keyword>'`. Then scan the harness listing for namespaced plugin skills.
3. Choose on what the description says it triggers on, never on how the name sounds.
4. **Exactly one fits**: name it on the packet and add a row to `agent/adapters.md`.
5. **None fits**: dispatch without a skill for that shape, say so in the packet, record `no role` in the dispatch row.
6. **Two or more fit**: that is a kickoff decision. Ask the user, record the answer in `agent/adapters.md`.

## Red flags

- A packet without a tier, or without the "you never edit SSOT files" line.
- A packet with no Ephemera slot, or one naming a scratch path outside the bound root.
- A returned report with no "Ephemera started" list.
- A packet that pastes a skill's content instead of naming the skill.
- An implementer packet without `simplicity`, or a fixer packet without `tdd`.
- A packet whose SSOT paths list the whole `agent/` tree.
- Two implementers on one branch, or a second feature in flight against a schema change.
- A packet that depends on another in-flight feature's exports without naming them and their SHA.
- A dev server started by one packet and used by another.
- A subagent report used as the basis of a decision without reopening the cited files.
- A model name written where a tier belongs.
- A judge packet without a Rulings slot.
- A judge dispatched on a question the developer owns.
- A judge verdict overruled without a contradicting fact in the log row.
