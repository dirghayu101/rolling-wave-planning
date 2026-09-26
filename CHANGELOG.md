# Changelog

All notable changes to this skill family are recorded here. Versions follow semver.

## 3.3.0 - 2026-09-26

Minor. A fourth tier, `orchestrator`, and the `judge` tier becomes an escalation instead of work
kept with the session. The session runs on the model bound as `orchestrator`; when it hits a
judgement it may get wrong it dispatches the `judge`, on three mandatory triggers (reports that
disagree after the cited files were reopened, a choice between fixes no test can separate, and
vetting a design-question round that changes a formula, a money path or a persisted shape), one
per feature by default. The judge packet, return shape, authority, developer-only list and the one
log row are in `references/dispatch.md` § Escalating to the judge. When `judge` and `orchestrator`
are bound to the same model the judge is inert and the orchestrator decides.

No model name appears anywhere in the skill. Every binding lives only in the project's
`adapters.default.md` and the batch's `agent/adapters.md`, in the developer's words: "tomorrow we
might have even better model so I don't want coupling of that sort". `references/adapters.md`,
both adapters templates, `SKILL.md`, `README.md` and `references/review.md` (review now runs on
`heavy`, not `judge` or `heavy`) updated to match.

## 3.2.0 - 2026-09-25

Minor. A fourth triage lane, **minor**, in `references/resume.md` and a matching "Minor change
lane" section in `references/lifecycle.md`: a ruling, tweak or small fix lands as a feature on the
item that owns the code with one PR and two log rows, no item, issue, card, flow, verification,
L4 or integrity ceremony. Trigger: the developer stopped a five-agent ceremony that had been
opened for four one-line rulings.

## 3.1.1 - 2026-09-23

Patch. The PR body regains its headed sections at the developer's request: familiar, same shape on
every PR. An unfilled section carries a fixed line saying where and when it fills in, and the body
is still written once, never edited to stay in sync. `templates/pr-body.md` rewritten.

## 3.1.0 - 2026-09-23

Minor. Verification splits into two stages, and production leaves `verification/`.

The developer's ruling of 2026-09-23: `verification/` is the dev stage, it runs on dev from the batch
branch served locally against the dev database before any merge, and it needs no production access,
so nothing in it may name production, a production credential or a `*:prod` command. `runbooks/` is
the production stage, run by hand and never by an agent after the dev pass and the merge, holding the
migrations in order, the dashboard release and its tag, the app tag or OTA push and the version bump,
and its post-checks are the production-side verification of the same flow.

### Changed

- **`verification/` is dev-only.** No verification file may name a production console, a production
  credential, a `*:prod` command or a migration push. Production post-checks were previously
  duplicated into verification files as human rows; that is now forbidden, because such a check
  cannot run before the deploy and needs access the dev pass does not have. A check that can only run
  against production is a runbook step. New § Two stages in `references/verification.md`; new red
  flags there, in `SKILL.md` and in `references/lifecycle.md`.
- **The dev surface is fixed**: the app served locally from the batch branch against the dev
  database. A deployed preview is not a candidate, since it would need the merge to dev that comes
  after the pass. `templates/verification-feature.md`'s Setup line states that rule instead of naming
  a URL, and `references/adapters.md` § Environment says the recorded start command is the one the
  dev pass uses.
- **Promotion is the ticks on `verification/`.** A runbook's production post-check is deploy
  evidence: it never feeds the confidence score and never promotes an item from `merged` to
  `verified`.
- **`runbooks/` is per feature and numbered in run order**, written only for a feature that needs a
  production step, holding what it does in plain words, preflight, dry run, apply, post-check,
  rollback and known consequences. The feature `reviewed → merged` gate and `references/ssot-layout.md`
  say so.
- **`skills/human-assisted-verification` rewritten** to the dev stage: the "Check it yourself" column
  holds dev-console SQL, dev CLI commands or dev UI paths and nothing else, and a row that would need
  production is routed to a runbook. Durable observables, the 24h flag and the fallback on a failed
  assertion are unchanged; every example targets dev.
