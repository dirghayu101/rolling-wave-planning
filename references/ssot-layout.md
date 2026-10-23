# SSOT layout

Reference for `rolling-wave-planning`. Load it when a batch is being scaffolded, or when a file's home is in question. A batch whose STATE reads `layout: v1` or `layout: v2` loads `references/migration-3.md` instead.

## The split

Seven entries the developer opens (the plan file and six directories). One the developer never opens.

```
<N>-<slug>/
  00-plan.md        STATE, decisions, testing plan, ledger, hand-back list. Under 100 lines.
  planning/         intake, acceptance, exploration, edge cases, blueprint, interview
                    deferred.md: out-of-scope findings, only when no tracker is bound
  use-cases/        goals people have with the product, one file per area, no steps
  flows/            one file per feature: before and after Mermaid diagrams, written once
    assets/         kept captures a file in this directory cites
  verification/     the verification pass, run on dev: one file per feature or per group
    assets/         kept captures a file in this directory cites
  runbooks/         the production stage: run by hand after the dev pass, numbered, plus 0-release.md
    assets/         kept captures a file in this directory cites
  feedback/         the developer's feedback rounds, in their words
  agent/            everything else
```

`agent/` holds the machinery:

```
  agent/
    adapters.md            role to driver bindings, generated at kickoff
    <n>-<item>/
      0-card.md            HEAD: the item's stable card
      <f>-<slug>.md        HEAD: one file per feature (scope, links, test strategy, score)
      <f>-<slug>.log.md    LOG: append-only, one per feature
      resume.md            HEAD: ONE resume block per item, overwritten
    harness/               scripts a dispatch wrote that are worth replaying
```

**Mark `agent/` generated.** At scaffold, add one line to the repo's `.gitattributes`:

```
<path to batch dir>/agent/** linguist-generated=true
```

GitHub then collapses `agent/**` in every PR diff, so a reviewer sees code, flows and verification without scrolling past machinery. Add the line in the scaffold commit, not later.

## Per-file contracts

**`00-plan.md`** (HEAD). The entry point. **Under 100 lines.** Rewritten in place, never appended to. ONLY:

1. **STATE**, 10 lines or fewer: what this effort is, `phase:`, `layout: v3`, `acceptance: <n> of <m> rows met`, and the single next action.
2. **Decisions**, a table: `| # | Decision | Choice + why | Date |`. A reversed decision is rewritten in place as `was X, now Y`.
3. **Testing plan**, batch scope: cross-item groups, end-to-end flows with the role that drives each, the environment with its bring-up, seed, seed convention and reset lines, and the load criteria or `none stated`.
4. **Status ledger**, one row per item: `| # | Item | Stage | Note |`, linking to `agent/<n>-<item>/0-card.md`. Detail never goes in cells.
5. **Hand-back list**: what the developer owes, one line each. Verification files waiting for a pass, use cases ready to run (`use cases ready: UC-a, UC-b`), runbooks waiting to be run, secrets to mint, devices to test on. This is the list the developer reads when the agent stops.
6. **Deferred**: work discovered here and filed out. One line per issue: `- <url>: <title>`.

Copy `templates/00-plan.md`.

**`planning/`**: the pre-execution record, one checkpoint per phase, written by `pre-rolling-wave-planning`: `00-intake.md`, `00-acceptance.md`, `01-exploration.md`, `02-edge-cases.md`, `03-blueprint/`, `04-interview.md`. A phase left without its checkpoint cannot be resumed, only redone. `planning/deferred.md` exists only when no issue tracker is bound: one `## <slug>` section per out-of-scope finding, append-only (`references/resume.md` § Mid-flight inputs).

**`use-cases/<area>.md`**: what people do with the product, stated as goals and never as steps. One file per area of the product, grouped by who does the work (for example `terminal-staff.md`, `store-operator.md`, `accounts.md`). A use case is reused across items; it is not per feature, and it is written before any screen that serves it is wireframed. Each use case carries: an id `UC-<n>` (unique in the batch, never renumbered), a one-line title, **Who** (the role), **Situation** (what just happened in their day), **Goal** (what they want to be true), **Done when** (the outcome they can see, in product terms), **Items** (the item numbers whose flows it exercises) and **Status** (`ready` when every flow it needs is merged into the batch branch, otherwise `waiting on item <n>`). A use case may list two or three variations as one-liners. **Steps, button labels, routes, control names, SQL and expected values are forbidden in a use case.** If the reader needs a step to succeed, either the UI fails the use case, which is a finding, or the detail belongs in a verification file. The developer runs `ready` use cases freely on dev during the dev pass, finds the how themselves, and what they trip over comes back as a feedback round. Written by the `heavy` tier, because a human executes it. Template: `templates/use-cases.md`.

**`feedback/<k>-<slug>.md`**: one developer feedback round, written by the developer in their own words, with pasted screenshots kept beside the file. **Never edited by an agent.** The agent triages a round as a mid-flight input (`references/resume.md`) into an item or minor features, and links the round from the item card.

