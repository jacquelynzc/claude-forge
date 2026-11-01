---
name: tracking-game-metrics
description: Use when the user shares game analytics or KPIs (retention, D1, D7, playtime, CPI, CTR, ARPDAU, eCPM, installs, ROAS, ratings), asks how a live or test game is doing, whether to kill, iterate, pitch to a publisher or scale, or wants to monitor a game over time.
---

# Tracking Game Metrics

Turn a game's numbers into **one decision** and **the 1–3 actions** that most move the weakest metric. Log every check so trends over time are visible.

**REQUIRED BACKGROUND:** `using-game-trend-skills` (glossary has the definitions).

## Protocol

1. **Collect the context** with the numbers. Ask once for whatever is missing:
   - game slug, genre/mechanic, build version
   - platform(s), geo mix, traffic source (organic / paid / publisher test)
   - cohort size (installs) and date range
   - available metrics: D1, D7, D30, D0 playtime, session length, level funnel, CPI/CTR/IPM, eCPM by format, impressions/DAU, ARPDAU, IAP conversion, rating
2. **Check data quality before judging:**
   - Small cohorts make retention noisy. Report the cohort size, and if it is in the low hundreds or smaller, say the read is **directional only**.
   - Don't mix organic, paid and publisher-test cohorts.
   - Don't compare builds across a major change. Treat them as separate cohorts.
3. **Build a live threshold table** for this genre, platform, geo and month. Find current prototype KPI targets and eCPM ranges (see `using-game-trend-skills/sources.md`), and cite each one. Note when the cohort's geo is known to retain or monetize below the global average. Never reuse thresholds from memory or from an old log without re-checking their date.
4. **Diagnose in funnel order:** marketability → retention → engagement → monetization. The **first** weak stage is the problem. Fixing a later stage first is wasted effort.

   | Symptom | Likely cause | First things to try |
   |---|---|---|
   | High CPI / low CTR or IPM | Hook doesn't read in the first 3 seconds | New creatives, a clearer first frame, a stronger payoff moment |
   | Low D1 | FTUE confusion, slow start, early difficulty spike | Fun in the first tap, cut the tutorial, check the level-1–5 funnel |
   | OK D1, low D7 | No reason to return, flat difficulty, no meta | Progression or collection, daily challenge or streak, a better difficulty curve |
   | Low playtime | Levels too short or too few, or friction between levels | Longer level arcs, faster transitions, a "next level" auto-start |
   | Sharp level drop-off | A specific level is too hard or unclear | Rebalance that level, add a solvability check |
   | Low ARPDAU with decent retention | Too few natural ad moments, or rewarded placements weak | Add rewarded hooks (retry, +slot, booster), tune interstitial frequency, use mediation when at scale |
   | Falling rating | Ads too aggressive, or unfair levels | Cap interstitials, add no-ads IAP, fix unfair levels |

5. **Decide** using the live thresholds:
   - **KILL:** the first-stage metric is far below its threshold after a fair test (enough installs, at least one iteration on the weakest stage)
   - **ITERATE:** below threshold, but one diagnosed cause has a cheap fix
   - **PITCH TO PUBLISHER:** marketability and early retention meet the publisher-test targets. Publishers fund the next tests.
   - **SMALL PAID TEST:** retention meets targets, revenue exists, and the budget allows a capped CPI test
   - **SCALE:** cohort LTV > CPI with margin on real data
6. **Append to the log** `metrics/<game-slug>.md` (create it if missing):
   ```
   ## YYYY-MM-DD · build X · cohort N installs · source: organic|paid|test · geo: …
   | Metric | Value | Threshold (source, month) | Status |
   Decision: … — because …
   Actions: 1) … 2) …
   Next check: YYYY-MM-DD, after …
   ```
   Compare with earlier entries and call out the deltas.

## Output contract (in this order)
1. **Decision**, with the one-sentence reason
2. **Metric table**: value vs live threshold vs status
3. **Bottleneck**: the first weak stage and its likely cause
4. **Actions**: 1–3, ranked by expected impact ÷ effort
5. **Data caveats**: cohort size, mixed sources, missing metrics
6. **Next check**: when, and what has to happen first

## Revenue estimate (when asked)
Ad ARPDAU ≈ Σ over formats (impressions/DAU × eCPM / 1000), using live eCPMs for the cohort's geo mix. Label it **estimate**, show the inputs, and give a low/high range based on geo mix.

## Common mistakes

| Mistake | Fix |
|---|---|
| Declaring a winner or loser from tiny cohorts | State the cohort size and the confidence level. Collect more data before a KILL. |
| Optimizing ARPDAU while D1 is broken | Fix funnel stages in order. |
| Using thresholds from memory | Build a live threshold table every run. |
| Five actions at once | 1–3 actions, so the next check can tell which one worked. |