- **No role attribution in the process text.** Stages and properties are described instead of people:
  rows are run by hand and never by an agent, a checklist row addresses its reader as "you", and
  nothing names a job title. `README.md` and `SKILL.md` updated where they describe verification or
  runbooks; the "until the developer ticks" lines in `templates/feature.md`, `references/ceremony.md`,
  `tests/scenarios/04-verification-file-shape.md` and the `12-notifications` fixtures now read "until
  the row is ticked".

### Added

- **The verification window.** While a dev pass is running, no agent runs `db:apply`, reseeds dev or
  rehearses a schema change on dev. The orchestrator marks it with one `verification_window:` line in
  `00-plan.md` STATE and deletes it when the ticks are in. Stated in `references/verification.md`,
  `references/dispatch.md` § Concurrency and `templates/00-plan.md`.
- **`runbooks/0-release.md`**, one per batch, written at the batch PR gate, sequencing merge order,
  the numbered runbooks in order, the dashboard release and tag, the app tag or OTA push and the
  version bump. It links the project's own release conventions and never restates them. New
  `templates/release-runbook.md`; new `templates/runbook.md` for the per-feature runbooks.
- **The schema-only variant**: a feature whose only human-observable effect is the production
  post-check gets a runbook plus a verification file with the replay section only (the post-check SQL
  run on the dev console as a replay) and one explicit line, `No judgement rows: nothing here is
  observable on dev beyond the replay; production evidence is runbook <k> step <n>.` Inventing
  judgement rows for it is a red flag.
- Two acceptance criteria, rows 23 and 24 in `tests/acceptance/v3-criteria.md`: no production
  reference in any verification file, and a release runbook present at the batch PR.
- One line at the end of `references/migration-3.md`: batches migrated before 3.1.0 must also move
  production-facing rows out of `verification/` into the matching runbook.

## 3.0.0 - 2026-09-23

Breaking. The record shrinks to what an agent needs to resume and what a human needs to review a
PR. Code discipline is unchanged.

Origin: batch 11 inventory ops (mashric, `docs/dashboard/specs/11-inventory-ops/`), and the
developer's ruling of 2026-09-23. Two days of execution produced 128 commits, 80 of them
`docs(...)`, and about 26,000 SSOT lines against 3,300 source and 3,700 test lines. Of 88 review
findings on one feature, four were in shipped code; the rest were the record disagreeing with the
tree: line pins re-pinned and then invalidated by the next commit, counts propagated to seven sites
and updated at six, 127 dated "Corrected ..." markers. Nine compaction addenda were appended to one
working file. Every real defect was found by a browser measurement or a fresh-eyes code review,
never by a document.

This entry absorbs the 2.6.0 entry, which was written but never committed or released. Everything
2.6.0 added is removed here.

### Changed

- **New SSOT layout (`layout: v3`).** `00-plan.md` (hard cap 100 lines, with a new `## Hand-back`
  section), `planning/`, `flows/`, `verification/`, `runbooks/`, and `agent/` for everything else.
  The developer opens the first five. `agent/**` is marked `linguist-generated` in the repo's
  `.gitattributes` at scaffold, so GitHub collapses it in PR diffs. `02-adapters.md` becomes
  `agent/adapters.md`; `rollout/` becomes `agent/`; `assets/` becomes `agent/assets/`; a new
  `agent/harness/` holds scripts worth replaying. Files under `agent/` are sharded per feature and
  target 150 lines.
- **Four stages, at both feature and item scope**: `open`, `built`, `reviewed`, `merged`, plus
  `blocked` and `deferred`. `agent-verified`, `documented`, `complete`, `pending`, `in-progress`
  and `code-done` are gone. `merged` is the agent terminal at both scopes: the agent delivers the
  batch branch with every feature merged and every agent-side check done. `verified` is reached
  only from the developer's ticks, which land later and may cover a cross-feature group rather than
  one feature.
