# Release runbook: template

Template for `rolling-wave-planning`. Lives at `runbooks/0-release.md`, one per batch, written at the
batch PR gate. It sequences the whole release: which runbook runs when, what gets merged in what
order, and what gets tagged.

**Stage two of two.** Stage one, the dev pass, is finished in `verification/` before this file opens. Every step here is run by hand, never by an agent.

**Link the project's release conventions; never restate them.** Branch model, tag prefixes, what a
major, minor or patch bump means, and who may merge what are the project's rules and they live in the
project's own instructions file. Restating them here creates a second copy that drifts.

## The order this file assumes

1. The code is reviewed through the PRs.
2. The dev pass runs on the `verification/` files.
3. This file is worked through by hand: merge the batch, run the migrations in order, release the
   dashboard, tag or ship the app.

## Template: copy verbatim, replacing bracketed text

```markdown
# Release: <batch title>

Batch PR: <url> · Batch branch: `<branch>` · Release conventions: <link to the project's own
instructions, section name>

Run this after the rows in `verification/` are ticked. Every step here is run by hand; no agent runs
any of it.

## 0. Before you start

| # | Check | Expect |
|---|---|---|
| 1 | every `verification/` file's rows read PASS, or the FAILs are triaged | <what to do otherwise> |
| 2 | the full test suite on the batch branch | green |
| 3 | <anything that must already be live> | <...> |

## 1. Merge

| # | Merge | Into | Note |
|---|---|---|---|
| 1 | <batch branch> | <trunk> | <who merges, and whether it is a merge commit> |

## 2. Migrations and production steps, in this order

| Order | Runbook | What it does | Must run before |
|---|---|---|---|
| 1 | `runbooks/<k>-<slug>.md` | <one line> | <the deploy that needs it> |
| 2 | `runbooks/<k>-<slug>.md` | <one line> | <...> |

Each of those files carries its own preflight, dry run, apply, post-check and rollback. Run them
whole, in this order, and do not start the next until the previous one's post-check has passed.

## 3. Dashboard release

| # | Step | Command or action | Expect |
|---|---|---|---|
| 1 | merge the trunk into the production branch | `<command>` | <fast-forward, or the stated exception> |
| 2 | tag the release | `<tag command with the version you decided below>` | <the tag pushed> |
| 3 | confirm the deploy | <where you look> | <what you should see> |

## 4. App release

| # | Step | Command or action | Expect |
|---|---|---|---|
| 1 | <tag `app-v<version>`, or push an OTA update> | `<command>` | <...> |
| 2 | <store submission, if this batch needs one> | <...> | <...> |

Nothing in this batch ships to the app? Write `No app change in this batch.` and delete the table.

## 5. Version bump

| Deployable | Version | Why this bump |
|---|---|---|
| dashboard | `dashboard-v<x.y.z>` | <which rule in the project's conventions this falls under> |
| app | `app-v<x.y.z>` or OTA | <...> |

Semantic versioning is decided here, once, against the project's own rules. Link the rule; do not
copy it.

## 6. After

- [ ] Every runbook above is deleted, in the commit that records the push.
- [ ] `00-plan.md` § Hand-back rows for those runbooks are struck through.
- [ ] <anything that must be watched for the next day: an error rate, a queue, a cron run>
```

## Lifetime

Written once at the batch PR gate, rewritten in place if the order changes before the push, and
deleted with the rest of `runbooks/` in the commit that records the push.
