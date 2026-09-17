# Per-Feature File: Template

Template for `rolling-wave-planning`. The feature file is the developer's skim surface: they read
scores, not diffs, and dive where the number is low.

Lives at `rollout/<n>-<item>/<f>-<feature-slug>.md`. **Soft target ~100 lines**: solution
detail belongs in `working/<item>.agent.md`. **Created when the feature starts** (sections 1 to 3
planned) and **updated at every stage transition**: the evidence log gains a row and both
confidence numbers are re-derived each time a layer is climbed or a review point closes, per
`references/verification.md`.

## Template: copy verbatim, replacing bracketed text

```markdown
# Feature <n>: <Title>

Item: `rollout/<i>-<item-slug>/0-card.md` · Stage: **pending | in-progress | reviewed | agent-verified | documented | merged**

## What & why

<Soft target 3–5 lines; legibility beats brevity. What behavior this delivers and why it is
a separate feature from its siblings. Use precise technical terms: never compress into
vague abstraction to hit a line count.>

## Links

- PR: <url, or "not yet opened">
- Item tracking issue: <url>
- Doc chapter: `docs/<NNN>-<slug>.md` <or "not yet written">
- Key files: `<path>`, `<path>`

## Test strategy

Planned <YYYY-MM-DD>, updated at close <YYYY-MM-DD>.

| Layer | Planned | Actually ran |
|---|---|---|
| L1 unit (one test per exit point) | <exit points to cover: return values, state changes, third-party calls> | <what exists, file paths> |
| L2 integration (seams) | <which seams: DB, edge function, auth boundary> | <what exists> |
| L3 real-surface (adapter bound in `02-adapters.md`) | <flows to drive, breakpoints, console/network assertions> | <what was driven, evidence> |
| L4 cross-feature (item level) | <see the card's `L4 flow:` line; note here what this feature contributes to it> | <what was run, evidence> |
| L5 human-only | <`verification/<n>.<f>-<slug>.md` rows this feature owns> | <verdicts: PASS / FAIL / NEEDS-HUMAN> |

Sensitive surfaces: <none | RLS | auth | payments | secrets (flagged features get the security pass, `references/review.md`)>

## Evidence log

| date | layer | evidence | by |
|---|---|---|---|
| <YYYY-MM-DD> | <L1–L5> | <re-openable pointer: test path, CI run, `assets/<file>`, query + result, verification row id> | <role · tier> |

## Confidence: agent <0-100> · ceiling <0-100> (<date>)

<2–4 lines justifying both numbers against the rubric in `references/verification.md`. Name the
weakest dimension, and say what the gap between agent and ceiling is parked on.>

## What would raise this

- <verification that would have given more assurance but needs a human or tooling that does not exist>
- <...>
```

Rubric, the two evaluations, the re-derivation rule and the "exhaust agent-actionable raises first"
rule all live in `references/verification.md`.
