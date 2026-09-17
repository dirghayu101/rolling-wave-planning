# Scenario 7: Acceptance list from the rant

## Fixture

None of the committed fixtures. The orchestrator creates a **fresh empty directory** in a scratch
location and hands its absolute path as `<FIXTURE>`: no SSOT exists yet, no `00-plan.md`, no
`planning/`, no git history. The whole point is a cold start from nothing but the developer's
rant, which is Phase 0's real situation. Do not seed the directory with anything.

## Prompt

Give the fresh agent exactly this, filling `<FIXTURE>` with the absolute path of the empty
directory created for this run:

> I want to start planning a new feature for our Next.js dashboard (Supabase behind it). Here is
> the brief, in my words:
>
> "Okay so our merchants keep complaining about store hours. Right now hours are hardcoded in a
> seed file and nobody but us can change them, which is insane. I want a proper editor in the
> dashboard: a screen where a store's regular weekly hours can be set, Monday through Sunday, and
> where you can add split hours for a day, because half of them close for lunch. On top of that I
> need holiday closures, one-off closed days or a date range with a reason like 'Christmas,
> closed', and those have to win over the weekly hours. Only the store owner should be able to
> edit any of this. Staff accounts can look at it, they must not be able to touch it, and I want
> an audit trail so we can see who changed what and when, because last time something like this
> broke we had no idea who did it. The public store page has to show the hours and get 'open now'
> versus 'closed' right, and it has to use the store's own timezone, not whatever the server
> thinks. Half our merchants do this on their phone, so the week grid cannot overflow or turn into
> a horizontal scroll mess on a small screen. Saving a day should feel instant, no full page
> reload every time you nudge a time. And if one day in the save fails, the whole thing fails, I
> do not want half-saved hours. Also let me copy Monday to the rest of the week in one click. Last
> thing: I want to see proof for every one of these, not an agent telling me it is done."
>
> Start the `pre-rolling-wave-planning` skill for this effort. The SSOT directory is
> `<FIXTURE>/docs/features/`. **Stop after Phase 0 intake is written**: do not run exploration, do
> not ask me interview questions, do not scaffold items or cards. Then report (1) every file you
> read and (2) every file you wrote, with the full contents of each file you wrote.
> Do not open anything under the skill repo's `tests/` directory.
> End your answer with a list titled "Files I read" naming every file you opened, in the order you
> opened them.

## Pass criteria

- [ ] `planning/00-acceptance.md` exists under `<FIXTURE>/docs/features/`, written during Phase 0,
  not promised for later and not folded into `planning/00-intake.md` as a paragraph.
- [ ] It has **one row per explicit requirement in the rant, at least 10 of them**, each phrased in
  the developer's own words rather than restated in agent prose. Spot-check that these three
  phrases survive close to verbatim: "who changed what and when", "the whole thing fails, I do not
  want half-saved hours", and "copy Monday to the rest of the week in one click". A row that reads
  "implement transactional persistence semantics" instead of the third one is a fail: the rant's
  wording is what the developer will recognise at the end.
- [ ] Rows exist for at least these requirements, however worded: the editor screen with weekly
  hours, split hours per day, holiday closures with a reason that beat the weekly hours, owner-only
  editing, staff read-only, the audit trail, the public page's open/closed state, the store's own
  timezone, the phone-width week grid, saving that feels instant with no full page reload,
  all-or-nothing saves, copy Monday to the rest of the week, and the demand for proof on every row.
- [ ] Beyond the explicit rows, there are **implicit rows** for at least: a security pass on the
  flagged surface (owner-only editing plus the audit trail), tested as far as L1 to L4 allow, and
  documented. These are not in the rant; the skill is supposed to add them.
- [ ] Every row has a verdict column whose value is `open` and an empty evidence column. No row is
  pre-marked met, passed or done: nothing has been built yet.
- [ ] The Phase 0 checkpoint (in `planning/00-intake.md`, or the `00-plan.md` STATE block, or both)
  states that the **interview's first round confirms this list** before design questions are asked,
  and that a row the developer strikes is recorded as struck rather than deleted.
- [ ] `00-plan.md` STATE carries an `acceptance:` line reading `acceptance: 0 of <m>` (any wording
  of the tail, for example `0 of 16 rows evidenced`), where `<m>` equals the number of rows actually
  written in `planning/00-acceptance.md`. A mismatch between the two numbers is a fail.
- [ ] The sensitive surface is carried forward, not just listed: the intake file flags owner-only
  editing and the audit trail as a sensitive surface, so the later `security-review` role has
  something to bind to.
- [ ] "Files I read" holds only the skill router (`SKILL.md`), the pre-planning sub-skill
  (`skills/pre-rolling-wave-planning/SKILL.md`), and the templates Phase 0 needs
  (`templates/00-plan.md`, `templates/intake.md`, plus an acceptance template if the repo ships
  one). `references/ssot-layout.md` is acceptable. Reading `references/dispatch.md`,
  `references/verification.md`, `references/blueprint.md` or any later-phase reference is a fail:
  Phase 0 loads one phase's worth of context, not the whole skill.
- [ ] Nothing under the skill repo's `tests/` directory appears in the list. If it does, the run is
  void (README rule 5): re-run with a fresh agent, do not grade it.
- [ ] The runner actually stopped: no `planning/01-exploration.md`, no `rollout/` tree, no interview
  questions asked back.

## Grading

**Baseline expectation (what a run looks like without the new skill content):** the runner writes
`00-plan.md` and `planning/00-intake.md`, keeps the rant verbatim under `## Rant (verbatim)`, fills
Goals and Constraints as a short summary, and writes **no acceptance file at all**. Criteria 1
through 6 fail together, and the STATE block has no `acceptance:` line. That is the signature of
the pre-change skill; grade it as a clean baseline failure rather than as a broken run.

**Most likely to fail once the change is in:** criterion 2, the developer's own words. Summarising
is the strongest habit an agent has, and a row rewritten into requirement-speak is exactly the
failure this list exists to prevent: at the end of the batch the developer has to be able to read
their own brief back and say whether it was honoured. Criterion 7 (the STATE count matching the row
count) is the second cheapest tell, because it is the one number a cold session sees on resume.

## Exercises

`skills/pre-rolling-wave-planning/SKILL.md` Phase 0, `templates/intake.md`, `templates/00-plan.md`
STATE block, the acceptance-list template if one ships.
