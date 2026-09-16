# Output evaluation checklist

## TL;DR

Use this checklist to review a generated docset without relying only on whether the prose sounds polished.

## Structure

- `000-index.md` exists and links to every active chapter.
- Every Markdown file is 100 lines or fewer.
- Numbering is stable, three digits, and normally advances by ten.
- Each chapter answers one main reader question.
- The depth was preserved by splitting rather than compressing away important reasoning.

## Audience

- The prose addresses a technical human reader.
- No chapter reads like a prompt, task ledger, or handoff to another agent.
- Paragraphs and headings dominate; bullets are used only for genuine lists.
- The TL;DR of each chapter is locally useful rather than copied boilerplate.
- Jargon is defined when it first matters.

## Technical grounding

- Behavioral and architectural claims point to source, tests, config, logs, or command output.
- References include paths and symbols; verified line ranges are not guessed.
- Planned code is clearly labeled proposed.
- Facts, assumptions, hypotheses, and verification status are not blurred together.
- Root causes are called confirmed only when evidence supports them.

## Engineering usefulness

- The reader can trace the main execution and data paths.
- Important boundaries, side effects, invariants, and failure paths are explained.
- Verification says what each check proves and does not prove.
- A maintainer knows where to begin debugging.
- Limitations and future triggers are honest rather than promotional.

## Maintenance

- Existing valid chapters were updated rather than rewritten unnecessarily.
- Superseded material links to its replacement.
- No secrets, personal data, huge diffs, or raw log dumps were copied into the docset.
