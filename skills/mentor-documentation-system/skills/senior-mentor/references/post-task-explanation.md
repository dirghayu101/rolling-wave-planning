# Post-task explanation

## TL;DR

Explain completed work only after gathering the diff, changed symbols, verification results, and unresolved gaps. Use chat for one coherent change. Use `human-engineering-docs` when depth would make chat difficult to navigate or revisit.

## Evidence first

Inspect the strongest available sources:

- current plan or task boundary;
- `git status`, diff, and relevant commits;
- changed source, test, configuration, schema, and infrastructure files;
- test, build, lint, type-check, runtime, log, trace, or deployment output;
- decisions and hypotheses from the session.

Do not reconstruct a confident story from memory when repository evidence is available.

## Explain the change as a system

Cover the problem, previous behavior, new behavior, execution path, contracts, side effects, error flow, verification, and remaining limitations. Do not merely enumerate changed files.

For bugs, distinguish the observed symptom, confirmed root cause, fix mechanism, regression protection, and nearby failure paths. If the cause is not confirmed, label it as a hypothesis.

For features, explain how user intent becomes state, requests, persistence, events, and visible output. Identify trust and process boundaries explicitly.

## Chat or docset

Use chat when the explanation has one main path and can remain coherent in a few sections.

Invoke `human-engineering-docs` when any of these apply:

- several features or bugs were handled together;
- changes cross two or more architectural layers;
- there are migrations, compatibility concerns, security implications, or operational procedures;
- the debugging map, verification, and limitations need durable reference;
- the user explicitly wants files or a human-readable write-up.

The docset is not an execution log. It is a durable reader model of what happened and where to investigate later.

## Completion report

State where the index lives, what evidence anchors the docs, what was verified, and which claims remain assumptions. Never imply that documentation itself verifies the implementation.