- **Two record layers, and only two.** LOG (`agent/<n>-<item>/<f>-<slug>.log.md`, one per feature)
  is append-only and immutable: dispatch rows, evidence rows, review findings, each carrying the
  SHA it was true at, never edited or re-pinned. HEAD (`00-plan.md` STATE, the card, the feature
  file, one `resume.md` per item) is rewritten in place and capped. One writer for the SSOT;
  subagents return facts and never edit it.
- **One review per feature, at the PR.** Scope: the diff, the tests, the L3 browser evidence.
  Security rides in the same packet when the card flags a surface. Two passes maximum; a third
  means the packet was wrong. **The record is explicitly not reviewable material**, and the
  reviewer packet says so in those words: findings about a feature file, a PR body, a flow file or
  a verification file are not findings.
- **The verification file has three parts**: a walkthrough order over the flow file, a short replay
  section of three or four agent-proven checks marked as sanity only and explicitly not moving the
  score, then the judgement rows only a human can make. `skills/human-assisted-verification` and
  `references/verification.md` rewritten to this shape.
- **Confidence is one line**, `agent N / ceiling M`. No re-derivation prose, no history of the
  number, no dated chain.
- **Commits**: code and tests as they land; `agent/` files at gates only (feature `merged`, item
  PR); `flows/`, `verification/` and `runbooks/` ride the feature PR. Never a commit whose whole
  diff is a record edit, made between gates. History is read with `git log --first-parent`.
- `references/ssot-layout.md`, `references/lifecycle.md`, `references/review.md`,
  `references/verification.md`, `references/dispatch.md`, `references/resume.md`,
  `references/ceremony.md`, `references/adapters.md` and `references/blueprint.md` rewritten.
  `SKILL.md`'s phase table and red flags updated. `README.md` rewritten and cut to 203 lines.
- `pre-rolling-wave-planning` keeps its five phases unchanged; only its layout references and its
  Phase 5 scaffold list moved to v3.

### Added

- **`flows/`**, one file per feature. A `light`-tier `flow-explorer` draws the **before** diagram
  at the feature `open` gate, pinned to the base SHA (skipped, with a line saying so, when the flow
  does not exist yet), and the **after** diagram at PR ready, pinned to the head SHA. Mermaid. Every
  node names a file plus a function or symbol and carries a GitHub permalink at the pinned SHA.
  **Written once, never edited**: a later feature that changes the same flow writes its own file.
  The flow file is the human's map for reviewing the PR, and the after diagram is embedded in the
  PR body. New template `templates/flow.md`; new `flow-explorer` role in `references/dispatch.md`
  and in both adapters templates.
- **`runbooks/`**, deploy-time procedures only, numbered in run order, deleted after the push they
  describe.
- **`00-plan.md` § Hand-back**: what the developer owes, in the order to do it. Every
  `verification/` file and every `runbooks/` file lands here at the item's `merged` gate. It
  replaces the deleted `01-verification.md` index.
- **`templates/integrity-check.md`**: one `light`-tier, read-only check at the item PR. Three
  questions and nothing else: do the stage lines agree with the ledger, are all verdict cells still
  `open`, is every ephemera row swept.
- **`references/migration-3.md`**: the ordered procedure for restructuring an existing v1 or v2
  batch into this layout. The moves, the split of each working file into one resume block plus LOG
  entries, the strip of dated corrections and `Previously:` chains from agent files and source
  headers, the `.gitattributes` line, and the three commits to make. Followable cold.
- **Concurrency constraints** in `references/dispatch.md`: a branch holds one implementer; an
  overlapping in-flight feature gets its own git worktree; one dev server per worktree, started and
  killed by the packet that needs it; a schema change runs exclusively; a packet that assumes
  another in-flight feature's exports names them and the SHA it read them at. No model-specific,
  harness-specific or token-budget limits.
