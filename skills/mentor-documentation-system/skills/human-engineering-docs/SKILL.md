---
name: human-engineering-docs
description: Creates and maintains multi-file, human-readable technical documentation for large implementation plans, completed features, bug batches, migrations, architecture changes, and post-task explanations. Use when the user asks what changed, wants a durable technical write-up, requests a human directory, TLDRs, code references, debugging guidance, or documents split into short files of about 100 lines. Keeps agent plans separate from reader-facing docs.
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
4. Create or update `docs/<task-slug>/000-index.md`.
5. Add only the focused numbered files the reader needs.
6. Reference exact files, symbols, tests, commands, and verified line ranges.
7. Run `scripts/validate_docset.py docs/<task-slug>`.
8. Report the index path, evidence anchor, verification state, and unresolved gaps.

Inside a rolling-wave-planning batch the docset root is the batch directory's own `docs/`, and one chapter covers one feature: `docs/NNN-<slug>.md`, where `NNN` is the next free three-digit reading-order prefix. Outside a batch, keep the `docs/<task-slug>/` form.

Corrected 2026-09-16: steps 4 and 7 previously read `human/<task-slug>`; the docset root is now `docs/`, because the rolling-wave-planning v2 layout renamed `human/` to `docs/` and this skill writes into that layout. Docsets already sitting under `human/` are correct for their own layout and do not need moving.

Read [docset-architecture.md](references/docset-architecture.md) for every docset.

Read [planning-mode.md](references/planning-mode.md) for proposed work.

Read [post-task-mode.md](references/post-task-mode.md) for completed work.

Read [style-and-evidence.md](references/style-and-evidence.md) before drafting or revising prose.

Read [code-references.md](references/code-references.md) when citing source, tests, config, logs, or commands.

Read [skill-composition.md](references/skill-composition.md) when using other installed skills as evidence sources.

## Output contract

- Every Markdown file targets about 100 physical lines, including blank lines and code fences. The limit is a soft target, not a hard cap.
- Aim for 60 to 90 lines so later edits have room.
- When a file runs past the target, split it at the next conceptual boundary. Never compress away reasoning, and never treat the target as a reason to write a thinner explanation.
- Every file begins with one H1 and contains `## TL;DR` near the top.
- `000-index.md` contains the comprehensive abstract, status, reading paths, and linked file map.
- Use three-digit numeric prefixes in increments of ten: `000`, `010`, `020`.
- One file answers one main reader question or explains one coherent subsystem, feature, bug, decision, or failure path.
- Split at a conceptual boundary before a file exceeds the target.
- There is no artificial limit on the number of files.
- Write in paragraphs with useful headings. Use bullets only when they genuinely improve scanning.
- Write to the user, never as instructions to another agent.
- Do not invent verification, line numbers, root causes, or architectural intent.

Corrected 2026-09-16: this section was titled "Hard output contract" and set a hard 100-line cap. Line limits are now soft targets on human-facing files, and `validate_docset.py` reports an over-length file as a warning rather than an error.

## Docs-writer contract

A chapter is often written by a separate docs-writer run rather than by the agent that built the feature, on the feature branch before the merge. That writer may be an external CLI that cannot see this conversation, so the handoff packet has to be self-contained. The packet template lives at `templates/doc-handoff.md` in the `rolling-wave-planning` skill directory (the directory of that name in the same skills folder; the repo root when reading inside the repo).

Inputs the packet carries:

- the feature boundary: every file the feature added or changed, with paths;
- the item card path (`rollout/<n>-<item>/0-card.md`) and the feature file path;
- the terms the chapter has to define for the reader;
- the path to this skill's conventions, so the writer loads them itself rather than being told about them second hand.

Outputs the writer returns:

- one chapter at `docs/NNN-<slug>.md`, using the next free three-digit reading-order prefix;
- an updated `docs/000-index.md` with the new chapter in the file map and in the reading paths.

A packet that assumes conversation context is a defect. Write it so a cold reader with repository access alone can produce the chapter.

## Source of truth

Code, tests, configuration, schemas, logs, and verified runtime behavior remain the source of truth. The docset is an orientation and reasoning layer, not a substitute for them.
