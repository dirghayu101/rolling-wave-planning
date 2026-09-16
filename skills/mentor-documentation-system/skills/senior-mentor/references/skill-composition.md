# Skill composition

## TL;DR

Let specialized skills own their domain reasoning. The mentor owns teaching, critique, and explanation. `human-engineering-docs` owns the structure and readability of durable human-facing output.

## Installed-skill routing

When available, compose with these skills:

- `rolling-wave-planning`: owns near-term execution detail and progressively elaborated future work. Its state lives in a batch directory: `00-plan.md` for the ledger, `02-adapters.md` for the per-batch tool and role bindings, item cards at `rollout/<n>-<item>/0-card.md`, and reader chapters in `docs/`.
- `spec-development`: owns requirements, scope, acceptance criteria, and design evidence.
- `systematic-debugging`: owns the evidence-driven root-cause loop.
- `bug-batch-fixing`: owns safe grouping and implementation of multiple bugs.
- `human-assisted-verification`: owns the L5 human-only checks and the verification gaps they leave. Layers L1 to L4 are agent-observable and are finished before the checklist reaches the human.
- `documentation-writer`: helps classify tutorial, how-to, reference, and explanation material.
- `human-writing`: removes robotic prose after technical accuracy is established.
- `writing-for-agents`: governs agent-facing plans, skills, `AGENTS.md`, and `CLAUDE.md`, not the prose style inside `docs/`.
- `grilling` and `grill-with-docs`: pressure-test assumptions and surface durable decisions or ADRs.
- domain skills such as `sentry-react-native-sdk`, `supabase`, `stripe-best-practices`, Expo, Next.js, React Native, or TanStack Query: supply domain-specific facts and checks.

## Ownership rule

Do not ask two skills to own the same artifact. Agent plans remain agent-facing. Human docs summarize and explain them without copying their operational voice.

When a domain skill and the mentor disagree, verify against repository evidence and authoritative documentation. State the uncertainty rather than blending incompatible claims.

Use the fewest skills needed. More skills increase context and coordination cost; composition is useful only when responsibilities remain clear.

Corrected 2026-09-16: the `rolling-wave-planning` and `human-assisted-verification` entries and the `writing-for-agents` entry described the v1 layout, where reader docs lived in `human/` and the verification pass mixed agent assertions into the human steps. Both are now v2: reader docs in `docs/`, and an L1 to L5 ladder whose top layer is human-only.
