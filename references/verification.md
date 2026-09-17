# Verification

Reference for `rolling-wave-planning`. Load it at a verification transition, and at `phase: done`
for the promotion pass. `references/review.md` covers who reads the code; this file covers what
proves it works.

## The ladder

Five layers. **A layer is climbed, not skipped.** Everything an agent can observe belongs to L1 to
L4 and is finished before anything is handed to a human: an L5 row holding a check an agent could
have run is a rogue-check finding, not a thorough checklist.

| Layer | Scope | Proves |
|---|---|---|
| **L1 unit** | one unit | each exit point behaves |
| **L2 integration** | one seam | the boundary is really crossed |
| **L3 real surface** | one feature | the surface a user touches actually does it |
| **L4 cross-feature** | one item (or a defined cross-item group) | the features work together, in the environment the plan names, within any stated limits |
| **L5 human-only** | whatever is left | what only a human can do or perceive; verdicts written by the human only, agent hands over `open` |

### L1 unit

TDD, red before green, under the `tdd` role bound in `02-adapters.md`. **One test per exit point**,
and exactly three kinds of exit point exist: a return value or thrown error, a state change observed
through another public call, and a call to an outgoing dependency asserted on a mock. Never two exit
points in one test. Incoming dependencies are stubbed and never asserted on; at most one mock per
test. Names follow `unitUnderTest_scenario_expectation`. If the project ships its own
`TESTING_CONVENTIONS.md`, that file governs the details.

### L2 integration seams

The boundaries this feature crosses are **actually exercised**, not mocked away on both sides: the
database call hits a real (test or branch) database, the edge function is invoked, the auth boundary
is crossed with a real token. A seam mocked on both sides proves only that the mocks agree.

### L3 real surface, one feature

Drive the surface for real through the adapter bound in `02-adapters.md`.

- **Web** (`browser-verification`, `agent-browser` today under the developer's standing browser
  rule): drive the flow the feature delivers end to end; assert on the rendered element or state;
  `console --clear` before the flow and `errors --json` after, clean of new errors (the plain-text
  `errors` output prints empty rows, so `--json` is not optional); `network requests` for the calls
  the change is supposed to make; a screenshot at every breakpoint the feature claims to support.
  When the feature builds a screen from a wireframe, run the wireframe comparison in
  `references/blueprint.md` and log its diff as the evidence.
- **Mobile** (`mobile-verification`): the bound mobile tool, driving the same shape of flow.
- **No adapter bound for the surface:** that is an **uncovered surface**, which is a recorded
  kickoff decision in `00-plan.md` per `references/adapters.md`. The feature's L3 row then reads
  `uncovered: see decision <#>` and the work it would have proven moves to L5. An L3 row left
  blank with no decision behind it is drift.

### L4 cross-feature, at item level

The item's features exercised **together**, not one after another: the flow that crosses two of
them, the shared type or migration both depend on, the screen that renders another feature's data.
Runs when every feature PR has merged into the item branch, and it gates the item's
`agent-verified` stage.

**It runs in the environment the card names**, copied there from `00-plan.md` § Testing plan: the
compose stack, the local Supabase stack with its seed, or the staging deployment. An L4 pass run
against mocks on both sides of every seam proves the mocks agree, at item scale.

**Cross-item groups are defined in `00-plan.md` § Testing plan**, not invented at L4 time and not
cross-linked between feature files. A group is a flow that only exists once two or more items are in
(items 2 and 5 both landed); its L4 pass is recorded on the later item, named on both cards by the
group's slug, and its row in the Testing plan moves from `pending` to `ran <date>`.

