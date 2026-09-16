# Skill composition

## TL;DR

Other skills supply planning, debugging, verification, writing, and domain expertise. This skill owns the final human-readable docset, its audience separation, file boundaries, evidence labels, and soft 100-line target.

## Composition map

Use installed skills when relevant:

- `rolling-wave-planning`: source of the machine-oriented plan, the batch ledger in `00-plan.md`, and the item cards at `rollout/<n>-<item>/0-card.md`. Its batch directory owns the `docs/` chapters this skill writes, one per feature, produced on the feature branch before the merge. Do not copy its agent execution voice.
- `spec-development`: source of requirements, constraints, acceptance criteria, and architectural decisions.
- `systematic-debugging`: source of symptom, evidence, hypotheses, root cause, and regression checks.
- `bug-batch-fixing`: source of bug grouping, scope, and implementation evidence.
- `human-assisted-verification`: source of the L5 human-only checks and the gaps they leave. Layers L1 to L4 are the agent-observable evidence recorded before handover, so a chapter cites that evidence separately from what a human still has to confirm.
- `documentation-writer`: use its Diátaxis distinction to decide whether a chapter is explanation, how-to, reference, or tutorial.
- `human-writing`: run as a final prose review without weakening technical precision or evidence labels.
- `writing-for-agents`: apply only to agent-facing plans, skills, and instruction files. It must not make `docs/` read like an agent prompt.
- `grilling` or `grill-with-docs`: source of challenged assumptions, glossary terms, and ADRs. Link to durable ADRs rather than duplicating them.
- domain skills: source framework-specific behavior, risks, and verification steps.

## Conflict resolution

Repository evidence and authoritative documentation outrank a generic skill rule. If sources conflict, state the disagreement and avoid merging them into a false conclusion.

## Context discipline

Load only the skills needed for the current branch. A long list of installed skills is not a reason to invoke all of them. Clear ownership and less context produce more consistent docs.

Corrected 2026-09-16: the `rolling-wave-planning` and `human-assisted-verification` entries described the v1 shape (cards at `cards/<item>.md`, a single manual-verification pass with agent steps in it), and the reader-facing directory was called `human/`. Both entries now describe v2: cards under `rollout/`, docs under `docs/`, and a five-layer ladder whose L5 is human-only.
