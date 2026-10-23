# Verification

Reference for `rolling-wave-planning`. Load it at a verification transition, and at `phase: done` for the promotion pass. `references/review.md` covers who reads the code; this file covers what proves it works.

## Two stages: verify on dev, then deploy through the runbooks

One flow, two stages, and the second one starts when the first is done.

**Stage one is the dev pass.** It lives in `verification/`. It runs on dev, from the batch branch
served locally against the dev database, **before any merge**, and it **needs no production access**.
Its rows are run by hand, never by an agent.

**Stage two is the production stage.** It lives in `runbooks/`: procedures run by hand, never by an
agent, after the dev pass and the merge. Migrations in order with preflight, apply, post-check and
rollback; the dashboard release and its tag; the app tag or OTA push; the version bump. A runbook's
post-check is the production-side verification of the same flow: it proves the change landed. It is
never copied into a verification file as a row, because it cannot run before the deploy and it needs
access the dev pass does not have.

The hard rule: **nothing in `verification/` names production**, not a production console, not a
production credential, not a `*:prod` command, not a migration push. A check that can only run
against production is not a verification row. It is a runbook step, and it moves to
`runbooks/<k>-<slug>.md`.

**Order of events at the end of a batch.** The code is reviewed through the PRs. The dev pass runs
on `verification/`. Then `runbooks/` is worked through in order, by hand: merge the batch to the
trunk, run the migrations in the stated order, release the dashboard, tag or ship the app.
`runbooks/0-release.md` sequences that stage, and the project's own release conventions govern its
details.

**Verification files and use cases are different instruments.** A verification file specifies an exact flow and its observables, row by row, with the query or command pasted ready to use. A use case (`use-cases/`) states only a goal, with no steps, and the developer runs the `ready` ones freely on dev and finds the how themselves, which is how a missing feature or a confusing flow shows up. The dev-pass hand-back names both: the verification files to run and the use cases ready to try.

## Data under test

**A flow is tested on the data its users will have in front of them, not on the rows that were
quick to write.** A seed of a few rows made this week, one per status, passes every layer and still
hides the defects that only show with six months of rows, a week with no activity, a period boundary
or a third store.

**Data horizon.** Stated per feature, in product terms: the longest span of time, the largest volume,
and the full set of states and groupings that the people using the feature will have in front of
them once the product has run for a while. Example: a store that has taken orders for six months;
every status of a request including closed and reversed; three stores, one with no requests; a week
with no sends.

**Seed convention.** The project's own way of writing seed data, bound in `agent/adapters.md`
§ Environment: where seed files live and how they are named and ordered, the command that applies
one, the guard that keeps it off production, what a rerun does, and where a new file is registered.
The skill names none of these; the binding does.

The seed the feature's flows run on is checked against the horizon on five dimensions:

| Dimension | Sufficient when the seed holds |
|---|---|
| **span** | rows older than the longest period any screen or report in the feature reads, plus one empty period beyond it |
| **volume** | enough rows that paging, totals, sorting and any stated performance number mean something |
| **states** | every state of every entity the feature reads, including terminal and reversed ones |
| **spread** | every grouping the feature offers: tenant, store, role, channel; at least one group with zero rows |
| **edges** | a row exactly on a period boundary, a timezone day boundary, the oldest row, the empty period |

The verdict is one line in the feature file: `Seed: sufficient at <SHA>`, or
`Seed: insufficient: <dimension>, <dimension>`.

**An insufficient seed is written before L2 to L4 run.** It is the feature's first task, written by
the `heavy` tier because the shapes are business judgement, under the bound seed convention, on the
feature's own stack. It carries its own rerun check: a rerun refreshes or no-ops, and the row counts
are asserted after each run. It is committed with the feature and registered wherever the convention
registers a new seed. **No convention bound** means the first seed feature writes one and records it
in `agent/adapters.md` § Environment and the project's `adapters.default.md`.

**L5 runs on dev, so the same seed is applied on dev before the verification window opens**, and the
verification file's `Seed on dev:` line names it. The window rule is unchanged.

When a layer builds its own rows, as L1 unit does, the horizon does not apply to it.

## The ladder

Five layers. **A layer is climbed, not skipped.** Everything an agent can observe is L1 to L4 and is finished before anything reaches a human.

