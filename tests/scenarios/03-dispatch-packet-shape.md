# Scenario 3 — Dispatch packet shape

## Fixture

`fixtures/12-notifications/` (same fixture as scenario 1). `phase: executing`. Item 4's card
lists feature 4.3 (`quota-upgrade-modal`) at stage `pending` — a web-surface feature with no
feature file yet (features are decomposed just-in-time, per `references/lifecycle.md`). The
batch's `02-adapters.md` is present with tiers, the `web` surface bound to `agent-browser`, and
the skill-roles table filled (including a stack-conditional `framework` row for `next`).

## Prompt

Give the fresh agent exactly this, filling `<FIXTURE>` with the absolute path of a fresh COPY of
`fixtures/12-notifications/`:

> You are working in an existing rolling-wave-planning batch at `<FIXTURE>`. Invoke the
> `rolling-wave-planning` skill. Your task is "Implement feature 4.3." You will **not** implement
> any code yourself — instead, follow the batch's dispatch process to produce the exact handoff
> packet you would send to an implementer subagent for this feature, using
> `templates/handoff.agent.md` as the shape. Paste the fully filled packet in your answer, resolve
> every role against `02-adapters.md` yourself (do not leave a placeholder), and do not dispatch
> or invoke any other subagent. End your answer with a list titled "Files I read" naming every
> file you opened, in the order you opened them.

## Pass criteria

- [ ] The packet type matches the feature's ledger stage (4.2 is `reviewed`, so the packet is an L3 verification packet: `light` tier, `browser-verification` role, wireframe path in scope). An implementer packet would additionally carry `simplicity` and `tdd`. (Corrected 2026-09-16: the prompt used to say "implement", which contradicted the fixture.)

- [ ] All seven packet slots are filled with concrete content (objective + acceptance criteria,
  scope files, exactly the three SSOT paths, resolved roles → skills, a tier, evidence-to-return
  shape, stop conditions) — none left as a bracketed placeholder.
- [ ] The tier is stated as one of `judge` / `heavy` / `light` only; no model-vendor name (opus,
  sonnet, haiku, codex, gemini, claude) appears anywhere in the packet.
- [ ] The packet names, without paraphrasing their content, at least: `ponytail` (simplicity, on
  every implementer packet), `superpowers:test-driven-development` (tdd), and `agent-browser`
  (browser-verification, since 4.3 has a web surface) — resolved from `02-adapters.md`'s Skill
  roles table, not invented.
- [ ] The packet's SSOT paths are exactly `rollout/4-quota/0-card.md`,
  `rollout/4-quota/3-quota-upgrade-modal.md` (or the feature's to-be-created path), and
  `working/4-quota.agent.md` — never the whole `rollout/` tree and never `00-plan.md`.
- [ ] The implementer named or implied by the packet is distinct from any reviewer or verifier
  role — the packet does not ask the same agent to implement, review, and verify.
- [ ] Stop conditions are present and match the BLOCKED contract in `references/dispatch.md`
  (premise mismatch, a failing command after one retry, out-of-scope file needed, disagreeing
  readings of acceptance criteria).

**Most likely to fail if the skill is broken:** the "no model-vendor name" clause — if
`references/dispatch.md`'s de-vendoring (tiers, not model names, on the packet) has rotted, a
hard-coded "sonnet"/"opus" string in the packet is the cheapest tell.

## Exercises

`references/dispatch.md`, `templates/handoff.agent.md`.
