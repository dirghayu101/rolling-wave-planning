# Code and evidence references

## TL;DR

Anchor technical claims to exact repository evidence. Use both a path and a stable symbol because line numbers drift. Record the inspected revision so a reader can recover the original location.

## Source format

For implemented code, prefer:

```text
`src/orders/submit.ts:42-78` — `submitOrder()`
```

Add the current commit SHA or state that the reference points to an uncommitted working tree. Verify line ranges immediately before writing; never estimate them.

For planned code, use:

```text
**Proposed:** `src/orders/idempotency.ts` — `reserveIdempotencyKey()`
```

Do not provide fake line numbers for proposed files or symbols.

## Tests and commands

Reference tests by file and test name:

```text
`src/orders/__tests__/submit.test.ts` — “does not duplicate a retried order”
```

For commands, include the exact command, result, and interpretation. A command without its outcome is not verification.

## Logs and external systems

Identify the environment, time window, request or trace identifier, release, and relevant field when available. Do not copy secrets, tokens, personal data, or huge log dumps into human docs.

## Drift and stability

Prefer symbol names, route names, schema objects, test names, and configuration keys alongside line ranges. For durable links in hosted repositories, use revision-pinned URLs when the environment makes them available.

If a referenced file moved, update the active chapter and note the old path only when it helps migration or debugging.

## Diagrams

Use a small Mermaid diagram when it clarifies a multi-step execution path better than prose. Keep it under roughly 25 lines and place a large diagram in its own numbered chapter.

## Evidence density

A substantial section should point to the evidence that supports it. Do not attach a citation to every ordinary sentence, but ensure a reader can trace each architectural, behavioral, and verification claim to code or output.