| Layer | Scope | Proves |
|---|---|---|
| **L1 unit** | one unit | each exit point behaves |
| **L2 integration** | one seam | the boundary is really crossed |
| **L3 real surface** | one feature | the surface a user touches actually does it |
| **L4 cross-feature** | one item, or a defined cross-item group | the features work together, in the environment the plan names |
| **L5 human-only** | whatever is left | what only a human can do or perceive |

### L1 unit

TDD, red before green, under the `tdd` role. **One test per exit point**, and exactly three kinds of exit point exist: a return value or thrown error, a state change observed through another public call, and a call to an outgoing dependency asserted on a mock. Never two exit points in one test. Incoming dependencies are stubbed and never asserted on; at most one mock per test. If the project ships its own testing conventions file, that file governs the details.

### L2 integration seams

The boundaries this feature crosses are **actually exercised**, not mocked away on both sides: the database call hits a real test database, the edge function is invoked, the auth boundary is crossed with a real token. A seam mocked on both sides proves only that the mocks agree.

### L3 real surface

**This is the pass that finds real defects.** Every defect worth the name in the last batch came from a browser measurement or a fresh-eyes code review, never from a document. Run it on every UI change, through the adapter bound in `agent/adapters.md`.

Web, under the `browser-verification` role:

- Drive the flow the feature delivers, end to end. Assert on the rendered element or state.
- `console --clear` before the flow, `errors --json` after, clean of new errors.
- `network requests` for the calls the change is supposed to make.
- **Geometry reads** wherever layout changed: measure the box, not the screenshot. Overflow, clipping, wrap, column width, sticky offsets, and the values at each breakpoint the feature claims.
- **Focus reads** wherever keyboard or dialog behavior changed: what holds focus after open, after close, after submit, and what the tab order is.
- A screenshot at every breakpoint the feature claims to support.
- When the feature builds a screen from a wireframe, run the wireframe comparison in `references/blueprint.md` and log its diff.

Mobile, under `mobile-verification`: the bound tool, driving the same shape of flow.

**No adapter bound for the surface** is an **uncovered surface**, which is a recorded kickoff decision in `00-plan.md`. The L3 row then reads `uncovered: see decision <#>` and the work it would have proven moves to L5. A blank L3 row with no decision behind it is drift.

### L4 cross-feature

The item's features exercised **together**, not one after another: the flow that crosses two of them, the shared type or migration both depend on, the screen that renders another feature's data. Runs when every feature PR has merged into the item branch, and it gates the item's `built` stage.

It runs in the environment the card names. Cross-item groups are defined in `00-plan.md` § Testing plan, recorded on the later item, and their row moves from `pending` to `ran <date>`.

When the card's `Non-functional:` line states a criterion, the bound load tool measures it as part of L4, and the measured numbers go in the evidence entry beside the command that produced them.

### L5 human-only, on dev

What no bound tool can perform or perceive. Invoke `human-assisted-verification` to write these files; it owns their shape. They live in `verification/`, they run on dev, and they are run by hand **after** the batch branch is delivered, often per cross-feature group rather than per feature.

**The surface is always the app run locally from the batch branch, against the dev database.** A preview deployment would need a merge to dev, which has not happened at verification time. The batch's `agent/adapters.md` names the start command, and every verification file's Setup line states this rule rather than a URL somebody has to guess at.

**The verification window.** While a verification pass is running on dev, no agent runs `db:apply`, reseeds dev, or rehearses a schema change against dev. The orchestrator writes one `verification_window:` line into `00-plan.md` STATE when the pass is handed over and deletes it when the ticks are in. This constraint is always true, not only inside a batch that is executing.

**A schema-only feature**, whose only human-observable effect is the production post-check, gets a runbook plus a verification file with the replay section only: the post-check SQL run on the **dev** console as a replay. The file then carries one explicit line, `No judgement rows: nothing here is observable on dev beyond the replay; production evidence is runbook <k> step <n>.` Do not invent judgement rows to fill the table.

## Evidence entries

Evidence is appended to the feature's `agent/<n>-<item>/<f>-<slug>.log.md`, one entry per layer climbed, never edited afterwards:

