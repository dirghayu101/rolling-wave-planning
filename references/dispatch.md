# Dispatch

Loaded when the lifecycle reaches a step that hands work to a subagent: exploration, implementation, review, agent-side verification, docs. Defines the handoff packet and the role list. The bindings (which skill, which tool, which model alias) are NOT here: they live in the batch's `02-adapters.md`, generated at kickoff by `references/adapters.md`.

**Token economy:** the orchestrator does judgment only: decomposition, synthesis, the interview, final review. Reading-heavy work (repo exploration, doc sweeps, log reduction) goes to cheaper models with self-contained handoff packets: objective, scope, evidence format to return (files, line refs, uncertainties), stop conditions. Treat subagent reports as leads: reopen the cited files for anything a decision will rest on. *(Retained from v1 `pre-rolling-wave-planning` § Overview.)*

Packet-writing craft (what to include, what the subagent cannot see, how to phrase stop conditions) lives in `efficient-fable` § Handoff Packets. Load that skill when you need the craft. This file states only the contract that a rolling-wave packet must satisfy.

## The packet: seven required slots

Every dispatch is a written packet with all seven. Copy `templates/handoff.agent.md` and fill it. A missing slot is not shorthand, it is a defect: the subagent has no chat context and cannot recover what the packet leaves out.

1. **Objective.** One sentence naming the finished state, plus the acceptance criteria copied from the item card. Not "look at X"; "make X true, proven by Y".
2. **Scope files.** The files the subagent may open and change, and what is explicitly out of scope. For a screen feature, include the wireframe path (`planning/03-blueprint/<screen>.html`).
3. **SSOT paths to read.** Exactly three by default: the item card (`rollout/<n>-<item>/0-card.md`), the feature file (`rollout/<n>-<item>/<f>-<feature>.md`), and the item's working file (`working/<item>.agent.md`). Never the whole `rollout/` tree, and never `00-plan.md` unless the task is batch-scoped. The O(1) resume budget applies to subagents too.
4. **Roles → skills.** Resolve each role the task needs against the Skill roles section of `02-adapters.md` and write the resolved pair on the packet (`simplicity → ponytail`). The subagent invokes each named skill itself at task start. Never paraphrase a skill's content into a packet: paraphrase goes stale the moment the skill is updated, and the subagent then runs a fork of it.
5. **Tier.** One of `judge`, `heavy`, `light`, chosen by role (below). The harness-specific model behind each tier is bound in the Model tiers section of `02-adapters.md`. **A packet without a tier is a red flag**: subagents inherit the orchestrator's model, so an unset tier silently spends the most expensive one.
6. **Evidence to return.** Name the shape: files touched, line refs for every claim, exact commands run with their output, screenshots or query results where the surface allows, and an explicit uncertainties list. "It works" is not evidence.
7. **Stop conditions.** The BLOCKED contract: if the code does not match the packet's premise, a command fails after one reasonable retry, the task needs a file outside scope, or two readings of the acceptance criteria disagree, **stop and report `BLOCKED: <what, where, what would unblock it>`**. Improvising past a blocked premise is what the stop condition exists to prevent.

## Tiers, by role

| Tier | Role of the work | Typical dispatches |
|---|---|---|
| `judge` | Deciding between conflicting evidence or reports, resolving a design call, grading a gate | Kept with the orchestrator; dispatched only for an independent second opinion |
| `heavy` | Hard implementation, code review, security review, the rogue-check, drafting a docs chapter | Implementer, reviewer, security pass, docs writer fallback |
| `light` | Repo mapping, search, log reduction, mechanical edits, screenshot capture, running a scripted flow, grading a scenario checklist | Exploration, L3 browser or mobile pass, visual diff, formatting |

Tier is a property of the **role**, not of the file size. A one-line change behind a subtle auth boundary is `heavy`; a 600-line mechanical rename is `light`.

## Separation of agents

- **Fresh context per packet.** One packet, one agent, one context. Reusing an agent for the next feature carries its earlier conclusions in as unexamined priors.
- **Implementer ≠ reviewer ≠ verifier.** The agent that wrote the diff cannot review it and cannot be the one that drives the browser or the simulator against it. An agent asked to find fault in its own output reliably finds none.
- Review findings go to a **fresh** fix agent, then a scoped re-review. See `references/review.md`.

## Recording the dispatch

Append one row per dispatch to `working/<item>.agent.md` under `## Dispatch record`:

```
| Date | Packet | Tier | Roles → skills | Outcome |
```

The rogue-check reads this table plus `02-adapters.md` as evidence that the tiers and roles claimed at kickoff were the ones actually used. A dispatch that never appears here did not happen, as far as any later session can tell.

## Roles

Stable roles. The **default** column is what detection found on this machine on 2026-09-16; `02-adapters.md` is the binding, so read it rather than trusting this column. Plugin skills are namespaced in the harness listing (`superpowers:test-driven-development`, `feature-dev:code-reviewer`, `frontend-design:frontend-design`).

