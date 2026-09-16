# Skill composition

## TL;DR

Let specialized skills own their domain reasoning. The mentor owns teaching, critique, and explanation. `human-engineering-docs` owns the structure and readability of durable human-facing output.

## Installed-skill routing

When available, compose with these skills:

- `rolling-wave-planning`: owns near-term execution detail and progressively elaborated future work.
- `spec-development`: owns requirements, scope, acceptance criteria, and design evidence.
- `systematic-debugging`: owns the evidence-driven root-cause loop.
- `bug-batch-fixing`: owns safe grouping and implementation of multiple bugs.
- `human-assisted-verification`: owns explicit manual checks and unresolved verification gaps.
- `documentation-writer`: helps classify tutorial, how-to, reference, and explanation material.
- `human-writing`: removes robotic prose after technical accuracy is established.
- `writing-for-agents`: governs agent-facing plans, skills, `AGENTS.md`, and `CLAUDE.md`, not the prose style inside `human/`.
- `grilling` and `grill-with-docs`: pressure-test assumptions and surface durable decisions or ADRs.
- domain skills such as `sentry-react-native-sdk`, `supabase`, `stripe-best-practices`, Expo, Next.js, React Native, or TanStack Query: supply domain-specific facts and checks.

## Ownership rule

Do not ask two skills to own the same artifact. Agent plans remain agent-facing. Human docs summarize and explain them without copying their operational voice.

When a domain skill and the mentor disagree, verify against repository evidence and authoritative documentation. State the uncertainty rather than blending incompatible claims.

Use the fewest skills needed. More skills increase context and coordination cost; composition is useful only when responsibilities remain clear.
