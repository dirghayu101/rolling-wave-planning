# Mentor Documentation System

## TL;DR

This bundle turns the large mentor prompt into a small command plus two composable skills. `senior-mentor` controls how the agent teaches, challenges assumptions, and verifies work. `human-engineering-docs` writes long plans and post-task explanations as a numbered, multi-file docset for a human reader.

The central rule is separation: agent-facing plans remain optimized for execution, while your explanations live in `human/<task-slug>/`. Every generated Markdown file has a TL;DR and a hard limit of 100 physical lines. Depth comes from more focused files, not larger files.

## Included

```text
commands/
  mentor-deep.md
  mentor-docs.md
skills/
  senior-mentor/
  human-engineering-docs/
```

Both skills use progressive disclosure. Their `SKILL.md` files contain routing and workflow rules; detailed branches live in focused reference files that are loaded only when relevant.

## Install

Copy the skill directories into your shared skills directory:

```bash
cp -R skills/senior-mentor ~/.agents/skills/
cp -R skills/human-engineering-docs ~/.agents/skills/
```

Copy the commands into Claude Code:

```bash
mkdir -p ~/.claude/commands
cp commands/*.md ~/.claude/commands/
```

If Claude Code uses a different skill directory in your setup, copy or symlink the two skill folders there as well.

## Use

```text
/mentor-deep
/mentor-docs post-task checkout refactor
/mentor-docs planning four notification features
```

The mentor creates chat explanations for normal tasks. It invokes the companion documentation skill when the work spans several concerns, layers, features, bugs, or files, or when a concise chat explanation would lose important context.

## Generated layout

```text
human/<task-slug>/
  000-index.md
  010-context.md
  020-architecture.md
  030-feature-or-bug.md
  040-verification.md
  050-debugging-map.md
  060-limitations.md
```

The exact files are chosen from the work. The numbering advances by ten so later sections can be inserted without renaming everything.

## Validation

Run the bundled validator against a generated docset:

```bash
python ~/.agents/skills/human-engineering-docs/scripts/validate_docset.py \
  human/<task-slug>
```

It checks the 100-line cap, required title and TL;DR, local links, overlong paragraphs, and common agent-facing language that does not belong in human documentation.

## Design notes

This structure follows the Agent Skills progressive-disclosure model: concise metadata is always available, the main skill instructions load on activation, and branch-specific references or scripts load only when needed. The bundle intentionally does not copy the contents of your installed skills. It composes with them by assigning clear ownership between planning, debugging, verification, domain expertise, and human-facing writing.
