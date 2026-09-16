---
name: rolling-wave-planning
description: Use when starting or resuming any large multi-item or multi-step effort (many bugs, a big spec, several features) that won't fit cleanly in one context or one session — including "continue the ongoing flow" and new items arriving in an effort whose SSOT directory already exists. Don't use for a single isolated task or a quick one-off change.
---

# Rolling-Wave Planning

## Overview

For a large effort, detailed up-front plans rot before you reach them. Separate the **stable layer** (what the problem is, what was decided — doesn't rot) from the **volatile layer** (how to solve it — rots on contact). Record the stable layer up front; generate detail just-in-time. All state lives in one SSOT directory so any session can resume cold.

**The core sizing principle: what a session must load to resume is O(1) in batch size, not O(n).** Audits of nine real efforts found the old single-file `00-plan.md` design failing exactly here — plans grew to 700–1,400 lines of accumulated item cards and outcome prose, overwhelming the agents reading them, not just humans. So the durable record is **sharded**: a tiny entry file, one card per item, one file per feature. A resume reads the entry file, the current item's card, the current feature file and that item's working file — nothing else, no matter how many items the batch has.

**REQUIRED PREDECESSOR when design is unsettled and no SSOT dir exists yet:** `pre-rolling-wave-planning` (exploration → edge cases → design interview → scaffold). If decisions are settled and the items are well understood, start here directly.

## Unit hierarchy

| Unit        | Definition                                                                                                               | Planned                               |
| ----------- | ------------------------------------------------------------------------------------------------------------------------ | ------------------------------------- |
| **Batch**   | The whole effort. One SSOT directory.                                                                                    | Up front (stable layer only)          |
| **Item**    | Today's card.                                                                                                            | Up front (stable layer only)          |
| **Feature** | One skimmable PR — roughly **≤400 changed lines excluding tests and generated code** — delivering one coherent behavior. | **Just in time, when the item opens** |

Pre-decomposing item 7's features before item 1 starts is the rot this skill exists to avoid. **An item that is already feature-sized gets no sub-breakdown** — one item branch, one PR, one feature file numbered `1-`. Do not manufacture a split to satisfy the shape.

## Step 0 — The SSOT directory

1. Ask the user where it goes; suggest the project convention (e.g. `docs/features/<N>-<name>/`). **List sibling dirs first and take the next unused number** — a real audit found two dirs both numbered 9.
2. Everything a later session needs lives INSIDE this directory. If a bootstrap plan, interview record, or triage note exists elsewhere (session scratchpad, `~/.claude*/plans/`), copy it in — external pointers die with the session that made them.

```
00-plan.md                      entry point — STATE + decisions + ledger. Hard cap 100 lines.
01-verification.md              verification checklist (shard to verification/<item>.md past ~150 lines)
02-deferred.md                  out-of-scope discoveries, cold-resumable
rollout/
  1-<item-slug>/                numbered in execution order
    0-card.md                   the item's stable card. ≤100 lines.
    1-<feature-slug>.md         per-feature file. ≤100 lines.
    2-<feature-slug>.md
    docs/                       item-level architecture / trade-off notes worth the human's time
working/<item-slug>.agent.md    JIT volatile detail — exactly ONE live file per item
human/                          reader-facing docset for the developer
assets/                         screenshots, captured logs (copy expiring evidence in)
```

**`00-plan.md`** — the entry point (hard cap 100 lines). Item cards do NOT live here; that is what kept every audited plan file growing without bound. ONLY:

1. **STATE** (≤10 lines): what this effort is, current stage, what to do next. **Edited in place on every re-plan — never append a superseding "new plan" section.** History lives in git; four stacked re-plan narratives are what made one audited 969-line plan unskimmable.
2. **Decisions** — table: `| # | Decision | Choice + why | Date |`. When a decision is reversed, rewrite its Choice cell as: was X → now Y, why the evidence wins, dated. A stale decision sitting above a contradicting ledger row is drift.
3. **Status ledger** — one row per item: `| # | Item | Stage | Note (one sentence) |`, linking to `rollout/<n>-<item>/0-card.md`. Detail never goes in cells.

**`rollout/<n>-<item>/0-card.md`** — the item's stable layer: problem, files involved, evidence, acceptance criteria, sensitive-surface flags, and the **feature index** (features with their stage, filled in when the item opens). **At code-done, append `Outcome:` — ≤5 bullets.** If the card's premise was overturned, use a dated correction block (assumed → actually → why it was plausible). A card approaching 100 lines means solution detail is leaking in — move it to `working/`.

**`rollout/<n>-<item>/<f>-<feature>.md`** — the human's skim surface: what & why, links, test strategy, confidence score. Copy the template verbatim from `feature-file-template.md`. Hard cap 100 lines; solution detail belongs in `working/`.

**`01-verification.md`** — see `human-assisted-verification`. **Same-commit rule:** ticking this file is what moves a ledger row from `code-done` to `verified` — tick and row change in the same commit. Audits found ledgers asserting DONE above fully unchecked checklists in 2 of 4 batches. No human-verifiable surface (pure tooling)? Record the substitute (fault injection, CI gates) in the item's card — never drop the file silently.

**`working/<item>.agent.md`** — JIT detail, plus the **model recorded per subagent dispatch**. Exactly ONE live file per item; restructure by editing in place, never by spawning a second file (two "live" files with different currency broke one audited resume path). Prune superseded sections as you go. Deleted at close-out.

**`human/`** — reader-facing docset. Follow the `human-engineering-docs` conventions (read `~/.agents/skills/mentor-documentation-system/skills/human-engineering-docs/SKILL.md`): numbered files ≤100 lines, `000-index.md` with abstract, `## TL;DR` per file, evidence labels, written to the human. Write or update the relevant chapter at code-done, while context is hot — not at batch end. **Deep-dives shard, not stretch:** a request needing more than 100 lines becomes two or more numbered self-contained files, never one long one. Prefer a small diagram (ASCII inline, or `excalidraw-diagram-generator`) the moment a flow or matrix gets re-explained in prose a second time.

## Item numbers are execution slots

`<n>` in `rollout/<n>-<slug>/` is **position in execution order, never an identity**; the ledger is sorted by it, and slots are assigned at open time in the planned order.

- **Insert that will execute NEXT** (the normal case — inserts land at "now"): it takes slot `(highest item opened so far) + 1` and **every still-`pending` item shifts +1** — rename its `rollout/<n>-…` dir and any `working/<n>-…` file, retitle its issue `[<N>.<i>]`, and fix every reference in `00-plan.md` (ledger, STATE, and any decision that spells out the order — add a dated note there, never a silent rewrite).
- **Insert that will execute LATER** (rare): it takes the slot after the item it follows; only items after it shift.
- **Never renumber an item that has a branch, PR, or merged code** — those numbers are frozen in git history. If a shift would require it, the insert goes at the END and STATE must say explicitly that it executed out of numeric order. That is the one allowed exception, and it is loud on purpose.
- Feature numbers `<i>.<f>` are per-item and unaffected by a shift, except that `<i>` follows its item. `human/` chapter numbers (`human/045-…`) are READING order, not item numbers — they never shift. No fractional or letter suffixes (`1.5`, `1a`, `1.1`) for an insert: `<N>.<i>.<f>` is already the feature grammar, so `10.1.1` is a feature, never an item.

**Why:** batch 10 gave a mid-flight item the next unused number, 4 (2026-09-04), while it actually executed second and items 2–3 were still pending — the number implied it ran last and cost the developer a long, confused session. Renumbered 2026-09-10.

## Three-tier file naming

| Suffix       | Meaning                                                  | Examples                                                                           |
| ------------ | -------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| `*.agent.md` | Agent machinery. Reading it wastes the developer's time. | `working/1-pwa-shell.agent.md`, handoff packets                                    |
| plain `.md`  | Shared record. The developer skims it when relevant.     | `00-plan.md`, `0-card.md`, feature files                                           |
| `*.human.md` | **The developer must act or decide.**                    | prod runbooks, decisions awaiting their call, security trade-offs needing sign-off |

The suffix, not the directory, says who owns the file; every file is numbered for reading order, `.human.md` included. **Test for `.human.md`:** if the file's open TODO belongs to the developer, it is `.human.md`. Saying it in chat is not a substitute — chat scrolls away; the suffix makes the obligation findable weeks later.

## Confidence score — rubric, not formula

Every feature file carries a 0–100 score: a **judgment against a rubric with no prescriptive arithmetic**, because a formula invites gaming. Weigh (1) unit coverage of exit points, (2) integration seams actually exercised rather than mocked on both sides, (3) real-surface verification (`agent-browser` for any web surface, `human-assisted-verification` for mobile and fire-and-forget effects), (4) review findings raised vs resolved, (5) unverifiable effects honestly listed. Name the weakest dimension. Full rubric: `feature-file-template.md`. **"What would raise this" is the payload** — the developer reads scores, not diffs, and dives where the number is low. **Exhaust agent-actionable raises first:** anything an agent can execute with available tooling (a browser flow, an extra seam test, a machine assertion) is *done*, not listed. The list is only for raises needing human intervention or infrastructure that does not exist yet.

## The loop

1. **Open an item**: read its card, decompose it into features (≤400 changed lines each), write the feature index into the card, create `working/<item>.agent.md`, and — ceremony ON — cut the item branch and open its tracking issue (link it per `ceremony.md` § Platform linking — sub-issue of the batch issue).
2. **Open a feature**: create `<f>-<feature>.md` from the template with sections 1–3 planned. Cut the feature branch; its PR is linked per `ceremony.md` § Platform linking (`Part of #<item issue>` on line one).
3. **Work it**, delegating the *how* (see Delegation and Execution discipline). New facts that change the card's problem statement get edited into the card now, not narrated in the working file.
4. **Feature close**: update the test-strategy "Actually ran" column, score confidence, exhaust agent-actionable raises, open the feature PR, resolve review findings, merge into the item branch → the feature is `code-done`.
5. **Item code-done** (all feature PRs merged, item PR merged into the batch branch): Outcome bullets (≤5) in the card · ledger row → `code-done` · `human/` chapter written or updated. The working file stays live.

## Lifecycle — two scopes

Stage names are unchanged: `pending → in-progress → code-done → verified` (plus `triage`, `deferred`, `blocked`).

| Scope | `in-progress` | `code-done` | `verified` |
|---|---|---|---|
| **Feature** (in the card's feature index) | branch cut, work underway | **its feature PR is merged into the item branch** | n/a — verification is item-scoped |
| **Item** (the `00-plan.md` ledger row) | item branch cut | every feature PR merged **and** the item PR merged into the batch branch | close-out gate satisfied |

**Item close-out gate — the row reaches `verified` only when ALL of:**

- [ ] `01-verification.md` ticked in the same commit as the row change — or the card's recorded substitute satisfied
- [ ] `working/<item>.agent.md` deleted — or flagged `kept: <reason>` in the card
- [ ] `human/` chapter reflects the final state
- [ ] Ledger note updated (one sentence)
- [ ] The item's tracking issue is closed

The gate is a checklist, not a reminder: one audited effort collapsed 8/9 working files, the next collapsed 0/8 — with the collapse instruction present in every file it ignored. Prose reminders don't survive deadline pressure; gates do.

## Pausing a batch

A batch can be paused when the developer must switch to other work. Pausing is a ceremony, not just stopping — and it is **batch-level**, recorded in STATE; the stages above stay item-level.

1. Nothing is left `in-progress`: close the open feature to `code-done`, or record the exact stopping point in `working/<item>.agent.md` and mark the item `blocked`, reason "paused".
2. Merge the batch branch into `dev` (batch PR, CI must run on it) so trunk carries everything `code-done`. The batch issue stays OPEN with a pause comment. Delete merged item/feature branches; the batch branch may be deleted and re-cut from `dev` on resume — say which in STATE.
3. STATE's first line becomes `**PAUSED <date> — <one-line reason>.**` above a `Resume here:` block (the whole thing under ~10 lines): the next action, every owed developer action (verification rows still open, secrets to mint, devices), and the branch to cut from.
4. Owed verification rows stay unticked in `01-verification.md`; owed work goes to `02-deferred.md` with the pause date. Ledger rows keep their stage — `code-done` is still `code-done`.
5. Update the project's state table (in this repo, root `CLAUDE.md`'s "Admin Dashboard Project" table) so the batch reads `⏸ Paused <date>` with the resume pointer.

On resume, the resumability protocol reads STATE first and finds the `Resume here:` block, re-runs the integrity sweep, and clears the PAUSED line.

## Git & GitHub ceremony

Branch naming, the PR ladder, the issue tree, ceremony levels, the security pass, and the rogue-check live in `ceremony.md` — **load it when an item opens, not every session.** Level is chosen at kickoff and recorded in the decisions table: **ON** by default for feature efforts, **lighter** for bug batches, **OFF** only if the developer asks. With ceremony OFF, `code-done` reverts to "implemented, tests green, committed"; everything else here still applies.

## Execution discipline

**Subagent-driven development with explicit model tiering is the default.** The orchestrator assigns every feature and every bounded task an **explicit model** on dispatch — subagents inherit the driver's model unless overridden, so an unspecified model silently burns the expensive tier. **Heavy** (e.g. `opus`) for hard implementation, code review, security review, the rogue-check; **light** (e.g. `sonnet`, `haiku`) for repo mapping, search, log reduction, mechanical edits, doc formatting. Record the model per dispatch in the item's `working/` file; the rogue-check reads it as evidence.

## Mid-flight inputs

The user will report new issues mid-effort. Triage each one immediately into exactly one of:

- **In scope** → its own ledger row + card, even a stub, **at the execution slot it will actually run in — shifting the still-`pending` items, per "Item numbers are execution slots"** (the next unused number is almost never the right one). Never handle a discovered bug as narrative inside another item's log (an audited batch did both in consecutive weeks — the narrated one is invisible in the ledger).
- **Out of scope** → `02-deferred.md` (or the project's deferred-work SSOT), with enough context to pick up cold.
- **Unclear** ("might be related, not sure") → stub ledger row at stage `triage`. Classifying it is itself work; the row keeps it visible either way.

## Resumability protocol — on "continue the flow"

1. Read `00-plan.md` (≤100 lines: STATE + decisions + ledger).
2. Read `rollout/<n>-<item>/0-card.md` for the in-progress item, then its current feature file, then `working/<item>.agent.md`. **Never the whole `rollout/` tree.** Total load ~100 + ~100 + ~100 + working file — bounded regardless of batch size.
3. **Integrity sweep** (cheap; every resume): `verified` rows above unchecked verification items? Terminal rows with live working files? Features marked `code-done` whose PR never merged? Decisions contradicted by the ledger? Rows without cards, cards without rows? For each hit, restore truth in the cheaper direction: **demote the stage to match the evidence** when the step itself is missing, or **complete the missed step** when it was done but not recorded. One remediation may clear several flags at once. Anything bigger goes into STATE as the first order of business — never start new work on top of known drift.

## Red flags

- `00-plan.md`, a card, or a feature file past 100 lines — detail is leaking out of `working/`.
- A confidence score with an empty "what would raise this".
- An agent-actionable entry still on a "what would raise this" list at feature close — do it instead of listing it.
- A subagent dispatched without an explicit model.
- "I'll collapse the working files at the end of the batch" — collapse is per item, at close-out.
- "DONE (verification pending)" — that's `code-done`, a different stage.
- "The detail is in the session transcript / my context" — if it isn't in the SSOT dir, it doesn't exist tomorrow.
- Appending a new plan section instead of editing STATE.
- A second working file for the same item.
- An Outcome block growing past 5 bullets.
- An item whose number does not match its execution position — or a renumber attempted on an item that already has a branch, PR, or merged code.
- A batch that stopped without the pause ceremony: no `PAUSED` line in STATE, no `Resume here:` block, work sitting on an unmerged batch branch.

## Delegation — this skill is a conductor

- New effort, unsettled design, no SSOT dir yet → `pre-rolling-wave-planning`.
- Fuzzy single feature → `superpowers:brainstorming`; per-item plans/specs → `superpowers:writing-plans`, `spec-development`.
- Executing items → `subagent-driven-development` (in-session) or `superpowers:executing-plans` (separate session); code changes follow `superpowers:test-driven-development`; bugs go through `systematic-debugging` before any fix.
- Verifying → `human-assisted-verification`. Human-facing docs → the `human-engineering-docs` conventions (path above).
- Branching, PRs, issues, rogue-check → `ceremony.md`; feature file layout → `feature-file-template.md` (this directory).
