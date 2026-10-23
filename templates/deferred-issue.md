# Out-of-scope finding: issue body

The body of an issue filed in the bound tracker (`agent/adapters.md` § Issue tracker) for work
discovered during batch `<N>` and routed out of it. Write it to a body file under the scratch root,
file it with the binding's `File:` line, and title it in the binding's `Title form:`. With the
tracker bound to `none`, the same text, under a `## <slug>` heading, is appended to
`planning/deferred.md`. Never a file or directory beside the batch. **The body starts after the rule
below; nothing above the rule is sent.**

---

<One paragraph: what this work is, in the same observable terms an item card's Problem section
uses. Enough that someone who was not in the session knows what would be built or fixed.>

## Why it is out of scope for batch `<N>`

<The actual reason, not "no time": a dependency that does not exist yet, a decision the developer
has not made, a surface with no verification tool, a non-goal the intake names, a scope cut taken
on a date with its trade-off.>

## Context to pick it up cold

- **Files:** `<path>`, <what it owns and why this work touches it>
- **Evidence:** <log line, query result, reproduction steps, pasted in; dated>
- **Related decisions:** <decision row number and its choice, from batch `<N>`'s `00-plan.md`>
- **Premises still open:** <what would have to be verified first>

Copy the evidence into the body rather than linking to a session or a scratchpad. Those die; the
issue does not.

## Origin

- Found: <YYYY-MM-DD>, batch `<N>-<slug>`, item `<n>` open, at `<short SHA of the batch branch>`
- Batch entry file: `<path to <N>-<slug>/00-plan.md>`

## Picking this up

Invoke `pre-rolling-wave-planning`; this issue is the intake seed. Its body goes straight into
`planning/00-intake.md`, every requirement it records becomes a row in `planning/00-acceptance.md`,
and the developer adds whatever has changed since.
