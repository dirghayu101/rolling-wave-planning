# Scenario 3: Dispatch packet shape

## Fixture

`fixtures/12-notifications/` (same fixture as scenario 1). `phase: executing`. Item 4's card lists
feature 4.3 (`quota-upgrade-modal`) at stage `open`, and says in one line that its own `open` gate
has not been taken: no HEAD file, no `.log.md`, no before flow. It is a web-surface feature whose
modal state is already covered by the approved wireframe at
`planning/03-blueprint/quota-settings.html`. The batch's `agent/adapters.md` is present with the
tiers, the `web` surface bound to `agent-browser` with its geometry and focus reads, the Cleanup
section's scratch root, and the skill-roles table filled (including `flow-explorer` and a
stack-conditional `framework` row for `next`).

## Prompt

Give the fresh agent exactly this, filling `<FIXTURE>` with the absolute path of a fresh COPY of
`fixtures/12-notifications/`:

> You are working in an existing rolling-wave-planning batch at `<FIXTURE>`. Invoke the
> `rolling-wave-planning` skill. Your task is "Implement feature 4.3." You will **not** implement
> any code yourself. Instead, follow the batch's dispatch process to produce the exact handoff
> packet you would send to an implementer subagent for this feature, using
> `templates/handoff.agent.md` as the shape. Paste the fully filled packet in your answer, resolve
> every role against the batch's adapters file yourself (do not leave a placeholder), and do not
> dispatch or invoke any subagent. Also say, in one or two lines, what else the feature's `open`
> gate requires besides this packet. Do not open anything under the skill repo's `tests/`
> directory. End your answer with a list titled "Files I read" naming every file you opened, in
> the order you opened them.

## Pass criteria

- [ ] The packet type matches the feature's stage: 4.3 is `open`, so this is an implementer packet
  at the `heavy` tier carrying `simplicity`, `tdd`, `ui-implementation` and the stack-conditional
  `framework` role, with the wireframe path in scope. It does not carry `browser-verification`:
  the L3 pass is a later dispatch to a different agent, and the packet may say so.
- [ ] All eight packet slots are filled with concrete content (objective plus acceptance criteria,
  scope files, the Ephemera scratch directory, exactly the three SSOT paths, resolved roles to
  skills, a tier, evidence to return, stop conditions). None is left as a bracketed placeholder.
- [ ] The Ephemera slot names ONE scratch directory under the scratch root bound in
  `agent/adapters.md` § Cleanup, not a path inside the repo and not "the session scratchpad" with
  no path.
- [ ] The tier is stated as one of `judge`, `heavy` or `light` only. No model-vendor name (opus,
  sonnet, haiku, codex, gemini, claude) appears anywhere in the packet.
- [ ] The packet names, without paraphrasing their content, at least: `ponytail` (simplicity, on
  every implementer packet), `superpowers:test-driven-development` (tdd) and
  `frontend-design:frontend-design` (ui-implementation), resolved from `agent/adapters.md`'s Skill
  roles table, not invented.
- [ ] The packet's SSOT paths are exactly three: `agent/4-quota/0-card.md`, the feature's HEAD file
  `agent/4-quota/3-quota-upgrade-modal.md` and its log `agent/4-quota/3-quota-upgrade-modal.log.md`
  (both to be created at the gate). Never the whole `agent/` tree, never `00-plan.md`, never the
  item's `resume.md`.
- [ ] The packet carries the line that the subagent never edits SSOT files, and its evidence
  section requires an **"Ephemera started"** list with a teardown command per row, or `none`.
- [ ] The answer names what else the `open` gate requires: the HEAD file and an empty `.log.md`
  created from `templates/feature.md`, and a separate `light`-tier `flow-explorer` dispatch that
  writes the **before** diagram into `flows/4.3-quota-upgrade-modal.md`, pinned to the base SHA.
  A run that folds the flow drawing into the implementer packet fails this row.
- [ ] Stop conditions are present and match the BLOCKED contract in `references/dispatch.md`
  (premise mismatch, a failing command after one retry, an out-of-scope file needed, disagreeing
  readings of the acceptance criteria).

**Most likely to fail if the skill is broken:** the "no model-vendor name" clause. If
`references/dispatch.md`'s de-vendoring (tiers, not model names, on the packet) has rotted, a
hard-coded "sonnet" or "opus" string in the packet is the cheapest tell. The second cheapest is
the SSOT path list growing past three entries.

## Exercises

`references/dispatch.md`, `templates/handoff.agent.md`, `references/lifecycle.md` feature `open`
gate, `templates/flow.md`.
