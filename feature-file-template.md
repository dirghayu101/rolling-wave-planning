# Per-Feature File — Template

Reference for `rolling-wave-planning`. The feature file is the developer's skim surface: they
read scores, not diffs, and dive where the number is low.

Lives at `rollout/<i>-<item-slug>/<f>-<feature-slug>.md`. **Hard cap 100 lines** — solution detail
belongs in `working/<item>.agent.md`. Created when the feature starts (sections 1–3 planned),
completed at feature close (section 3 updated, 4 and 5 filled).

## Template — copy verbatim, replacing bracketed text

```markdown
# Feature <n> — <Title>

Item: `rollout/<i>-<item-slug>/0-card.md` · Stage: **pending | in-progress | code-done**

## What & why

<Soft target 3–5 lines; legibility beats brevity. What behavior this delivers and why it is
a separate feature from its siblings. Use precise technical terms — never compress into
vague abstraction to hit a line count.>

## Links

- PR: <url, or "not yet opened">
- Item tracking issue: <url>
- Key files: `<path>`, `<path>`

## Test strategy

Planned <YYYY-MM-DD>, updated at close <YYYY-MM-DD>.

| Layer | Planned | Actually ran |
|---|---|---|
| Unit (one test per exit point) | <exit points to cover: return values, state changes, third-party calls> | <what exists, file paths> |
| Integration (seams) | <which seams: DB, edge function, auth boundary> | <what exists> |
| Real-surface (agent-browser) | <flows to drive, breakpoints, console/network assertions> | <what was driven, evidence> |
| Human-assisted | <`01-verification.md` rows this feature owns> | <verdicts: PASS / FAIL / NEEDS-HUMAN> |

Sensitive surfaces: <none | RLS | auth | payments | secrets — see the security pass in ceremony.md>

## Confidence: <0–100>

<2–4 lines justifying the number against the rubric. Name the weakest dimension.>

## What would raise this

- <testing setup or verification that would have given more assurance but was not built>
- <...>
```

## Scoring the confidence number

A **judgment against a rubric, with no prescriptive arithmetic.** A formula invites gaming and
micromanages the implementing agent. Weigh five dimensions:

1. **Unit coverage of exit points** — every exit point of every changed unit has a test, per the
   project's one-test-per-exit-point convention, or the gap is named.
2. **Integration seams exercised** — the boundaries this feature crosses are actually run, not
   mocked away on both sides.
3. **Real-surface verification** — `agent-browser` for any web surface (mandatory per the
   developer's standing browser rule); `human-assisted-verification` for mobile and
   fire-and-forget effects.
4. **Review findings raised vs resolved** — an unresolved finding on the PR lowers the score.
5. **Unverifiable effects honestly listed** — declaring "the FCM send is unobserved" raises trust;
   omitting it and being caught in review destroys it.

## "What would raise this" — exhaust agent-actionable raises first

Before the score is finalized, any would-raise entry an agent can execute with available tooling —
an `agent-browser` flow, an extra seam test, a machine assertion — is **done, not listed**. The
list is reserved for raises that genuinely need human intervention or infrastructure that does not
yet exist. An agent-actionable entry still sitting on the list at feature close is a red flag.

**Anti-gaming:** the item rogue-check spot-checks by re-deriving one or two scores from the diff. A
score that does not survive re-derivation is a rogue-check finding.