- **Geometry and focus reads** are now part of the L3 definition wherever layout or keyboard
  behavior changed, and the browser binding is required to support them.

### Removed

- **The mentor-deep documentation system.** `skills/mentor-documentation-system/` (with its nested
  `human-engineering-docs` and `senior-mentor` skills), the `docs/` directory in a batch, the
  `docs-conventions` and `docs-verify` roles, `templates/doc-handoff.md`,
  `templates/docs-verify-handoff.md`, the docs-writer binding sections of both adapters templates,
  and every docs gate and red flag. A separately installed `human-engineering-docs` is unaffected;
  it simply is not part of this family any more. The skills-directory entry count drops from six to
  three, and `setup.sh`, `setup.ps1` and `tests/setup/run.sh` follow.
- **The audit ceremony**: review point 5, the every-N-dispatches trigger, the pause and batch-PR
  triggers, `templates/audit-handoff.md`, and the `dispatches_per_audit` and scheduler bindings.
  Replaced by the item-PR integrity check.
- **Review points 1, 3 and 4 and the rogue-check.** One review per feature replaces them.
- **Confidence re-derivation prose**, the `Re-derived at <stage>` convention, and the
  re-derivation rule.
- **Compaction addenda**, superseding sections, and any second live file per item. One `resume.md`
  per item, overwritten.
- **Dated corrections inside agent files**, and `Previously:` demotion chains in source headers.
- **The PR body as a record.** It is three paragraphs plus the after flow, written once and read
  once; it is never kept in sync with a file, and a disagreement between it and a file is not a
  finding. `templates/pr-body.md` rewritten, and its five-row test-strategy table removed.
- `01-verification.md`, `working/<item>.agent.md`, the three-tier `.agent.md` / `.human.md` file
  suffix convention (the directory now says who owns a file), and the v1 compatibility section of
  `references/ssot-layout.md` (v1 and v2 batches migrate through `references/migration-3.md`
  instead of running in place).

## 2.5.0 - 2026-09-21

### Added
- **The blueprint answer sheet is now the norm.** `templates/blueprint-index.html` carries the
  blueprint round's numbered questions at the foot of the index page: one collapsible block per
  question with its options, its one-line trade-offs, the recommendation marked on the option it
  belongs to and a free-text note, plus a draft saved in the browser under
  `<batch-slug>-round-<n>` and "Download answers" / "Copy answers as Markdown" actions. The
  developer answers in the browser and exports; the agent saves the export verbatim as
  `planning/03-blueprint/round-<n>-answers.md` and records the round in `planning/04-interview.md`
  from it. Origin: batch 11 (mashric `11-inventory-ops`), where it ran as an experiment on 55
  questions and the developer's verdict on 2026-09-21 was "keep it as norm". Why it wins over
  asking the questions in chat: the developer answers all of them in one pass, each note is
  attached to the exact question it qualifies rather than to a position in a chat scroll, a draft
  survives closing the page, and nothing is re-asked because the export says which questions are
  still blank.
- `references/blueprint.md` § Procedure step 8, § Output (`round-<n>-answers.md`) and two red
  flags: a script anywhere in `03-blueprint/` other than `index.html`, and an export that was
  summarised instead of saved verbatim.
- `references/resume.md` integrity sweep: a `round-<n>-answers.md` present with no matching round
  in `planning/04-interview.md` is an un-recorded round, recorded before anything else, because
  every later round rests on answers sitting outside the SSOT.
- `skills/pre-rolling-wave-planning/SKILL.md` Phase 4: the blueprint round may be answered on the
  index page and imported per `references/blueprint.md` step 8, while the questions still appear
  numbered in `planning/04-interview.md` exactly as asked. The page is the input surface, never the
  transcript.

### Changed
- The no-scripts rule in `references/blueprint.md` step 1 now has exactly one named exception,
  `index.html`, instead of none. Every wireframe still carries no script.
