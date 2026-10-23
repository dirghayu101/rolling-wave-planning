# Scenario 10: An out-of-scope finding is filed in the tracker

## Fixture

`fixtures/12-notifications/` (same fixture as scenarios 1, 3, 4, 6, 8 and 9). Three things in it
matter here:

- `agent/adapters.md` § Issue tracker binds `tea` against `example.invalid` with `enabled: true`,
  a `File:` line, the title form `[12] <title>`, and the labels `batch:12-notifications` plus
  `bug` or `enhancement`.
- `planning/00-intake.md` § Goals names email deliverability (bounces, complaints, suppression
  lists) as a non-goal of this batch.
- `00-plan.md` § Deferred reads `- none`, and `planning/00-acceptance.md` has four rows.

Item 4 is `open`: 4.1 `merged`, 4.2 `reviewed`, 4.3 not opened.

## Prompt

Give the fresh agent exactly this, filling `<FIXTURE>` with the absolute path of a fresh COPY of
`fixtures/12-notifications/`:

> You are working in an existing rolling-wave-planning batch at `<FIXTURE>`. Invoke the
> `rolling-wave-planning` skill. While item 4 is open, you find that the email channel's bounce
> handling silently drops bounces: a bounced digest is never recorded, so the same address keeps
> being sent to. You tell the developer, who replies: "Bounced digests should be suppressed and
> the user should see that their email bounced, not just keep failing. Not in this batch." Handle this mid-flight
> input exactly as the skill says. You cannot run shell commands: wherever you would run one,
> write the exact command instead. Make every file edit the skill calls for and show each one in
> your answer, and paste in full any text you would send to an outside system. Do not open
> anything under the skill repo's `tests/` directory. End your answer with a list titled "Files I
> read" naming every file you opened, in the order you opened them.

## Pass criteria

- [ ] The triage lands on **Out of scope**, citing the intake's non-goal. In scope, Minor or
  Unclear is a fail.
- [ ] No new directory is created beside the batch or inside it, and no `README.md` stub is
  written. A `<M>-<slug>/` sibling, a numbered slot taken for the finding, or a new file under
  `agent/` for it is a fail.
- [ ] The answer writes the exact filing command in the shape of the binding's `File:` line:
  `tea issues create --login example --repo notifications ...`, with a title in the form
  `[12] <title>` and labels `batch:12-notifications` plus one of `bug` or `enhancement`. A command
  invented from another tracker, or a title or label set not read from § Issue tracker, is a fail.
- [ ] The body file the command reads sits under the scratch root `/tmp/rwp-12-notifications/`,
  not inside the repo.
- [ ] The pasted issue body follows `templates/deferred-issue.md`: what in observable terms, why it
  is out of scope with the actual reason (the intake non-goal), context to pick it up cold with the
  evidence pasted in, and an origin naming the date, batch `12-notifications`, item 4 and a SHA
  placeholder. It closes with the line that `pre-rolling-wave-planning` takes it as the intake seed.
- [ ] `00-plan.md` § Deferred replaces `- none` with exactly one line of the form
  `- <issue url>: <title>`, the url a placeholder for what the command returns.
- [ ] `planning/00-acceptance.md` gains one dated row holding the developer's sentence in their
  words, with verdict `deferred: <issue url>`. A paraphrase in agent vocabulary is a fail.
- [ ] No item, card, feature, ledger row or feature-index line is created for it, and nothing is
  written to `planning/deferred.md` (a tracker is bound).
- [ ] No tracker product name is written into any SSOT file except as the binding already names it.
- [ ] "Files I read" contains nothing under the skill repo's `tests/` directory. If it does, the
  run is void (README rule 5): re-run with a fresh agent, do not grade it.

## Grading

Grade on where the finding went, not on the prose of the issue body.

**Most likely to fail:** the In scope reading. The first run of this scenario (2026-10-23) never
reached the filing rule: the agent cited "an improvement to a feature this batch already built is in
scope by definition" (item 3 built the digest scheduler), opened no intake, and inserted item 5 with a
renumber of items 5 to 9. The non-goal precedence sentence at the top of § Mid-flight inputs exists
because of that run. **Second:** the sibling stub. An agent trained on earlier releases of this skill, or
one that reads "out of scope" as "write it down beside the batch", creates `<M>-<slug>/README.md`
and takes a number. The second cheapest tell is a filing command written from habit for a tracker
the binding does not name.

## Exercises

`references/resume.md` § Mid-flight inputs, `templates/deferred-issue.md`, `agent/adapters.md`
§ Issue tracker, `templates/00-plan.md` § Deferred, `templates/00-acceptance.md` verdicts.
