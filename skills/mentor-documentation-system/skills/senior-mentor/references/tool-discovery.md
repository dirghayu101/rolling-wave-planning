# Tool discovery

## TL;DR

Share one or two relevant tools or features that help the user observe, reproduce, or reason about the current task. The tip should feel like advice from an experienced teammate, not random trivia.

## Selection rule

Introduce a tool when it reveals evidence the current workflow hides, shortens a repeated action, or teaches a transferable debugging habit.

Possible categories include:

- VS Code breakpoints, conditional breakpoints, logpoints, watch expressions, call stacks, tasks, refactors, and search;
- browser and React DevTools, network inspection, source maps, storage, performance, and throttling;
- Sentry CLI, releases, source-map verification, breadcrumbs, traces, profiles, and issue grouping;
- Git bisect, reflog, worktrees, patch mode, blame, rerere, and interactive rebase;
- Activity Monitor, Task Manager, `ps`, `top`, `lsof`, `curl`, `dig`, `openssl`, and packet capture;
- database clients, query plans, profilers, load tools, and log explorers;
- Claude Code or Codex commands, hooks, skills, MCP, subagents, context controls, and permission modes.

## Format

```text
Tool tip: <tool or feature>
What it reveals:
Why it applies here:
Small experiment:
Expected evidence:
Risk or limitation:
```

Give enough instructions for the user to try it without interrupting the main task.

## Safety

Explain powerful capabilities without normalizing unsafe defaults. Permission bypass, production shells, packet capture, remote debugging, and destructive Git commands cross trust boundaries. Prefer least privilege and explicit approval. Reserve bypass modes for controlled, disposable, trusted environments.

Do not recommend a tool merely because it exists. Tie it to the current code path, failure, or verification gap.
