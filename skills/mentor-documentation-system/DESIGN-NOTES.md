# Design notes

## TL;DR

The old mentor command carried every rule in one always-read file. This version separates activation, teaching, critique, tool discovery, and durable documentation so the agent loads only the branch it needs. The same principle is applied to the human output: depth is preserved across many short chapters instead of one oversized document.

## Two audiences, two artifacts

Agent plans and human explanations have different jobs. An agent plan optimizes execution, state tracking, delegation, and next actions. A human explanation optimizes orientation, causal understanding, debugging, and later recall.

Mixing them produces prose that sounds like an agent talking to another agent. The bundle therefore keeps existing plans where they are and writes reader-facing material into `human/<task-slug>/`.

## Why two skills

`senior-mentor` owns behavior during engineering work: mental models, evidence, verification, technical teaching, tool tips, and devil's advocacy.

`human-engineering-docs` owns a durable output contract: chapter boundaries, TL;DR sections, human voice, evidence references, code maps, navigation, and the 100-line cap.

This avoids giving one skill two unrelated responsibilities and lets the documentation skill trigger independently for planning or post-task requests.

## Progressive disclosure

Both `SKILL.md` files are small routers. Branch-specific rules live one level down in `references/`, while deterministic checks live in `scripts/`. This mirrors the Agent Skills loading model and reduces context use during tasks that do not need every rule.

Every file in this bundle is itself under 100 lines. That is stricter than the public Agent Skills recommendation, but it makes the skill easier to inspect and edit in the same way the generated docs are meant to be read.

## Why 100 physical lines

A physical-line cap is measurable and enforceable. The validator counts blank lines and code fences so an agent cannot hide a huge chapter behind dense formatting.

The target is 60 to 90 lines, not 100. The remaining space allows small future edits without immediately forcing a split.

## Why numbered files advance by ten

Names such as `000`, `010`, and `020` keep reading order obvious while leaving room to insert `015` later. This avoids renaming every chapter and breaking links when the explanation grows.

## Existing skill composition

The bundle references your installed skills by responsibility rather than copying them. Planning, debugging, verification, domain behavior, human prose cleanup, and agent-facing writing remain owned by the relevant specialized skill. The mentor and documentation skills combine their evidence into a coherent reader model.

Public versions of `documentation-writer`, `human-writing`, `writing-for-agents`, the Agent Skills specification, and Anthropic's skill-creator informed the structure. Their text was not copied wholesale; the bundle adapts the useful principles to your stated workflow.

## Important limitation

A line validator can enforce size and basic structure, but it cannot prove that an explanation is technically correct or genuinely understandable. The evidence rules, output checklist, trigger cases, and mentor review reduce that risk, but repository inspection and human review remain necessary.
