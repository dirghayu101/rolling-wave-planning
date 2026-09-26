# Feature runbook: template

Template for `rolling-wave-planning`. Lives at `runbooks/<k>-<slug>.md`, numbered in the order the
runbooks must run. Written at the feature's `reviewed → merged` gate and it rides that PR.

**This is stage two of two: verify on dev, then deploy through the runbooks.** This file is the
production stage, and the only place production appears. Production consoles, production credentials,
`*:prod` commands and migration pushes live here and never in `verification/`, which runs on dev and
needs no production access. The post-check below is the production-side verification of the same
flow.

**Write one only when the feature needs a production step**: a migration, a secret, a key cutover, a
config flip, a store submission. A feature with no production step gets no runbook.

**Every line here is run by hand, never by an agent**, not even a read-only command against
production.

## Template: copy verbatim, replacing bracketed text

````markdown
# Runbook <k>: <what this does, in plain words>

Feature: `agent/<n>-<item>/<f>-<slug>.md` · PR: <url> · Runs: <where this sits in `runbooks/0-release.md`>

## What it does

<Two or three plain sentences. What changes in production, for whom, and what stops working if it is
skipped. No jargon a cold reader has to decode.>

## Preflight

Checked before anything is applied. Stop on the first one that does not hold.

| # | Check | Expect |
|---|---|---|
| 1 | <the exact command or console path> | <the exact result> |
| 2 | <what must already be deployed or merged first> | <...> |

## Dry run

- Command: `<the exact dry-run command>`
- Expect: <what the dry run must print, and the one line that means stop>

## Apply

- Command: `<the exact command, exactly as it is run by hand>`
- Expect: <the success output>
- Takes: <rough duration, and whether it locks anything>

## Post-check

Read-only, run right after the apply. This is the evidence the change landed.

```sql
<the exact read-only SQL, or the exact CLI command>
```

Expect: <the exact rows or output>.

## Rollback

- When: <the symptom that means roll back rather than fix forward>
- How: `<the exact command, or "fix forward only: <why>" with the forward fix named>`
- Costs: <what is lost or left inconsistent by rolling back>

## Known consequences

- <What else changes as a side effect: generated types, a cache to bust, a client that must be
  reloaded, a job that reruns.>
- <What must be done next, and where it is written down.>
````

## Numbering

`<k>` is run order across the whole batch, and `0` is reserved for `runbooks/0-release.md`. Two
runbooks that must run in a fixed order never share a number. A runbook inserted late takes the next
free number and `runbooks/0-release.md` is rewritten to place it.

## Lifetime

Deleted after the push it describes, in the commit that records the push. A runbook still on disk
after its deploy is stale instructions.