- The answer sheet's draft name is held in a variable called `DRAFT_STORAGE_NAME`, and the template
  says why in a comment: in batch 11 a variable literally named `KEY` holding a string tripped the
  generic-api-key rule of a pre-commit secret scanner, and these files are committed.

## 2.4.0 - 2026-09-21

### Added
- `references/ceremony.md` § "When the trunk moves ahead": `dev` keeps receiving other work while a
  batch runs, so the batch branch takes `dev` only between items, is never rebased while an item or
  feature branch depends on it, and is rebased for linear history only right before the batch PR,
  once every item branch has merged. A child branch that needs something from `dev` mid-item merges
  the batch branch after the batch branch took `dev`, never `dev` itself. Why: the stack is
  feature → item → batch → `dev`, so any history rewrite on a base breaks every open child under it.
  At batch 11 kickoff the developer asked exactly this and the reference had no answer.
- `references/adapters.md` § Environment: "A remote dev project" as a first-class candidate row,
  detected from the project's committed apply and seed scripts plus the project rules naming the dev
  target, with no bring-up and the project's apply script as its reset. Without the row, a project
  whose database is a hosted dev instance had no candidate to choose and detection fell to a local
  stack by default.
- `references/resume.md` integrity sweep: with `planning/03-blueprint/` present, every
  `Answered Round n` tag in `03-blueprint/inventory.md` and the blueprint `index.html` must name a
  round `planning/04-interview.md` has, holding that question. A tag naming a round the transcript
  lacks is drift, fixed by re-reading the transcript. Batch 11 found one stale tag on resume.

### Changed
- `skills/pre-rolling-wave-planning/SKILL.md` Phase 4 and `references/blueprint.md` § Later in the
  lifecycle: an interview answer that changes a control, a state or a route on a wireframed screen
  updates the wireframe, `planning/03-blueprint/inventory.md` and the blueprint index in the same
  pass as the decisions table, before the next round is asked. Both files gained the red flag "A
  decision row that changes a control with no matching edit in the wireframe and the inventory."
  Why: otherwise the SSOT contradicts itself, the decision saying one thing and the wireframe the
  implementer builds from saying another. Batch 11 Rounds 7 to 9 removed a terminal sheet action,
  changed a report route from a tab to a sub-route and hid corrections in a report; each answer had
  to be chased into the wireframes by hand, and the developer asked whether that happens
  automatically.
- `references/adapters.md` § Environment and Detection procedure step 4: detection reads the
  project's own rules (`CLAUDE.md`, `AGENTS.md`, or the file they point at) before a local stack is
  a candidate at all; a candidate the project forbids is recorded `present, forbidden by <rule,
  file>` and never chosen; a seed line is recorded only when the seed file it names exists. New red
  flag: "An Environment row chosen against a project rule that forbids it, or a seed line naming a
  file that does not exist." Why: the mashric defaults recorded `supabase start` on 2026-09-18
  although the repo `CLAUDE.md` forbids a local Supabase and `supabase/seed.sql` did not exist. A
  forbidden candidate detects exactly as cleanly as an allowed one, and the testing round caught it
  three days later.

Origin: batch 11 inventory ops (mashric, `docs/dashboard/specs/11-inventory-ops/`). Every release
from 2.1.0 to 2.4.0 came out of that one batch: the blueprint index (2.1.0), the shared readability
sheet and visible wireframe sections (2.2.0), the PR test-strategy section (2.3.0), and these four
(2.4.0).

## 2.3.0 - 2026-09-21

### Added
- `templates/pr-body.md`, the description every PR on the ladder is written from: `Part of #<issue>` on
  line 1, `## What and why`, a required `## Test strategy` table with five fixed rows (L1 to L5), each
  cell carrying what actually ran plus a re-openable pointer and a row that does not apply reading
  `not applicable: <reason>`, a `Full suite:` line, `## Confidence` with both scores, and `## Review`
  naming the review point this PR carries. Per-level notes say what differs at feature, item and batch
  scope. Why: "test-strategy summary" had no fixed shape and no template, so it could degrade to one
  line, and item and batch PRs had no test section at all although the cross-item pass runs at the item
  PR and the end-to-end flows plus the full suite run at the batch PR. Issues stay untouched: an issue
  has no code, and the item issue's PR links are how a reader reaches each PR's section.

