---
description: Create or update a multi-file human-readable plan or post-task explanation
argument-hint: "[planning|post-task] [task or scope]"
---

Use the `human-engineering-docs` skill to document `$ARGUMENTS`.

If the mode is omitted, infer it from the current session:

- Use **post-task** when code or configuration has already been changed.
- Use **planning** when the work is proposed, not implemented.

Do not ask me to repeat context already available in the conversation, repository, plan, diff, tests, or logs.

Create or update a dedicated `docs/<task-slug>/` directory. Keep it separate from agent plans, scratch files, task ledgers, and rolling-wave execution artifacts.

Required behavior:

- Create `000-index.md` first.
- Use numbered files with increments of ten.
- Keep every Markdown file near the 100-physical-line soft target, splitting by concept when it runs long.
- Put a useful `## TL;DR` near the top of every file.
- Write in paragraphs with headings; avoid bullet walls and AI filler.
- Write to me as a technical human reader, not to another agent.
- Reference exact source files, symbols, tests, configuration, and verified line ranges.
- Label facts, assumptions, hypotheses, proposals, and unverified claims accurately.
- Include architecture, data flow, verification, failure paths, limitations, and debugging entry points when relevant.
- Prefer another focused file over compressing away necessary depth.

Run the bundled validator before reporting completion. State what was documented, what evidence was used, and what remains uncertain.

Corrected 2026-09-16: the directory read `human/<task-slug>/` and the line limit was a hard cap; v2 renamed the directory to `docs/` and made the limit a soft target.
