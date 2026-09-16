# <M>-<slug> (deferred stub)

A sibling directory next to the batch dirs, holding work that was discovered during batch `<N>` and pushed out of it. The stub occupies slot `<M>` so the sibling scan never hands that number to another batch. Copy this file to `<M>-<slug>/README.md` and replace the bracketed text.

<One paragraph: what this work is, in the same observable terms an item card's Problem section
uses. Enough that someone who was not in the session knows what would be built or fixed.>

## Why it is out of scope for batch `<N>`

<The actual reason, not "no time": a dependency that does not exist yet, a decision the developer
has not made, a surface with no verification tool, a scope cut taken on a date with its trade-off.>

## Context to pick it up cold

- **Files:** `<path>`, <what it owns and why this work touches it>
- **Evidence:** <log line, query result, reproduction steps, screenshot copied into this directory; dated>
- **Related decisions:** <decision row number and its choice, from batch `<N>`'s `00-plan.md`>
- **Premises still open:** <what would have to be verified first>

Copy the evidence in rather than linking to a session or a scratchpad. Those die; this directory does not.

## Origin

- Deferred: <YYYY-MM-DD>
- From batch: [`<N>-<slug>/00-plan.md`](../<N>-<slug>/00-plan.md)

## Picking this up

Invoke `pre-rolling-wave-planning`; this README is the intake seed. Its description, context and related decisions go straight into `planning/00-intake.md`, and the developer adds whatever has changed since.