### Changed
- `references/ceremony.md`: the PR ladder's Carries cells name the template at Feature scope, the
  cross-item pass in the Item row's L4, and the end-to-end flows plus the full-suite line in the Batch
  row; the self-sufficient-description bullet was rewritten around the template and the no-blank-row
  rule; a dated Why note and a red flag for a blank row or a "tests green" cell with no pointer.
- `references/lifecycle.md`: the feature PR opening gate, the `documented → merged` description gate,
  the item PR gate and the batch-scope sentence all say the description is written from the template.
- `templates/feature.md`: one line saying the feature PR's Test strategy section is this table's
  "Actually ran" column plus the evidence log, copied through `templates/pr-body.md`.

Origin: the batch 11 inventory ops adapter round.

## 2.2.0 - 2026-09-18

### Added
- `templates/wireframe.css`, one shared readability sheet (neutral greys, system type, spacing, no brand
  colour and no framework class) that every wireframe and the blueprint index links, copied once into
  `planning/03-blueprint/`. No wireframe carries an inline style block any more.
- Visible, collapsible sections in `templates/wireframe.html`: Screen / Route / Roles / Item are a
  `<header><dl>`, and states, role variation and backend needs are `<details class="states">`,
  `<details class="roles">` and `<details class="backend">` instead of HTML comments. Every screen box is a
  `<details>` too, with only the first one `open`, so a long screen is followed one section at a time.
  `<details>` is native HTML, so the no-scripts rule holds. `templates/blueprint-index.html` links the same
  sheet and keeps its table always visible. Why: the template hid states, role variation and backend needs
  in comments, which a browser does not render, so the developer reviewing the eight 11-inventory-ops
  wireframes saw about half of each file and had no hierarchy in the half that did show.

### Changed
- `references/blueprint.md` red flag, from "Styling in a wireframe: colours, fonts, spacing systems, a
  framework class" to "Styling beyond the shared `wireframe.css`: a brand colour, a component library, a
  framework class, an inline style." The inventory-not-design rule is unchanged; only reading is fixed.
  Procedure step 1 now requires the shared sheet, the visible sections and the collapsible structure, and
  the Output list names `wireframe.css`. `skills/pre-rolling-wave-planning/SKILL.md` Phase 3 names the sheet.

## 2.1.0 - 2026-09-18

### Added
- `templates/blueprint-index.html` and a blueprint procedure step: `planning/03-blueprint/index.html`, one
  table row per wireframe (link, Screen, Route, Roles, Item, question numbers) plus a suggested reading
  order, kept current in the same edit as any wireframe it lists. Why: the first v2 blueprint with more
  than a couple of screens (mashric 11-inventory-ops, eight wireframes) left the developer with no entry
  page for the review. `references/blueprint.md` gained the step, an output line and a red flag;
  `skills/pre-rolling-wave-planning/SKILL.md` Phase 3 and `references/ssot-layout.md` name the file.

## 2.0.0 - 2026-09-16

The restructure. One repo, one router, one file loaded per phase, drivers bound by role.

### Added
- `SKILL.md` is a router: core principles, find the SSOT, read `phase:` and `layout:` from
  `00-plan.md`, load exactly one target. Everything else moved to `references/`.
- `references/`: `ssot-layout`, `lifecycle`, `dispatch`, `review`, `verification`, `blueprint`,
  `adapters`, `ceremony`, `resume`.
- `templates/`: `00-plan`, `0-card`, `feature`, `02-adapters`, `adapters.default`,
  `handoff.agent`, `doc-handoff`, `verification-feature`, `deferred-README`, `wireframe.html`,
  `intake`.