**`flows/<n>.<f>-<slug>.md`**: the human's map for reviewing the PR. Before and after Mermaid diagrams of the flow the feature changes, each node naming a file plus a function or symbol and carrying a GitHub permalink at a pinned SHA. **Written once, never edited.** Shape and rules: `templates/flow.md`.

**`verification/<n>.<f>-<slug>.md`**, and `verification/group-<slug>.md` for a cross-feature group: **the dev pass, run entirely on dev.** Walkthrough order over the flow file, a short replay section, then the judgement rows only a human can make. Every row runs against the app started locally from the batch branch against the dev database, plus the dev database console. **Nothing here names production**, not a console, not a credential, not a `*:prod` command, not a migration push; that work is a runbook step, and the production post-check that proves it landed is the second stage of the same flow. Verdict cells are filled by hand, never by an agent. Authored per the `human-assisted-verification` skill; shape in `templates/verification-feature.md`.

**`runbooks/<k>-<slug>.md`**: a production procedure run by hand, never by an agent, numbered in run order. Written only for a feature that needs a production step (a migration, a secret, a key cutover, a config flip, a store submission). It holds what it does in plain words, preflight, dry run, apply, the post-check SQL or command that proves it landed, rollback, and known consequences. Production evidence lives here and is never duplicated into `verification/`. Template: `templates/runbook.md`.

**`runbooks/0-release.md`**: one per batch, written at the batch PR gate. It sequences the whole release: merge order, the numbered runbooks in the order to run them, the dashboard release and its tag, the app tag or OTA push, and the version bump. It links the project's own release conventions and never restates them. Template: `templates/release-runbook.md`.

Runbooks are **deleted after the push they describe**, in the commit that records the push. A runbooks directory that outlives its deploy is stale instructions.

**`agent/adapters.md`**: the batch's driver table. Every role bound to a skill, tool or tier, with a one-line invocation. Generated at kickoff from `<project root>/adapters.default.md` plus a detection run. Procedure: `references/adapters.md`. Template: `templates/02-adapters.md`.

**`agent/<n>-<item>/0-card.md`** (HEAD): the item's stable layer. Problem, files involved, evidence, acceptance criteria, test strategy, sensitive-surface flags, feature index. Rewritten in place when the premise changes; no correction block, no dated marker. Template: `templates/0-card.md`.

**`agent/<n>-<item>/<f>-<slug>.md`** (HEAD): one per feature. Stage line, what and why, links, test strategy, one confidence line. Rewritten in place. Template: `templates/feature.md`.

**`agent/<n>-<item>/<f>-<slug>.log.md`** (LOG): append-only, one per feature. Dispatch rows, evidence rows, review findings. **Every entry carries the SHA it was true at.** Nothing in this file is ever edited: a fact that stopped being true gets a new entry, and the old one stands with its SHA.

**`agent/<n>-<item>/resume.md`** (HEAD): exactly one resume block per item, **overwritten every time**, never appended to. Where the item is, what is in flight, the exact next step, and the facts the next step rests on. A second block, an addendum, or a "supersedes the previous" line is the failure this file exists to prevent.

**Captures and run logs.** Nothing binary lives under `agent/`, and run logs and traces are never
committed. Expiring evidence is not copied in: the lines that matter, at most 20, go into the
evidence row (log retention is typically a day or two). A capture is kept only when a file in
`flows/`, `verification/`, `feedback/` or `runbooks/` cites it, and it lives in that directory's
`assets/` (`flows/assets/<f>-<slug>-<what>.png`), as an element capture under the size cap bound in
`agent/adapters.md` § Cleanup. Every other screenshot, log and temp file lives in the scratch root
bound in that section and is torn down. The scratch root may sit anywhere the binding names,
including under the SSOT directory, provided the bound ignore rules keep it out of version control.
Rules: `references/verification.md` § Evidence entries.

**`agent/harness/`**: a script a dispatch wrote that the next dispatch or the developer will re-run (a seeding script, a login-state generator, a capture loop). Anything not worth re-running is ephemera and is swept.

## Size

**`00-plan.md` is capped at 100 lines.** Past it, move detail into a card.

**Files under `agent/` target 150 lines.** Past it, the feature needs another shard, not a longer file. A subagent loads one feature's HEAD file and one LOG file; both must fit a packet's budget. Shard by feature, never by topic.

`flows/`, `verification/` and `use-cases/` files are sized by the flow and the pass, not by a cap.

## What does not exist here

- No docs chapters. A reader-facing docset is a separate skill and a separate decision; this layout does not carry one.
- No confidence re-derivation prose. One line, `agent N / ceiling M`, in the feature file.
- No compaction addenda. The resume block is overwritten.
- No dated corrections in `agent/` files, and no `Previously:` chains in source headers.
- No index file over `verification/`. The ledger's Stage column and `00-plan.md` § Hand-back are the index.
