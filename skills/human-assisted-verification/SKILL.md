---
name: human-assisted-verification
description: Use when verifying that a change actually works and unit tests plus reading the code aren't enough — especially when there's no automation MCP for the surface (a mobile app) or the effect is fire-and-forget (FCM push, email, webhook). Produces a checklist of detailed human steps + machine/MCP assertions + human-only observations, executed with the human acting as the instrument. Reusable for bugs, features, and specs. Don't use when an automated test or a direct MCP check fully proves the behavior on its own.
---

# Human-Assisted Verification

## Overview

The agent and the human perceive a system differently. The human uses the app — taps, sees, feels something is wrong. The agent reads logs, DB rows, and network traffic. A bug the human can see may be invisible to the agent's tools, and vice-versa. There is no mobile-automation MCP, so for many changes the only way to verify is to **use the human as an instrument**: the human performs precise app steps, the agent verifies the machine-observable effects.

This does not replace unit tests — they still exist. It covers the gap tests and code-reading can't reach.

## When to Use

- No automation MCP for the surface (mobile app screens).
- Fire-and-forget effects with no persisted trace (FCM, email, webhooks).
- End-to-end behavior where reading the code isn't proof.
- **Don't** use when an automated test or a single read-only MCP query already proves it.

## The Process

### The three-column checklist (lives in `01-verification.md`)

For each item, write:

| Column | What | Who observes |
|---|---|---|
| **Human steps** | Detailed, numbered, unambiguous app actions. e.g. "1. Open app → Profile → Contact Support. 2. Type 'test-123'. 3. Tap Submit." Assume the human is deliberately slow — leave no gaps. | Human |
| **Machine assertions** | Read-only checks the agent runs. e.g. "`support_tickets` gains a row: message='test-123', user_id=<them>, created < 2 min ago." | Agent (Supabase MCP / logs / network) |
| **Human-only observations** | What no MCP can see. e.g. "a success toast appears." | Human |

Record a verdict per item: **PASS / FAIL / NEEDS-HUMAN**. Reference the relevant test cases too.

### Durable-observable-first

1. Assert on **durable state** (a persisted row, a status field) wherever the behavior produces one — it doesn't expire.
2. **Logs are primary only for fire-and-forget calls** with no persisted trace (e.g. checking the FCM call succeeded). Flag log-based assertions **time-sensitive (24h)** — Supabase retains logs ~24h.
3. Note dev-time DB resets: a row you'd assert on may be wiped, so verify before the next reset.

### Born stable, elaborated per item, executed incrementally

1. The checklist exists from the start of the effort, initially holding only the **stable** record (which tables/state must change per item).
2. As each item is fixed, flesh out its concrete human steps + machine assertions while context is fresh.
3. The human verifies in **groups as items complete** (verify 4 done of 20) — never blocked waiting for the whole batch.

### The interrupt handshake (time-sensitive)

The human runs the app in parallel with the agent's work. When they've done the human steps for a group of items, they **interrupt** the agent to trigger the machine-assertion sweep. The agent runs all machine assertions **promptly**, before the 24h evidence window closes for any log-based ones. This is safe to do mid-work because all state is in the SSOT directory.

### Fallback on failed assertion

If a planned assertion fails — often because a planning-phase premise was wrong (the log line you expected doesn't exist, the table you expected doesn't change):

1. Do **not** fail silently or assume the fix is broken.
2. Propose an **alternative observable** (a different row, a different log, a temporary audit record).
3. Record the pivot in the SSOT so the decision survives a session exit.

## Delegation

- Evidence-before-claims discipline → `verification-before-completion`.
- If a failed verification reveals a genuine new bug → `systematic-debugging`.
