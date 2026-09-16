# Per-Feature Human Verification File — Template

Template for `rolling-wave-planning`. Lives at `verification/<n>.<f>-<slug>.md`, one per feature
that owns L5 rows. Written by the `human-assisted-verification` skill at the feature's
`reviewed → agent-verified` gate, once its L1 to L3 evidence is in, so the rows contain only what is
left for a human. Handed over at `documented`.

**Zero agent steps.** Every row is a human action or a human-only observation, and the human runs
the check themselves: each row carries the exact query, command or console path, pasted ready to
use. Anything an agent can observe is L1 to L4 evidence in the feature file, not a row here.

## Template — copy verbatim, replacing bracketed text

```markdown
# Verification <n>.<f> — <Feature Title>

Feature: `rollout/<n>-<item-slug>/<f>-<feature-slug>.md` · Indexed in `01-verification.md`
Written <YYYY-MM-DD>. Handed over at stage `documented`; all rows PASS promotes the item to `complete`.

Setup the human needs first: <account / role / device / build, or "none">.

| # | Human steps | Human-only observation | Check it yourself | 24h | Verdict + date |
|---|---|---|---|---|---|
| 1 | <Numbered, unambiguous app actions. "1. Open the app → Profile → Contact Support. 2. Type `test-123`. 3. Tap Submit." Assume the human is deliberately slow — leave no gaps: name the exact screen, the exact label, the exact text to type.> | <What no tool can see: "a success toast appears and the field clears".> | <The exact thing the human runs, pasted ready to use. SQL for the database console: `select id, message, created_at from support_tickets where message = 'test-123' order by created_at desc limit 1;` · a CLI command: `<cmd>` · a path in the admin UI: Dashboard → Support → Tickets, newest row.> | <no \| yes> | <PASS / FAIL / NEEDS-HUMAN> <YYYY-MM-DD> |
| 2 | … | … | … | … | … |

**24h column:** `yes` when the check reads a log rather than durable state. Log retention is about
a day, so that row expires. Run the `yes` rows first, and on the same day the handover happens.

If a check fails because the observable itself was wrong (the row never appears, the log line does
not exist), do not record FAIL for the feature: record `NEEDS-HUMAN`, say so, and the pivot to an
alternative observable is recorded here and in `00-plan.md` STATE.

## Index row: paste into `01-verification.md`

| Ref | What | File | Rows | Verdict | Date |
|---|---|---|---|---|---|
| <n>.<f> | <feature title> | `verification/<n>.<f>-<slug>.md` | <total> | <x/total PASS \| open> | <YYYY-MM-DD> |
```

## Cross-feature variant: `verification/group-<slug>.md`

A human check that only exists once two or more features (or two or more items) are both in gets its
own file, `verification/group-<slug>.md`, with the same table. Two differences:

- The header names **every** feature and item the group spans, and each of those feature files links
  to the group file from its L5 test-strategy row.
- The index row's `Ref` is `group-<slug>` and its `What` names the spanned items, so the resume sweep
  knows the group's PASS promotes more than one item.

A group file is written when the **last** of its features reaches `documented`, never earlier: a
group row a human cannot run yet reads as an open obligation and stalls the sweep.