- Pre-planning phases `intake` (the SSOT is created at minute zero and the developer's rant is
  kept verbatim in `planning/00-intake.md`) and `blueprint` (plain-HTML wireframes as a feature
  inventory per screen). Every phase writes a checkpoint before its work, so a session can end
  at any point and resume there.
- `02-adapters.md` per batch, seeded from `<project root>/adapters.default.md` and fresh
  detection; roles (`simplicity`, `tdd`, `ui-implementation`, `browser-verification`, ...) bound
  to installed skills, tools and model-tier aliases. Kickoff shows only the delta. A surface with
  no verification tool is a recorded decision, not a silent ceiling.
- Verification ladder L1 to L5 with a dated evidence log per feature, and the rubric evaluated
  twice: `agent` (L1 to L4) and `ceiling` (as if every human row passed). Later phases append
  evidence and re-derive; the resume sweep promotes items when human rows all read PASS.
- Five review points per feature/item/batch, with reuse and duplication as a review dimension. Four
  ride a PR; the fifth is the audit below, which is the only one that does not.
- `setup.sh` and `setup.ps1`: link the six skill entries into a skills directory, verify each
  resolves, report referenced skills present or missing with an install command, and report the
  tools on PATH. `--check` is the health check after either install path. `tests/setup/run.sh`
  proves both in Docker containers (Ubuntu for bash, the official PowerShell image for pwsh).
- Sub-skill paths resolve against the `rolling-wave-planning` skill directory (a sibling in the
  skills folder, or the repo root), so the family works both cloned and installed by skills.sh.
- A `framework` trigger for `@capacitor/core` in `references/dispatch.md`, with no default skill
  bound until one is installed.
- Docs chapter per feature, written on the feature branch by the docs-writer binding (an external
  CLI, or a subagent fallback that is not a failure state).
