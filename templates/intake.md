# Intake — <effort>

Written at `phase: intake`, before any exploration. Copy to `planning/00-intake.md` and replace the bracketed text.

## Rant (verbatim)

<The developer's own words, pasted unedited: the problem, the ideas they already have, the
constraints they already know. Do not summarise, reorder or correct it here. This section is the
evidence that later sections are read against, so it stays raw even when it contradicts itself.>

## Goals

- <What shipping this effort means, one outcome per bullet, in observable terms.>
- <Explicit non-goals, when the rant names something that is out of scope.>

## Constraints

- <Deadline, platform, schema, auth, third-party, budget, or project-rule constraint, with where it comes from.>

## Unknowns and premises to verify

| # | Premise or unknown | How it gets settled | Status |
|---|---|---|---|
| 1 | <what the effort assumes is true> | <query / file read / vendor docs / ask the developer> | open \| settled: <evidence> |

Every premise here is Phase 1 work. A premise still `open` when the interview starts is an interview question, never an assumption the cards get built on.

## Surfaces touched (web / iOS / Android / backend)

| Surface | In this effort? | Notes |
|---|---|---|
| web | yes \| no | <screens, routes> |
| iOS | yes \| no | <screens, native work> |
| Android | yes \| no | <screens, native work> |
| backend | yes \| no | <schema, endpoints, jobs> |

The adapter round of the interview turns this table into the surface coverage decision: each `yes` needs a role and tool that can verify it.

## Origin

- Requested in: <chat session / issue / conversation date>
- Deferred stub: <`<M>-<slug>/README.md` path, when this effort was deferred from an earlier batch, else "none">
- Originating batch: <link to that batch's `00-plan.md`, else "none">