```markdown
| date | sha | layer | evidence | by |
|---|---|---|---|---|
| 2026-09-23 | 4f1c9a2 | L1 | `tests/unit/quota.test.ts`, 7 exit points green | tdd · heavy |
| 2026-09-23 | 4f1c9a2 | L3 | `agent/assets/4.2-quota-1440.png`, errors --json empty, POST /api/quota 200, table width 1128px at 1440 | browser-verification · light |
```

**Evidence is a pointer to something re-openable**: a test path, a CI run, a capture under `agent/assets/`, the query plus the row it returned. "Verified, works" is not evidence. `by` is the role and tier, never a model name.

**Durable observable first.** Assert on durable state wherever the behavior produces one. Logs are primary only for fire-and-forget calls with no persisted trace, and a log-based entry is flagged **time-sensitive (24h)**.

**The SHA is the pin.** An entry is true at its SHA and stays written that way forever. A later commit that changes the file does not invalidate the entry and does not get re-pinned; it gets a new entry.

## Confidence: one line

The feature file carries exactly one line:

```
Confidence: agent 62 / ceiling 88
```

`agent` is what the L1 to L4 evidence proves today. `ceiling` is the same judgement with every L5 row in this feature's verification file assumed PASS. **The ceiling is reached only when the verification file's rows are ticked.**

Judge it against six dimensions: unit coverage of exit points, integration seams actually exercised, real-surface verification driven, review findings raised versus resolved, unverifiable effects honestly listed, environment fidelity and stated limits measured.

Environment fidelity counts the seed: L3 and L4 evidence gathered on a seed insufficient against the
data horizon does not prove the flow the horizon describes.

**No re-derivation prose.** No paragraph explaining why the number did or did not move, no "re-derived at <stage>" history, no dated chain. Set the number, move on. If the number changes, overwrite it.

**One "what would raise this" list**, and only for raises that need a human or tooling that does not exist. Anything an agent can execute is *done*, not listed.

## Promotion to `verified`

The `verification/` files are ticked by hand on dev, whenever there is time for them, with no session running. **Those ticks are the only thing that promotes an item from `merged` to `verified`.** A runbook's production post-check is deploy evidence: it proves the change landed, and it never feeds the confidence score and never promotes an item.

- **The resume sweep promotes.** Every resume reads the `verification/` files for verdicts that have been ticked, and moves any item whose rows are all PASS from `merged` to `verified` in the same commit as the tick it is acting on.
- **A group file promotes more than one item.** Its header names every feature and item it spans.
- **A FAIL is a mid-flight input**, triaged per `references/resume.md`.
- **No human-verifiable surface** (pure tooling, internal refactor)? Record the substitute in the card (fault injection, a CI gate, a migration dry-run) and say so in § Hand-back. Never drop the file silently.

An agent never writes a verdict cell.

## Red flags

- **A verification row that names production**: a production console, a production credential, a `*:prod` command, a migration push. That is a runbook step.
- A production post-check duplicated into a verification file as a human row.
- A verification file pointing at a deployed preview or a URL instead of the app run locally from the batch branch against dev.
- An agent running `db:apply`, a dev reseed or a schema rehearsal on dev while a `verification_window:` line is open in STATE.
- A schema-only feature given invented judgement rows instead of a replay-only file and its `No judgement rows` line.
- An L5 row holding something a bound adapter could have checked.
- A verdict cell reading anything but `open` in a file the agent just wrote.
- A confidence line carrying a paragraph, a history, or one number.
- An evidence entry with no SHA, or one that was edited to point at a newer commit.
- A UI change with no geometry or focus read where layout or keyboard behavior changed.
- A seam "tested" with a mock on both sides.
- A log-based entry with no `time-sensitive (24h)` flag.
- An item at `built` whose card's `How it was tested:` line is empty.
- An agent-actionable entry still on "what would raise this" at feature close.
- A feature that reads data over time with no `Data horizon:` line, or a horizon written as row counts instead of product terms.
- A report, a per-period rate, a total or a paged list tested on a few rows made this week, one per status.
- A seed shortfall deferred to a later feature instead of written first.
- A seed written as an ad-hoc edit to whatever seed file exists, outside the bound convention, or with no rerun check.
- A `Seed: sufficient` verdict with no SHA.
- An L5 pass handed over before its seed was applied on dev.
