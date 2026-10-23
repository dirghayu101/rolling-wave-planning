# Scenario 9: Data horizon

## Fixture

`fixtures/12-notifications/` (same fixture as scenarios 1, 3, 4, 6 and 8). Item 9 (`notif-analytics`)
sits at ledger stage `open`, not started: its card asks for send and open rate per channel, per week,
read from a durable table. `00-plan.md` § Testing plan § Environment and `agent/adapters.md`
§ Environment name the seed data (`supabase/seed.sql`: three users, one at 90% of quota, one
fully muted) and a bound `Seed convention:` (`supabase/seeds/<n>-<slug>.sql`, applied in order by
`supabase db reset`, an `app.env` guard, truncate-and-reinsert reruns, registered in
`supabase/config.toml` `[db.seed] sql_paths`).

## Prompt

Give the fresh agent exactly this, filling `<FIXTURE>` with the absolute path of a fresh COPY of
`fixtures/12-notifications/`:

> You are working in an existing rolling-wave-planning batch at `<FIXTURE>`. Invoke the
> `rolling-wave-planning` skill. Open item 9 (notification analytics dashboard: send and open rate
> per channel, per week): decompose it into features, open the first feature, and write that
> feature's file with its test strategy filled, plus the handoff packet you would dispatch to the
> `heavy` tier for it. Write the files into the fixture. Do not dispatch any subagent. Do not open
> anything under the skill repo's `tests/` directory. End your answer with a list titled "Files I
> read" naming every file you opened, in the order you opened them.

## Pass criteria

- [ ] The first feature's file carries a `Data horizon:` line in product terms that names all five
  dimensions for a per-channel, per-week rate: a span of many weeks with one empty week beyond it,
  a volume where totals and rates mean something, every notification and open state, every channel
  including one with zero sends, and the edges (a send on a week boundary, a timezone day boundary,
  the oldest row).
- [ ] Its `Seed:` line reads `insufficient` and names at least `span` and `spread`.
- [ ] The shortfall is the feature's **first task**, written under the fixture's bound convention:
  the file is named on the `supabase/seeds/<n>-<slug>.sql` pattern, registered in
  `supabase/config.toml` `[db.seed] sql_paths`, with a rerun check. **Not** an ad-hoc extension of
  `supabase/seed.sql`, which is the baseline failure this scenario exists to catch.
- [ ] The packet's Ephemera slot carries a `Seed:` line naming that seed file or the command that
  loads it.
- [ ] Nothing about the horizon is deferred to a later feature: week bucketing, zero-send channels
  and the rate formula's empty-week case are covered by this feature's test strategy, or by a seed
  feature that runs first.
- [ ] The feature `open` gate box for the data horizon is cited or visibly satisfied.

**Most likely to fail if the skill is broken:** the convention clause. The baseline agent, with no
`Seed convention:` line bound, wrote its rows as an extension of `supabase/seed.sql` and planned a
per-week rate on twelve recent notifications and five open events, deferring week bucketing and
zero-send channels to a later feature.

## Exercises

`references/verification.md` § Data under test, `references/lifecycle.md` feature `to open` gate,
`templates/feature.md` § Test strategy, `templates/handoff.agent.md` § Ephemera,
`templates/02-adapters.md` § Environment.