**When the card's `Non-functional:` line states a criterion**, the load tool bound in
`02-adapters.md` § Load testing measures it as part of L4, and the measured numbers (not "looks
fine") go in the evidence log beside the command that produced them.

### L5 human-only

What no tool bound in this batch can perform or perceive. Invoke the `human-assisted-verification`
skill to write these rows; it owns their shape. Rows live in `verification/<n>.<f>-<slug>.md` per
feature, and `verification/group-<slug>.md` for cross-feature human checks, each indexed by one row
in `01-verification.md`. L5 rows are the only thing standing between `documented` and `complete`.

## Evidence log

Every feature file carries one, appended to as layers are climbed:

```markdown
## Evidence log

| date | layer | evidence | by |
|---|---|---|---|
| 2026-09-16 | L1 | `tests/unit/quota.test.ts`, 7 exit points, all green in CI run #412 | tdd · heavy |
| 2026-09-16 | L3 | `assets/4.2-quota-1440.png`, `errors --json` empty, POST /api/quota 200 | browser-verification · light |
```

**Evidence is a pointer to something re-openable**: a test file path, a CI run, a screenshot under
`assets/`, the query plus the row it returned, a verification row id. "Verified, works" is not
evidence. `by` is the role and tier that produced it, never a model name.

**Durable observable first.** Assert on durable state (a persisted row, a status field) wherever the
behavior produces one, because it does not expire. Logs are primary **only** for fire-and-forget
calls with no persisted trace, and a log-based row is flagged **time-sensitive (24h)** in both the
evidence log and any L5 row that inherits it: log retention is about a day, so the evidence is gone
before a paused batch resumes. Note dev-time database resets too: a row you assert on may be wiped.

## Confidence: `agent` and `ceiling`

A **judgment against a rubric, with no prescriptive arithmetic.** A formula invites gaming and
micromanages the implementing agent. Weigh six dimensions:

1. **Unit coverage of exit points**: every exit point of every changed unit has a test, per the
   one-test-per-exit-point convention, or the gap is named.
2. **Integration seams exercised**: the boundaries this feature crosses are actually run, not
   mocked away on both sides.
3. **Real-surface verification**: the bound browser or mobile adapter was driven for any surface a
   user touches, or the uncovered-surface decision is cited.
4. **Review findings raised vs resolved**: an unresolved finding on the PR lowers the score.
5. **Unverifiable effects honestly listed**: declaring "the push send is unobserved" raises trust;
   omitting it and being caught in review destroys it.
6. **Environment fidelity and stated limits**: L2 to L4 ran in the environment the plan names
   rather than against mocks on both sides, and any stated non-functional criterion was measured
   with the bound tool; a real environment and a measured limit raise the score, a stated criterion
   left unmeasured lowers it.

**`planning/00-acceptance.md` is an input to the evaluation, not a seventh dimension.** Load it at the gate that derives the scores, find the rows this item's card names on its `Acceptance rows served:` line, and read what evidence they carry. A row with no evidence **caps nothing**: the developer's requirement is not a rubric dimension, and a score is about what the code has been proven to do. It goes on the **"what would raise this" list** instead, named as the row it is (`acceptance row 7: <the developer's words>, no evidence yet`), which is how a requirement nobody has answered stays visible in the file the developer actually reads.

**The same rubric is evaluated twice, and both numbers are dated:**

- **`agent`**: scored on the L1 to L4 evidence that exists **today**. This is what the agent has
  actually proven.
- **`ceiling`**: scored with every L5 row in this feature's verification file **assumed PASS**.
  This is the best the number can become without building new tooling.

A wide gap says the feature's assurance is parked on the human; a low ceiling says no amount of
human ticking will fix it and the raise has to be built. Both go on one line in the feature file:
`## Confidence: agent 62 · ceiling 88 (2026-09-16)`, with 2 to 4 lines naming the **weakest
dimension**.

**Re-derivation rule.** Any later phase that adds evidence for a feature appends an evidence-log row
and **re-derives both numbers with a fresh date**, even when the number does not move. A score whose
date is older than the newest evidence row is stale, and the integrity sweep treats it as drift.

**"What would raise this" is the payload.** The developer reads scores, not diffs, and dives where
the number is low. **Exhaust agent-actionable raises first:** anything an agent can execute with
available tooling (a browser flow, an extra seam test, a machine assertion) is *done*, not listed.
The list is only for raises needing human intervention or infrastructure that does not exist yet. An
agent-actionable entry still sitting on the list at feature close is a red flag. Two raises are
almost always agent-actionable and therefore belong in the *done* column: running L4 in the
environment the plan names instead of against mocks, and measuring the criterion the card's
`Non-functional:` line states with the bound load tool.

**Anti-gaming:** the rogue-check spot-checks by re-deriving one or two scores from the diff. A score
that does not survive re-derivation is a rogue-check finding.

## Promotion to `complete`

`01-verification.md` is the index of L5 rows; the verdicts live in the `verification/` files and are
summarized there.

- **Same-commit rule:** ticking the verification index is what moves a ledger row from `documented`
  to `complete`: **tick and row change in the same commit.** Audits found ledgers asserting DONE
  above fully unchecked checklists in 2 of 4 batches.
- **No human-verifiable surface** (pure tooling, internal refactor)? Record the **substitute** in
  the item's card (fault injection, a CI gate, a migration dry-run) and cite it in the index row.
  Never drop the file silently.
- **The resume sweep promotes.** Every resume reads the `verification/` files for verdicts the human
  ticked while no session was running, and promotes any item whose rows are all PASS to `complete`
  in the same commit as the tick it is acting on. A FAIL becomes a mid-flight input, triaged per
  `references/resume.md`.

## Red flags

- An L5 row holding something the bound adapters could have checked.
- A verdict cell that reads anything but `open` in a file the agent just wrote, or an L5 row in the evidence log with no human tick behind it. Both are fabricated human results.
- A confidence line carrying one number, or a date older than the newest evidence-log row.
- An evidence cell that says "verified" instead of naming a re-openable artifact.
- A log-based row with no `time-sensitive (24h)` flag.
- A seam "tested" with a mock on both sides.
- An L3 row left blank on a feature with a user-facing surface, with no uncovered-surface decision.
- A ledger row at `complete` above an unticked `01-verification.md`, or ticked in a different commit.
- An agent-actionable entry still on "what would raise this" at feature close.
- An item at `agent-verified` whose card's `How it was tested:` line is empty.
- A cross-item group in `00-plan.md` § Testing plan still reading `pending` when the batch reaches `done`.
- An acceptance row the card names, left with no evidence and no line on "what would raise this".
- A verdict in `planning/00-acceptance.md` moved to `met` by an agent on its own reading, or a struck row deleted instead of kept with its reason.
