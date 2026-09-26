# Per-feature file: template

Template for `rolling-wave-planning`. Two files per feature, and they are not the same kind of file.

- `agent/<n>-<item>/<f>-<slug>.md` is **HEAD**: rewritten in place, current by construction, 150 lines or fewer.
- `agent/<n>-<item>/<f>-<slug>.log.md` is **LOG**: append-only, every entry carrying the SHA it was true at, never edited.

Neither is reviewable material. Nothing in either file is a review finding.

## HEAD: copy verbatim, replacing bracketed text

```markdown
# Feature <n>.<f>: <Title>

Item: `0-card.md` · Stage: **open | built | reviewed | merged**
Flow: `../../flows/<n>.<f>-<slug>.md` · Log: `<f>-<slug>.log.md`

## What and why

<Three to five lines. What behavior this delivers and why it is a separate feature from its
siblings. Precise technical terms; never compress into vague abstraction to hit a line count.>

## Links

- PR: <url, or "not yet opened">
- Item tracking issue: <url>
- Key files: `<path>`, `<path>`
- Verification: `../../verification/<n>.<f>-<slug>.md` <or the group file `../../verification/group-<slug>.md`, or "none owed: <the substitute recorded in the card>">
- Runbook: `../../runbooks/<k>-<slug>.md` <or "none">

## Test strategy

| Layer | Planned | Actually ran |
|---|---|---|
| L1 unit (one test per exit point) | <exit points to cover> | <what exists, file paths> |
| L2 integration (seams) | <which seams> | <what exists> |
| L3 real surface | <flows to drive, breakpoints, geometry and focus reads, console and network assertions> | <what was driven, evidence entry> |
| L4 cross-feature | <what this feature contributes to the card's L4 flow> | <what was run> |
| L5 human-only | <the verification file's rows> | <open, until the row is ticked> |

Sensitive surfaces: <none | RLS | auth | payments | secrets>

Confidence: agent <0-100> / ceiling <0-100>

## What would raise this

- <a raise that needs a human or tooling that does not exist yet>
```

**Confidence is one line.** No paragraph, no re-derivation, no history of the number. Overwrite it when it changes.

**"What would raise this" holds only raises an agent cannot execute.** Anything an agent can run is done, not listed.

## LOG: create it empty at the feature `open` gate

```markdown
# Log: feature <n>.<f> <slug>

Append-only. Every entry carries the SHA it was true at. Nothing here is ever edited, re-pinned
or corrected: a fact that stopped being true gets a new entry below, and the old one stands.

## Dispatch

| Date | SHA | Packet | Tier | Roles → skills | Outcome |
|---|---|---|---|---|---|

## Evidence

| Date | SHA | Layer | Evidence | By |
|---|---|---|---|---|

## Review

| Date | SHA | Pass | Raised | Fixed | Skipped with reason |
|---|---|---|---|---|---|

## Ephemera

| What | Where | Teardown | Swept on |
|---|---|---|---|
```

`Swept on` is the one cell in a LOG file written twice, and only from empty to a date or `kept: <reason>`.
