# Scenario 11: Captures and run logs stay out of the repository

## Fixture

`fixtures/12-notifications/` (same fixture as scenarios 1, 3, 4, 6, 8, 9 and 10). Two things in it
matter here:

- `agent/adapters.md` § Cleanup binds the scratch root `/tmp/rwp-12-notifications/`, a
  `Kept captures:` line (`flows/assets/`, element PNG under 200 KB) and an `Ignore rules:` line.
- The 4.1 and 4.2 logs carry L3 evidence rows written as numbers, with no capture paths, and a
  capture-set ephemera row each.

**Setup on the fresh copy, before the run.** Feature 4.3 (`quota-upgrade-modal`) is taken to the
`open` to `built` gate, at HEAD `7c1e9d42`:

1. `agent/4-quota/3-quota-upgrade-modal.md` from `templates/feature.md`: Stage `open`, the upgrade
   modal reachable from the banner and the settings screen, L3 planned at 1440, 768 and 375 with a
   focus read on open. The card's 4.3 row links it and its flow file.
2. `agent/4-quota/3-quota-upgrade-modal.log.md` from the template, with three Dispatch rows at
   `7c1e9d42` (flow before, implement, browser verify, all `returned`), one L1 evidence row
   (`apps/dashboard/components/QuotaUpgradeModal.test.tsx`, 6 exit points green), and empty
   Review and Ephemera tables.
3. `flows/4.3-quota-upgrade-modal.md` with its header and one line under Before: the modal is a
   new surface, so there is no before flow. After not yet written.
4. The scratch directory the browser pass left behind:

```bash
D=/tmp/rwp-12-notifications/4.3-browser && mkdir -p "$D"
head -c 1900000 /dev/urandom > "$D/modal-1440-full.png"
head -c 900000  /dev/urandom > "$D/modal-768-full.png"
head -c 600000  /dev/urandom > "$D/modal-375-full.png"
head -c 2300000 /dev/urandom > "$D/upgrade-flow.har"
{ yes ' ✓ QuotaUpgradeModal > lists plans (113 ms)' | head -6000
  echo ' Test Files  31 passed (31)'; echo '      Tests  212 passed (212)'; } > "$D/vitest.log"
cat > "$D/geometry.txt" <<'TXT'
1440: modal box 480x312 at (480,214); focus on h2#upgrade-title after open
768:  modal box 480x312 at (144,180)
375:  modal box 343x356 at (16,120); CTA 48px tall; no horizontal scroll
errors --json: []
network: POST /api/quota/upgrade 201; GET /api/quota 200
TXT
```

The vitest log comes out near 275 KB: 6000 repeated lines plus a `212 passed` summary.

## Prompt

Give the fresh agent exactly this, filling `<FIXTURE>` with the absolute path of the prepared COPY
of `fixtures/12-notifications/`:

> You are working in an existing rolling-wave-planning batch at `<FIXTURE>`. Invoke the
> `rolling-wave-planning` skill. Feature 4.3's L3 browser pass has just returned at HEAD
> `7c1e9d42`; everything it produced is in `/tmp/rwp-12-notifications/4.3-browser/`, which you may
> read. Take 4.3 to the point where its PR is ready: write the evidence and ephemera rows into the
> feature's log, decide what from the scratch directory is kept in the repository and where, and
> write the feature PR body. Make every file edit and file move in the fixture and show each one in
> your answer. Do not dispatch any subagent. Do not open anything under the skill repo's `tests/`
> directory. End your answer with a list titled "Files I read" naming every file you opened, in
> the order you opened them.

## Pass criteria

- [ ] The L3 evidence row in `agent/4-quota/3-quota-upgrade-modal.log.md` carries the SHA, the flow
  that was driven and the numbers read back: the modal box at 1440, 768 and 375, focus on
  `h2#upgrade-title` after open, the 48px CTA and no horizontal scroll at 375, `errors --json` [],
  POST `/api/quota/upgrade` 201 and GET `/api/quota` 200. **No capture path appears in the row.**
- [ ] Nothing is copied under `agent/`: no `agent/assets/`, no PNG, HAR or log anywhere below it.
- [ ] No PNG, HAR or log is kept in the repository, unless a `flows/` or `verification/` file cites
  one element capture under the 200 KB cap, in which case it lives in `flows/assets/` (or
  `verification/assets/`) beside the citing file. A full-page PNG kept anywhere is a fail.
- [ ] The PR body follows `templates/pr-body.md`, embeds nothing from `agent/`, and links the flow
  file for the visual change.
- [ ] The `## Ephemera` table gains a row, or rows, naming the capture set (the three PNGs and the
  HAR) and the scratch directory, each with a teardown command such as
  `rm -rf /tmp/rwp-12-notifications/4.3-browser/`, and no `kept:` reason for any of them.
- [ ] The test log is not kept. The `212 passed` summary may be cited as text in a row, beside the
  command that produced it.
- [ ] No model-vendor name appears in any file the run wrote.
- [ ] Reading budget holds: no file under `agent/1-push-tokens/` through `agent/3-digest-scheduler/`
  or `agent/5-mute-channels/` through `agent/9-notif-analytics/` was opened.
- [ ] "Files I read" contains nothing under the skill repo's `tests/` directory. If it does, the
  run is void (README rule 5): re-run with a fresh agent, do not grade it.

## Grading

Grade on where the captures and the log ended up and on what the evidence row holds, not on the
prose of the PR body. **Most likely to fail:** the row that points at a PNG. An agent that reads
"evidence is a pointer" keeps the captures to have something to point at.

## Exercises

`references/verification.md` § L3 and § Evidence entries, `references/ssot-layout.md` (Captures and
run logs), `references/dispatch.md` § Recording the dispatch, `references/lifecycle.md` feature
`open` to `built` gate, `templates/pr-body.md`, `agent/adapters.md` § Cleanup.

## Baseline

RED on 2026-10-23, against 3.6.0, with a fresh light-tier agent: it kept all three full-page PNGs
(3.4 MB) under `agent/assets/`, pointed the evidence row at them, and embedded two in the PR body.
Its stated reasons: "evidence is a pointer to something re-openable" (`references/verification.md`),
"expiring evidence goes into `agent/assets/`" (`references/ssot-layout.md`), "the house precedent in
the 4.1 and 4.2 logs is three PNGs kept" (the fixture logs, since rewritten), "screenshots cannot be
regenerated without a new browser pass", and "the reviewer needs to see the layout". The same habit
in a real project left 507 PNGs (94 MB) and about 100 test-run logs of 330 to 386 KB under
`agent/assets/` across one batch, all deleted later as noise.

GREEN on 2026-10-23, against 3.7.0, same tier, same prompt, fixture prepared as above: nothing kept
(the three PNGs named as full page against the 200 KB element cap, the HAR and the test log named as
run logs), the L3 row written as numbers with the pass's gaps listed beside them, one ephemera row
naming the capture set, the HAR, the log and the scratch directory with its `rm -rf` teardown, the
`212 passed` summary cited as text, the PR body linking the flow file and embedding nothing. The
agent also refused to set `built`, because the after flow was not drawn and the pass had gaps; that
is the lifecycle working, not a scenario failure.
