---
name: human-engineering-docs
description: Creates and maintains multi-file, human-readable technical documentation for large implementation plans, completed features, bug batches, migrations, architecture changes, and post-task explanations. Use when the user asks what changed, wants a durable technical write-up, requests a human directory, TLDRs, code references, debugging guidance, or documents split into files of at most 100 lines. Keeps agent plans separate from reader-facing docs.
compatibility: Designed for Agent Skills-compatible coding agents with repository and shell access; Python 3 is recommended for validation.
metadata:
  version: "1.0"
---

# Human Engineering Docs

Create durable documentation for a technical human reader. Preserve depth by splitting along conceptual boundaries, never by compressing away necessary reasoning.

## Workflow

1. Determine **planning** or **post-task** mode from the request and repository state.
2. Gather evidence from plans, diffs, code, tests, logs, configuration, decisions, and verification output.
3. Keep machine-oriented plans and scratch artifacts separate from the human docset.
4. Create or update `human/<task-slug>/000-index.md`.
5. Add only the focused numbered files the reader needs.
6. Reference exact files, symbols, tests, commands, and verified line ranges.
7. Run `scripts/validate_docset.py human/<task-slug>`.
8. Report the index path, evidence anchor, verification state, and unresolved gaps.

Read [docset-architecture.md](references/docset-architecture.md) for every docset.

Read [planning-mode.md](references/planning-mode.md) for proposed work.

Read [post-task-mode.md](references/post-task-mode.md) for completed work.

Read [style-and-evidence.md](references/style-and-evidence.md) before drafting or revising prose.

Read [code-references.md](references/code-references.md) when citing source, tests, config, logs, or commands.

Read [skill-composition.md](references/skill-composition.md) when using other installed skills as evidence sources.

## Hard output contract

- Every Markdown file is at most 100 physical lines, including blank lines and code fences.
- Target 60 to 90 lines so later edits have room.
- Every file begins with one H1 and contains `## TL;DR` near the top.
- `000-index.md` contains the comprehensive abstract, status, reading paths, and linked file map.
- Use three-digit numeric prefixes in increments of ten: `000`, `010`, `020`.
- One file answers one main reader question or explains one coherent subsystem, feature, bug, decision, or failure path.
- Split at a conceptual boundary before a file exceeds the cap.
- There is no artificial limit on the number of files.
- Write in paragraphs with useful headings. Use bullets only when they genuinely improve scanning.
- Write to the user, never as instructions to another agent.
- Do not invent verification, line numbers, root causes, or architectural intent.

## Source of truth

Code, tests, configuration, schemas, logs, and verified runtime behavior remain the source of truth. The docset is an orientation and reasoning layer, not a substitute for them.
