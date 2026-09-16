# Skill composition

## TL;DR

Other skills supply planning, debugging, verification, writing, and domain expertise. This skill owns the final human-readable docset, its audience separation, file boundaries, evidence labels, and 100-line limit.

## Composition map

Use installed skills when relevant:

- `rolling-wave-planning`: source of the machine-oriented plan and wave status. Do not copy its agent execution voice.
- `spec-development`: source of requirements, constraints, acceptance criteria, and architectural decisions.
- `systematic-debugging`: source of symptom, evidence, hypotheses, root cause, and regression checks.
- `bug-batch-fixing`: source of bug grouping, scope, and implementation evidence.
- `human-assisted-verification`: source of manual verification and gaps.
- `documentation-writer`: use its Diátaxis distinction to decide whether a chapter is explanation, how-to, reference, or tutorial.
- `human-writing`: run as a final prose review without weakening technical precision or evidence labels.
- `writing-for-agents`: apply only to agent-facing plans, skills, and instruction files. It must not make `human/` read like an agent prompt.
- `grilling` or `grill-with-docs`: source of challenged assumptions, glossary terms, and ADRs. Link to durable ADRs rather than duplicating them.
- domain skills: source framework-specific behavior, risks, and verification steps.

## Conflict resolution

Repository evidence and authoritative documentation outrank a generic skill rule. If sources conflict, state the disagreement and avoid merging them into a false conclusion.

## Context discipline

Load only the skills needed for the current branch. A long list of installed skills is not a reason to invoke all of them. Clear ownership and less context produce more consistent docs.
