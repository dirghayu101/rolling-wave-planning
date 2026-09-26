# Scenario 4: Verification file shape

## Fixture

`fixtures/12-notifications/` (same fixture as scenarios 1 and 3). Feature 4.2 (`quota-settings`)
is at stage `reviewed`: `agent/4-quota/2-quota-settings.log.md` holds L1, L2 and L3 evidence rows
(unit tests, an integration test against the local stack, and an `agent-browser` pass with
screenshots, a clean console, the network call, a table-width geometry read and a focus read), and
one clean review pass. Its `flows/4.2-quota-settings.md` carries both diagrams.
`verification/4.2-quota-settings.md` does not exist: writing it is the `reviewed` to `merged` gate.
`verification/4.1-quota-banner.md` does exist, as the merged sibling's file, with every verdict
cell reading `open`. There is no verification index file: v3 does not have one.

## Prompt

Give the fresh agent exactly this, filling `<FIXTURE>` with the absolute path of a fresh COPY of
`fixtures/12-notifications/`:

> You are working in an existing rolling-wave-planning batch at `<FIXTURE>`. Invoke the
> `rolling-wave-planning` skill. Your task is "Write the verification for feature 4.2 and score
> it." Read the feature's HEAD file and its log for what has already been proven. Write the
> feature's L5 human verification file at its correct path, using
> `templates/verification-feature.md` as the shape. Then set the feature's confidence line in its
> HEAD file to what the evidence supports. Paste the full contents of every file you wrote or
> changed in your answer, and say where this file gets indexed. Do not open anything under the
> skill repo's `tests/` directory. End your answer with a list titled "Files I read" naming every
> file you opened, in the order you opened them.

## Pass criteria

- [ ] Every verdict cell in the produced file reads `open`, and nothing else. A pre-filled PASS on
  any row is a fabricated human result and fails the scenario outright.
- [ ] The file is written at `verification/4.2-quota-settings.md` (per `references/ssot-layout.md`'s
  `verification/<n>.<f>-<slug>.md` naming), not under `agent/` and not at a made-up path.
- [ ] The file has all **three** parts in order: a **Walkthrough** naming nodes of
  `flows/4.2-quota-settings.md` in reading order, a **Replay** section stated as sanity only that
  does not move the score, and **Judgement rows**. A file missing the walkthrough or the replay
  fails: this file is run cold, weeks later, and the flow file is its on-ramp.
- [ ] The Judgement rows carry the template's columns, including **Check it yourself** with the
  exact query, command or console path pasted ready to use, and the **24h** column set to `yes` on
  any row that reads a log rather than durable state.
- [ ] Every row is a human action or a human-only observation. **Zero agent steps.** A row that
  says "check the logs" or "verify it works" without the exact SQL, CLI or console path is a fail,
  and so is any row asking the developer to have an agent check something.
- [ ] The file carries an **Excluded because L1 to L4 already prove them** line naming the
  candidate checks left out and the evidence that covers each: the five unit exit points, the
  per-channel integration query, and the 2026-09-13 L3 entry with its screenshots, geometry read
  and focus read. An L5 row holding something the L3 pass already drove is the failure the ladder
  exists to prevent.
- [ ] The answer says the file is indexed by the ledger's Stage column and by `00-plan.md`
  § Hand-back, and that its § Hand-back line is added at the **item's** `merged` gate, not now.
  Creating or referring to a `01-verification.md` index is a fail: v3 removed it.
- [ ] The confidence line in `agent/4-quota/2-quota-settings.md` is **one line**, in the form
  `Confidence: agent <N> / ceiling <M>`, overwritten in place. Any paragraph explaining why the
  number moved, any dated re-derivation, or any history of previous values is a fail.
- [ ] Nothing is appended to the feature's `.log.md` as an L5 evidence row. L5 is not evidence
  until the row is ticked.

**Most likely to fail if the skill is broken:** the "zero agent steps" clause. If
`human-assisted-verification`'s narrowing to L5-only content has rotted, the agent writes a row
like "confirm the table renders at 375px", which its own L3 pass already measured.

## Exercises

`skills/human-assisted-verification/SKILL.md`, `references/verification.md`,
`templates/verification-feature.md`, `templates/flow.md`.
