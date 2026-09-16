# Docs-writer handoff

One reader chapter per feature, written **on the feature branch before it merges**, so the PR carries its own chapter.

**How to use this file.** Fill the placeholders, save the filled copy into the batch's `working/` directory, then read the Docs writer section of `02-adapters.md`:

- Row reads a command: pipe the filled prompt to it. `cat working/<item>.<feature>.doc-prompt.md | <docs-writer-command>`
- Row reads `subagent`: dispatch a `heavy`-tier subagent with the same filled prompt as its entire packet. This is a normal binding, not a fallback failure.

Either way the writer sees only what is below the line. It has no access to this conversation, to the batch's other files, or to anything you did not name. Fill every placeholder before sending.

Pick the target number first: list `docs/`, take the highest `NNN-` prefix, add one. Those numbers are **reading order**, not item numbers, and they never shift.

---

Write one technical documentation chapter for a feature that has just been built. You are writing for the developer who owns this codebase and will read this chapter weeks from now, not for an agent.

**Read these first, in this order:**

1. Conventions, and follow them exactly: `<conventions-path>` (default on this machine: `~/.agents/skills/human-engineering-docs/SKILL.md`). This file governs file length, the index, the TL;DR block, evidence labels, and voice. Where it disagrees with anything below, it wins.
2. The item card, for the problem and the acceptance criteria: `<batch-dir>/rollout/<n>-<item>/0-card.md`
3. The feature file, for what and why, the test strategy, and the confidence score: `<batch-dir>/rollout/<n>-<item>/<f>-<feature>.md`

**The feature boundary. These are the changed files, and they are the whole subject of the chapter:**

- `<path>`
- `<path>`
- `<path>`

Read every one. Do not document code outside this list; if something outside is needed to make the chapter make sense, name it in one sentence and link to it rather than explaining it.

**Terms that must be defined where they first appear:**

- `<term>`: `<one-line orientation, or "define it from the code">`
- `<term>`: `<one-line orientation, or "define it from the code">`

**Write to:** `<batch-dir>/docs/<NNN>-<slug>.md`

**Output contract:**

- One file at that exact path. Do not create an extra file, and do not rename an existing one.
- Open with `## TL;DR`: what this feature does and why it exists, in a few lines someone can read without the rest.
- Every claim about behavior carries a code reference (`path:line` or `path` plus the symbol name). A claim you cannot ground in the boundary files does not go in.
- Cover, in whatever order reads best: what changed and why, how the pieces fit, the decisions that were made and what was rejected, the failure paths, and how to verify or debug it by hand.
- Prefer a small diagram over prose whenever a flow or a matrix would otherwise be re-explained twice.
- Past the conventions file's length target, split into two numbered self-contained chapters rather than stretching one. Take the next number for the second.
- Also append one row for this chapter to `<batch-dir>/docs/000-index.md`, in reading order.
- No em dashes.

**Stop conditions.** Stop and report `BLOCKED: <what, where, what would unblock it>` rather than guessing when: a listed path does not exist, the conventions file cannot be read, the feature file's claims contradict the code you read, or the boundary list is missing a file the changed behavior clearly depends on.

**Return:** the path written, the chapter's line count, the index row added, and any uncertainties.
