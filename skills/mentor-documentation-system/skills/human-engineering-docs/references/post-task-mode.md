# Post-task mode

## TL;DR

Reconstruct the completed task from evidence, then explain the system before and after the change. The docset should help the user understand the implementation and know where to debug it later.

## Establish the task boundary

Use the current session, plan, issue, diff, commits, and changed files. If the boundary remains uncertain, document the strongest evidence-backed scope and state the ambiguity in the index.

Record the revision with a commit SHA when available. If the working tree is uncommitted, say so and use the inspected diff as the evidence window.

## Required questions

Across the docset, answer the relevant questions:

- What problem or limitation existed?
- What behavior changed from before to after?
- Where does the change sit in the architecture?
- How does data and control flow through it?
- Which files and symbols implement each responsibility?
- Which boundaries, contracts, side effects, and invariants matter?
- What was verified, and what does each check prove?
- What failure paths remain?
- Where should the user place breakpoints, inspect logs, or start debugging?
- What limitation, trade-off, or future enhancement remains?

## Bug documentation

Separate symptom, expected behavior, evidence, confirmed root cause, fix mechanism, and regression protection. If the cause was not proven, call it a hypothesis rather than rewriting history.

For a bug batch, use one chapter per coherent root cause or subsystem. Do not make one giant “bugs fixed” file.

## Feature documentation

Trace intent to visible result. Show state changes, network calls, server handling, persistence, events, cache updates, and rerenders when those layers exist.

## Verification

List commands and tests with their actual outcomes. Explain what passed checks do and do not establish. Mark manual checks, unavailable environments, skipped tests, and production-only assumptions.

## Maintenance

Update only impacted chapters and the index. Avoid regenerating the whole docset in a new voice. Preserve valid explanations and stable filenames.
