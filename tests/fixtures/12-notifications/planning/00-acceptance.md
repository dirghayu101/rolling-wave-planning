# Acceptance: Notifications platform hardening

One row per requirement the developer stated in the intake rant, in their own words, plus the
implicit rows. The agent fills "Evidence" as the batch advances; the "Verdict" column is the
developer's. Nothing is deleted here: a struck row is recorded as struck.

| # | Requirement (developer's words) | Where it lives | Evidence | Verdict |
|---|---|---|---|---|
| 1 | "tokens go stale and we never notice" | item 1, `agent/1-push-tokens/0-card.md` | L1 and L2 green, rotation and invalidation covered; item merged 2026-09-09 | met |
| 2 | "the digest email job sometimes double-sends" | item 3, `agent/3-digest-scheduler/0-card.md` | idempotency key added, integration test proves a second run is a no-op; item merged 2026-09-09 | met |
| 3 | "users who blew past some invisible send quota with no warning" | item 4, `agent/4-quota/0-card.md` | 4.1 merged with L1 to L3 evidence; 4.2 at `reviewed` with L3 driven; 4.3 not opened | open |
| 4 | Implicit: every merged feature is tested as far as L1 to L4 allow, and carries a before and after flow | `references/verification.md` ladder, item gates, `flows/` | 4.1 and 4.2 both carry flow files; item 4's L4 pass and the `quota-mute-settings` group not yet run | open |