- Testing plan at three levels: the feature file's per-layer table, the card's `## Test strategy`
  (the item's L4 flow and cross-item group, the environment, the non-functional criterion, and how
  it was actually tested, filled at the item's open gate and closed at `agent-verified`), and
  `00-plan.md` § Testing plan (cross-item groups, end-to-end flows, environment, load criteria,
  written from the interview's testing round). `02-adapters.md` gained an `Environment` category
  beside load testing (Docker, a compose file, the Supabase local stack, testcontainers, staging),
  and the confidence rubric gained a sixth dimension, environment fidelity and stated limits.
- Ephemera cleanup. The dispatch packet has an eighth required slot, `Ephemera`: one scratch
  directory named on the packet for everything a subagent writes outside the repo and the SSOT,
  and a required "Ephemera started" list in the evidence it returns. Each line becomes a row in
  the item's `## Ephemera` ledger (`| What | Where | Teardown | Swept on |`) in
  `working/<item>.agent.md`. The item `agent-verified` gate, the batch `done` gate and the pause
  ceremony sweep that ledger: every row teardown-run and dated, or `kept: <reason>`.
  `02-adapters.md` gained a `Cleanup` category (scratch root, teardown lines in the order they
  run, cache to reclaim, and the date each line was actually run once), so nothing
  machine-specific reaches a packet.
- Acceptance list from the rant. Pre-planning Phase 0 writes `planning/00-acceptance.md` from
  `templates/00-acceptance.md`, one row per requirement in the developer's own words plus a fixed
  block of implicit rows (security pass on flagged surfaces, tested as far as L1 to L4 allow,
  a docs chapter per feature, no machine-specific binding in shared files, standing rules
  honoured). The interview's first round confirms the list before any design question. Cards carry
  `Acceptance rows served:`, the item `agent-verified` gate appends evidence to those rows, the
  batch `done` gate refuses a row still reading `open`, and `00-plan.md` STATE carries
  `acceptance: <n> of <m> rows met`. Resume does not load the file, so the entry load stays O(1).
  Agents never write `met`; the developer does, exactly as with an L5 verdict.
- Audit pass, the fifth review point and the only one not attached to a PR. `heavy` tier, fresh
  context, `templates/audit-handoff.md`, reading only `00-plan.md`, `planning/00-acceptance.md`,
  the open item's working file and `02-adapters.md`. Triggers are observable rather than
  scheduled: N dispatches since the last `audit` row (`dispatches_per_audit` in `02-adapters.md`
  § Audit, default 8), every pause, and before the batch PR opens. Findings and realignment actions go into `00-plan.md` STATE; the audit is recorded as a
  dispatch row, which resets the count. A harness scheduler is an optional binding in
  `02-adapters.md`, never part of the skill.
- `tests/scenarios/`: eight fresh-agent scenarios that gate a release. `07-acceptance-from-the-rant`
  (cold start from a rant; the baseline run wrote no acceptance file, RED confirmed 2026-09-17) and
  `08-ephemera-and-audit` (fixture 12 patched with Cleanup and Audit sections and six dispatch rows;
  the baseline run wrote no Ephemera slot and no audit packet, RED confirmed 2026-09-17). Both
  passed against the changed skill on 2026-09-17; scenarios 01 and 03 re-ran clean on the patched fixture.
- `TODO.md`: work that is deliberately parked, one entry per item with what is missing, why, and
  what closes it.
- `README.md`, `LICENSE` (MIT), `VERSION`.

### Changed (breaking for new batches; existing batches keep `layout: v1`)
- Lifecycle: feature `pending -> in-progress -> reviewed -> agent-verified -> documented -> merged`;
  item `pending -> in-progress -> agent-verified -> documented -> complete`. `code-done` and
  `verified` are gone. `documented` is the agent's terminal state.
- `human/` is `docs/`, one chapter per feature with three-digit reading-order prefixes.
- `human-assisted-verification` has zero agent steps: each row carries the exact query or command
  the human runs. The interrupt handshake is gone; its 24h concern is a time-sensitive row flag.
- Line caps are soft targets on human-facing files only; `validate_docset.py` warns instead of
  failing. Agent files have no cap.
- Model-vendor names appear only as examples in `references/adapters.md`. Skill bodies name
  tiers (`judge`, `heavy`, `light`) and roles.
- `pre-rolling-wave-planning` no longer has an execution-discipline phase; TDD, review cadence
  and verification are fixed defaults in the main skill.
- `mentor-documentation-system` ships inside this repo; `human-engineering-docs` and
  `senior-mentor` are invocable by name through symlinks.

### Removed
- `02-deferred.md`. Out-of-scope work becomes a sibling stub directory `<M>-<slug>/README.md`,
  linked from `00-plan.md`, and is the intake seed when picked up.
- Item-level `rollout/<n>-<item>/docs/`. Architecture notes become a reading-order chapter in the
  batch `docs/`.
- The repo-specific project-state-table step in the pause ceremony (generalised).

### Fixed
- `tests/setup/run.sh` skips its PowerShell cases when the Docker daemon is not amd64. The
  `mcr.microsoft.com/powershell` image is amd64-only and crashes at startup under Docker Desktop's
  emulation on Apple silicon (exit 134 or 139); the cases passed under colima, so `setup.ps1`
  itself is not known to be broken. `RUN_PWSH=1` forces them to run. Building an arm64 PowerShell
  test image so the skip stops being necessary is parked in `TODO.md`.
- Frontmatter descriptions state only when to use. The human-assisted-verification description
  is quoted, because an unquoted colon broke strict YAML parsers (skills.sh skipped the skill).

## 1.0.0 - 2026-09-16

Verbatim import of the four skills as they existed before the v2 restructure:
`rolling-wave-planning` (SKILL.md, ceremony.md, feature-file-template.md),
`pre-rolling-wave-planning`, `human-assisted-verification`, and the
`mentor-documentation-system` bundle. No content edits. Tag `v1.0.0` is the
revert point.