| Role | Work it covers | Default skill | Alternatives detected | When it goes on a packet |
|---|---|---|---|---|
| `simplicity` | Questioning whether the work must exist, then the smallest solution that passes | `ponytail` | none | **Every implementer packet**, without exception |
| `tdd` | Red, green, refactor; one test per exit point | `superpowers:test-driven-development` | none | Every packet that writes production code |
| `debugging` | Root-causing a symptom before any fix is proposed | `systematic-debugging` | `superpowers:systematic-debugging` | Any packet whose objective starts from a symptom rather than from a change |
| `ui-guidelines` | UX guideline lookup for a screen being designed | `ui-ux-pro-max` | `web-design-guidelines`, `adhd-design-expert` | **Blueprint phase only.** Lookup, not implementation |
| `ui-implementation` | Building a screen from the approved wireframe | `frontend-design:frontend-design` | `ui-ux-pro-max`, `adhd-design-expert`, `shadcn`, `shadcn-ui`, `web-design-guidelines` | Any screen feature, with the wireframe path in scope files |
| `browser-verification` | Driving the real page, console and network capture, screenshots at the relevant breakpoints | `agent-browser` | none (standing rule: this is the only browser tool on this machine) | Every feature with a web surface, at ladder level L3 |
| `mobile-verification` | Driving the app on a simulator or a device | none installed as a skill; bound to the mobile row of `02-adapters.md` | see `references/adapters.md` § Mobile verification | Every feature with an iOS or Android surface, at L3 |
| `db-backend` | Schema, migrations, policies, queries, logs, generated types | `supabase` | `supabase-postgres-best-practices`, `supabase-security` | Any packet touching the database or anything generated from it |
| `security-review` | Auth boundaries, tenant isolation, key handling, policy tests | `supabase-security` | `security-review` (harness), `supabase-postgres-best-practices` | Reviewer packet for any feature the card flags as a sensitive surface |
| `docs-conventions` | The reader-facing chapter contract | `human-engineering-docs` | `documentation-writer` | The docs packet at feature `documented`; see `templates/doc-handoff.md` |
| `code-map` | Whole-repo structural queries in place of blind file reads | `graphify` (skill installed once globally by `graphify install`; the graph itself is built per project) | none | **Only** when the code-map row in `02-adapters.md` reads `enabled: true` and `graphify-out/graph.json` exists. Then every exploration and implementer packet carries the line: *"query the code map first, open only cited files"* |
| `review` | Correctness, reuse, conventions review of a finished diff | `superpowers:requesting-code-review` | `feature-dev:code-reviewer` | Every reviewer packet. The fix agent that receives the findings carries `superpowers:receiving-code-review` |

Stack-conditional roles. These appear in `02-adapters.md` only when detection finds the dependency in the project manifest.

| Role | Trigger in the manifest | Default skill | Alternatives detected | When it goes on a packet |
|---|---|---|---|---|
| `payments` | `stripe`, `@stripe/*` | `stripe-best-practices` | `stripe-projects` | Any packet touching checkout, subscriptions, connected accounts, or webhook handling |
| `framework` | `next` | `next-best-practices` | `next-cache-components`, `vercel-react-best-practices`, `tanstack-query-best-practices` | Any packet writing application code in that framework |
| `framework` | `react-native`, `expo` | `vercel-react-native-skills` | `react-native-animations`, `expo-cicd-workflows`, `sentry-react-native-sdk` | Same |

## No role fits the task shape

Do not invent a binding and do not dispatch bare. Run the description grep:

1. Name the task shape in three to six words and pick two or three keywords from it.
2. Grep descriptions only, not bodies:
   `awk '/^description:/{print FILENAME": "$0}' ~/.agents/skills/*/SKILL.md | grep -i '<keyword>'`
   Then scan the harness skill listing for namespaced plugin skills, which do not live in that directory.
3. Read the frontmatter description of each hit. Choose on what the description says it triggers on, never on how the skill's name sounds.
4. **Exactly one fits**: name it on the packet and add a row to the Skill roles section of `02-adapters.md` (role name, chosen skill, alternatives, when applied) so the next packet resolves it without repeating this.
5. **None fits**: dispatch without a skill for that shape, say so in the packet, and record `no role` in the dispatch record. The gap is then visible at the next kickoff's detection round.
6. **Two or more fit**: that is a kickoff decision, not a dispatch-time call. Ask the user, then record the answer in `02-adapters.md`.

## Red flags

- A packet without a tier.
- A packet that pastes a skill's content instead of naming the skill.
- A packet naming a skill that is not a row in `02-adapters.md`.
- An implementer packet without `simplicity`.
- The agent that wrote the diff reviewing it, verifying it, or writing its chapter.
- A packet whose SSOT paths list the whole `rollout/` tree, or `00-plan.md` for item-scoped work.
- A dispatch that never reached `working/<item>.agent.md`.
- A subagent report used as the basis of a decision without reopening the cited files.
- "The subagent has the context from last time." Every packet assumes a cold agent.
- A `code-map` line on a packet when the row reads `enabled: false` or `graphify-out/graph.json` is absent.
