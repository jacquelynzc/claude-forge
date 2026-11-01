---
name: evaluating-game-ideas
description: Use when the user asks whether a game idea, prototype, or existing or unfinished game is worth making, how it fits current trends, how it compares to competitors, or whether to continue, pivot, or drop it.
---

# Evaluating Game Ideas

Judge one idea against **live market evidence** and the **creator's constraints**, then give one verdict: **GO**, **PIVOT**, or **KILL**.

**REQUIRED BACKGROUND:** `using-game-trend-skills`.

## Protocol

1. **Restate the idea as a core loop** in one sentence (input → action → feedback → goal → fail state). If you can't, the idea is unclear. Ask one question, then stop.
2. **Load the creator profile** (`game-trend-profile.md`) and the latest insight report if it is less than 30 days old. If it is older, do a short live check of charts and trending for this mechanic.
3. **Find comparables live.** Search stores and charts for 3–5 games with the same core loop. For each one, record: title, publisher, launch date, chart position or trend, monetization model, and the top complaints from 1–3 star reviews.
4. **Place the mechanic on the lifecycle** (emerging / rising / peaking / saturated). See `scanning-game-trends`.
5. **Check the hard gates.** Any fail means KILL or PIVOT:
   - Uses third-party IP (characters, brands, songs)
   - The MVP needs more than the creator's budget or skills (for example, 3D art for an art-weak solo dev, a backend, multiplayer)
   - Build time to MVP is longer than the remaining trend window
   - Saturated mechanic with no twist that a muted 3-second clip can show
6. **Score** with `scoring-rubric.md`. Every score needs a one-line reason that cites the evidence.
7. **Decide:**
   - **GO:** all gates pass and total ≥ 24/35, with no score of 1
   - **PIVOT:** a gate fails or the total is 18–23, but a specific change fixes it. Name the change and re-score the pivoted version.
   - **KILL:** total < 18, or a gate fails with no cheap fix
8. **Write** the output in the contract below. Save it as `reports/YYYY-MM-DD-eval-<slug>.md`.

## Output contract (in this order)

1. **Verdict:** GO / PIVOT / KILL, with the strongest reason in one sentence
2. **Core loop:** one sentence
3. **Scorecard:** a table with 7 criteria × score × evidence-based reason, and the total
4. **Comparables:** a table with the fields from step 3
5. **Gaps to exploit:** the top 1–3 player complaints or missing features in competitors
6. **Pivot or sharpen:** the single change that most raises the score (needed for PIVOT, optional for GO)
7. **Kill switch:** which metrics and which live-sourced thresholds would end the test (hand off to `tracking-game-metrics`)
8. **Assumptions & unknowns**

## Evaluating an existing or unfinished game

Treat the game as it is now. Add two scores to the scorecard notes:
- **Distance to shippable MVP** (in days)
- **Reusable parts** (code, art, systems that would carry into a pivot)

Sunk cost is not a criterion. Say so if the user seems attached.

## Common mistakes

| Mistake | Fix |
|---|---|
| Scoring from intuition | Each score cites a comparable title, a chart position or a source. |
| Hedged verdict ("it could work if…") | Pick one verdict. Put conditions in the kill switch. |
| Only checking whether the genre is growing | Check title-level spread: one hit can carry a whole subgenre. |
| Ignoring the creator profile | A great idea for a 30-person studio is a KILL for a solo dev on a tiny budget. |
