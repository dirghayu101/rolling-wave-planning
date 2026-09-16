# Mentor Documentation System

## TL;DR

This bundle turns the large mentor prompt into a small command plus two composable skills. `senior-mentor` controls how the agent teaches, challenges assumptions, and verifies work. `human-engineering-docs` writes long plans and post-task explanations as a numbered, multi-file docset for a human reader.

The central rule is separation: agent-facing plans remain optimized for execution, while your explanations live in `docs/<task-slug>/`. Every generated Markdown file has a TL;DR and a soft target of about 100 physical lines. Depth comes from more focused files, not larger files.

Corrected 2026-09-16: the docset directory was `human/` and the line limit was a hard cap. The rolling-wave-planning v2 layout renamed the directory to `docs/` and made line limits soft targets on human-facing files.

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

This bundle ships inside the `rolling-wave-planning` repository at `skills/mentor-documentation-system/`. Nested skills are not discovered on their own, so each one is reached through a symlink in the shared skills directory. With those links in place, `human-engineering-docs` and `senior-mentor` are invocable by name as ordinary skills (verified 2026-09-16 in the harness skill list):

```text
~/.agents/skills/mentor-documentation-system -> rolling-wave-planning/skills/mentor-documentation-system
~/.agents/skills/human-engineering-docs      -> .../mentor-documentation-system/skills/human-engineering-docs
~/.agents/skills/senior-mentor               -> .../mentor-documentation-system/skills/senior-mentor
```

Corrected 2026-09-16: this section previously told you to `cp -R` the two skill directories into `~/.agents/skills/`. Copies drift away from the repository, so symlinks into the repository replace them.

On a fresh machine, create the same links from a clone:

```bash
ln -s "$PWD/skills/senior-mentor" ~/.agents/skills/
ln -s "$PWD/skills/human-engineering-docs" ~/.agents/skills/
```

Copy the commands into Claude Code:

```bash
mkdir -p ~/.claude/commands
cp commands/*.md ~/.claude/commands/
```

The `/mentor-*` commands on this machine already live as separate files in the account's own commands directory; the copies here are the source of record for a new setup, not the live files.

If Claude Code uses a different skill directory in your setup, symlink the two skill folders there as well.

## Use

```text
/mentor-deep
/mentor-docs post-task checkout refactor
/mentor-docs planning four notification features
```

The mentor creates chat explanations for normal tasks. It invokes the companion documentation skill when the work spans several concerns, layers, features, bugs, or files, or when a concise chat explanation would lose important context.

## Generated layout

```text
docs/<task-slug>/
  000-index.md
  010-context.md
  020-architecture.md
  030-feature-or-bug.md
  040-verification.md
  050-debugging-map.md
  060-limitations.md
```

The exact files are chosen from the work. The numbering advances by ten so later sections can be inserted without renaming everything.

Inside a rolling-wave-planning batch the chapters live in the batch's own `docs/` directory and each chapter covers one feature, named `NNN-<slug>.md` by reading order.

## Validation

Run the bundled validator against a generated docset:

From a clone of the repository:

```bash
python3 skills/human-engineering-docs/scripts/validate_docset.py docs/<task-slug>
```

The global path `~/.agents/skills/human-engineering-docs/scripts/validate_docset.py` resolves to the same file through the symlink above (verified 2026-09-16).

It errors on a missing `000-index.md`, a missing title or TL;DR, and broken local links. It warns on files past the 100-line soft target, on overlong paragraphs, and on common agent-facing language that does not belong in human documentation.

Corrected 2026-09-16: the argument read `human/<task-slug>` and the only path given was the global one, which assumed the skill had been copied into `~/.agents/skills/`; both forms are shown above now that the bundle lives in a repository. An over-length file is a warning here, no longer a failure.

## Design notes

This structure follows the Agent Skills progressive-disclosure model: concise metadata is always available, the main skill instructions load on activation, and branch-specific references or scripts load only when needed. The bundle intentionally does not copy the contents of your installed skills. It composes with them by assigning clear ownership between planning, debugging, verification, domain expertise, and human-facing writing.
