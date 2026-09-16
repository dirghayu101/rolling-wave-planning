# <Number> — Debugging map

## TL;DR

<Explain where a maintainer should begin, which boundary is most likely to separate symptoms, and which evidence confirms each stage.>

## Reproduce the behavior

<Give the smallest reliable reproduction in short numbered steps. Do not include agent-only setup noise.>

## Execution checkpoints

### 1. <Entry point>

`<path>:<verified-lines>` — `<symbol>`

<Expected state and a useful breakpoint, logpoint, or watch expression.>

### 2. <Boundary>

`<path>:<verified-lines>` — `<symbol>`

<Expected request, response, event, database state, or trace evidence.>

### 3. <Result>

`<path>:<verified-lines>` — `<symbol>`

<Expected visible or persisted outcome.>

## Common failure signatures

<Use a short list mapping symptom to likely layer and next check.>

## Tools

<Explain one or two relevant IDE, CLI, observability, OS, network, or database tools and their limitations.>

## Known blind spots

<State what cannot currently be observed or reproduced reliably.>

## Navigation

[Back to index](000-index.md) | <Related implementation chapter>
