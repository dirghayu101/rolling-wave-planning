# Scenario 4 — Verification file shape

## Fixture

`fixtures/12-notifications/` (same fixture as scenarios 1 and 3). Feature 4.1 (`quota-banner`) is
at stage `merged` with L1, L2 and L3 evidence rows already recorded in
`rollout/4-quota/1-quota-banner.md` (unit tests, an integration test against the test-branch DB,
and an agent-browser pass with screenshots and clean console/network capture). `verification/` is
empty — no L5 file has been written for this feature yet, and `01-verification.md`'s index has no
row for it.

## Prompt

Give the fresh agent exactly this, filling `<FIXTURE>` with the absolute path of a fresh COPY of
`fixtures/12-notifications/`:

> You are working in an existing rolling-wave-planning batch at `<FIXTURE>`. Invoke the
> `rolling-wave-planning` skill. Your task is "Write the verification for feature 4.1 and score
> it." Read `rollout/4-quota/1-quota-banner.md` for what has already been proven. Write the
> feature's L5 human verification file at its correct path, using
> `templates/verification-feature.md` as the shape, and add its index row to
> `01-verification.md`. Then confirm the feature's `agent` and `ceiling` confidence line in
> `rollout/4-quota/1-quota-banner.md` is still correctly dated given the evidence, re-deriving it
> if not. Paste the full contents of every file you wrote or changed in your answer. End your
> answer with a list titled "Files I read" naming every file you opened, in the order you opened
> them.

## Pass criteria

- [ ] Every verdict cell in the produced file reads `open`; the index row reads `open`; no L5 row was added to the evidence log (found 2026-09-16: a runner pre-filled PASS on every row).

- [ ] The verification file is written at `verification/4.1-quota-banner.md` (per
  `references/verification.md`'s `verification/<n>.<f>-<slug>.md` naming), not inside `rollout/`
  and not under a made-up path.
- [ ] Every row in the written file is a human action or a human-only observation with the exact
  query, command, or console path pasted ready to use — **zero agent steps**. (A row that says
  "check the logs" or "verify it works" without the exact SQL/CLI/console path is a fail.)
- [ ] Nothing in the written file duplicates an L1-L4 check the feature file already proves (unit
  tests, the integration test, or the agent-browser L3 pass) — an L5 row holding something an
  agent already checked is the rogue-check finding this ladder exists to avoid.
- [ ] The index row is appended to `01-verification.md` in the shape the template specifies (Ref,
  What, File, Rows, Verdict, Date), referencing `4.1`.
- [ ] The `agent`/`ceiling` confidence line in the feature file is re-derived with a fresh date
  (per `references/verification.md`'s re-derivation rule) rather than left at its stale date, and
  the answer names which dimension the score's justification rests on.
- [ ] No row is marked with a verdict of PASS by the agent itself — verdicts and dates in the L5
  file are left for the human to fill; the agent only writes the rows and the setup the human
  needs.

**Most likely to fail if the skill is broken:** the "zero agent steps" clause — if
`human-assisted-verification`'s narrowing to L5-only content has rotted, the agent will write a
row like "confirm the banner renders" that it could itself have checked with agent-browser, which
is the rogue-check's classic finding.

## Exercises

`skills/human-assisted-verification/SKILL.md`, `references/verification.md`,
`templates/verification-feature.md`.
