# Scenario 6: Testing plan shape

## Fixture

`fixtures/12-notifications/` (same fixture as scenarios 1, 3 and 4). Item 5 (`mute-channels`) is at
stage `pending`: its card has no `## Test strategy` filled in, because filling it is the
`pending → in-progress` gate's job and that gate has not been taken. `00-plan.md` already carries a
filled `## Testing plan`: one cross-item group (`quota-mute-settings`, items 4 and 5, recorded on 5,
`pending`), one end-to-end flow driven by `browser-verification` at batch `done`, the environment
(`supabase start` with `supabase/seed.sql`, reset `supabase db reset`), and one load criterion
(the digest scheduler and 500 users, `k6`).

## Prompt

Give the fresh agent exactly this, filling `<FIXTURE>` with the absolute path of a fresh COPY of
`fixtures/12-notifications/`:

> You are working in an existing rolling-wave-planning batch at `<FIXTURE>`. Invoke the
> `rolling-wave-planning` skill. Item 5 (mute-per-channel settings) is the next item to open.
> Before any dispatch, the developer wants to be able to read, briefly, how item 5 will be tested
> as a whole once its features exist (the features together, not one by one), in which environment
> those tests run, whether any performance criterion applies to it, and how the batch will do its
> cross-item and end-to-end testing later when items that depend on each other are all in. Report
> exactly what you would write for each of those things and the exact file and section where each would live in this batch's SSOT, following the
> skill's own layout. Do not create, edit, or scaffold any file, and do not dispatch any subagent.
> Do not open anything under the skill repo's `tests/` directory. End your answer with a list titled "Files I read" naming every file you opened, in the order you
> opened them.

## Pass criteria

(Corrected 2026-09-17: the prompt gained the performance-criterion clause and the file-count
criterion reads "about ten" because the first clean run read ten files and omitted the
non-functional line the prompt never asked about.)

- [ ] Names `rollout/5-mute-channels/0-card.md` § Test strategy as the item-level home, and drafts
  its four labelled lines (`L4 flow:`, `Environment:`, `Non-functional:`, `How it was tested:`), not "each feature file's L4 row" and not a new file invented for the purpose.
- [ ] The `Environment:` line quotes the plan's environment (`supabase start`, the
  `supabase/seed.sql` seed, `supabase db reset`), **not** the adapter tool bindings
  (`agent-browser`, Supabase MCP). Confusing the environment with the tool bindings is the baseline failure this scenario exists to catch.
- [ ] Names `00-plan.md` § Testing plan as the batch-level home for cross-item and end-to-end
  testing, and cites the **existing** `quota-mute-settings` group (items 4 and 5, recorded on 5) and
  the existing end-to-end flow, rather than inventing cross-links between feature files or naming
  review point 4 as the end-to-end gate.
- [ ] Says the `quota-mute-settings` group's L4 pass is recorded on item 5 (the later item), and
  that the group's row moves from `pending` to `ran <date>`.
- [ ] Either cites the batch's load criterion and says it is gated on item 3, or states plainly that
  item 5 has no non-functional criterion, so its `Non-functional:` line reads `none stated`.
- [ ] "Files I read" contains **no** item 4 feature file (`rollout/4-quota/1-quota-banner.md`,
  `2-quota-settings.md`) and **no** working file (`working/4-quota.agent.md`): the card and the plan
  suffice. At most about ten files in total.
- [ ] No file was created or edited (the fixture copy's `git status`, or the absence of any write in
  the transcript).

**Most likely to fail if the skill is broken:** the file-count clause. Before the Testing plan
slots existed, a cold agent answered this question by reading sixteen files (every item 4 feature
file, the working file and three cards) and still concluded the item-level answer lived only in
each feature file's L4 row. A skill whose card and plan do not hold the answer forces that sweep,
which is the constant-cost resume promise breaking.

## Exercises

`templates/0-card.md` § Test strategy, `templates/00-plan.md` § Testing plan,
`references/verification.md` § L4, `references/lifecycle.md` item `pending → in-progress` gate,
`references/adapters.md` § Environment.
