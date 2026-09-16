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
| **L4 cross-feature** | one item (or a defined cross-item group) | the features work together |
| **L5 human-only** | whatever is left | what only a human can do or perceive |

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
`agent-verified` stage. When the batch defines cross-item groups (a flow that only exists once
items 2 and 5 are both in), the group's L4 pass is recorded on the later item and named in both.

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
micromanages the implementing agent. Weigh five dimensions:

1. **Unit coverage of exit points**: every exit point of every changed unit has a test, per the
   one-test-per-exit-point convention, or the gap is named.
2. **Integration seams exercised**: the boundaries this feature crosses are actually run, not
   mocked away on both sides.
3. **Real-surface verification**: the bound browser or mobile adapter was driven for any surface a
   user touches, or the uncovered-surface decision is cited.
4. **Review findings raised vs resolved**: an unresolved finding on the PR lowers the score.
5. **Unverifiable effects honestly listed**: declaring "the push send is unobserved" raises trust;
   omitting it and being caught in review destroys it.

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
agent-actionable entry still sitting on the list at feature close is a red flag.

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
- A confidence line carrying one number, or a date older than the newest evidence-log row.
- An evidence cell that says "verified" instead of naming a re-openable artifact.
- A log-based row with no `time-sensitive (24h)` flag.
- A seam "tested" with a mock on both sides.
- An L3 row left blank on a feature with a user-facing surface, with no uncovered-surface decision.
- A ledger row at `complete` above an unticked `01-verification.md`, or ticked in a different commit.
- An agent-actionable entry still on "what would raise this" at feature close.
