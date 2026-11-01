---
name: scanning-game-trends
description: Use when the user wants a current mobile game market overview, an insight or trend report, "what's hot right now", a routine/weekly/monthly market update, or needs fresh market context before generating or judging game ideas.
---

# Scanning Game Trends

Produce a dated, sourced insight report on the current mobile game market. Focus on hyper-casual and hybrid-casual, and on what a small creator can act on this month.

**REQUIRED BACKGROUND:** `using-game-trend-skills` (the five rules, profile, glossary, sources).

## Protocol

1. **Anchor the date.** Write today's date. The scan window is the last complete month plus the current month to date. Everything older is background and gets labeled with its date.
2. **Load context.** Read `game-trend-profile.md` and the latest `reports/*-insight-report.md`. Note the earlier report's watchlist, because you must answer each item.
3. **Search in parallel.** Run one batch per lane. Use `using-game-trend-skills/sources.md` for where to look, and put the month and year in every query.

   | Lane | Must answer |
   |---|---|
   | Charts | Top downloads and grossing last month. **Which titles are rising fastest** (trending lists, big rank jumps)? |
   | Genres | Which subgenres are growing or shrinking in revenue and downloads? How many new releases per subgenre (clone pressure)? |
   | Mechanics | For each rising title: the core loop in one sentence, the publisher, the launch date, and 1–3 star review complaints |
   | Benchmarks | Current prototype KPI targets and eCPM ranges for the user's genre and geos |
   | Region | The user's home market (size, growth, local studios and publishers, retention vs global) |
   | Social | Hand off to `scouting-social-trends`, or do a short pass yourself if that skill isn't installed |
   | Channels | Changes to store fees and rules, web portals, in-app game platforms (YouTube Playables, TikTok Minis, etc.) |
   | Calendar | Holidays and events in the next 90 days in the target markets |

4. **Open primary sources** for every number you will use. Snippets are leads, not evidence.
5. **Place each mechanic on the lifecycle:**
   - **Emerging:** 1–2 titles in the trending lists, few clones
   - **Rising:** several titles climbing, clone count growing, still room to differentiate
   - **Peaking:** in top-10 downloads, many near-identical releases
   - **Saturated:** top spots held by big publishers, flood of clones, CPIs rising
   Small creators should target **emerging or rising**. They should enter peaking only with a sharp twist, and avoid saturated.
6. **Check genre claims at title level.** A subgenre "growing 40%" can be a single hit. Name the titles behind every genre-level claim.
7. **Write the report** using `report-template.md`. Save it as `reports/YYYY-MM-DD-insight-report.md`, in the user's language.
8. **Close the loop.** Answer each watchlist item from the earlier report, and write a new watchlist.

## Quality bar

- Every number carries `(Source, Month YYYY)`. Calculations are labeled **estimate** and show their inputs.
- The TL;DR has 5–7 bullets and each one ends in an implication for this creator.
- At least one "avoid" call, with the reason.
- Opportunities are stated as **mechanic + window + why this creator can win** (for example, content automation, speed, local insight).

## Common mistakes

| Mistake | Fix |
|---|---|
| Listing the top-10 grossing games (Honor of Kings, Roblox…) as "opportunities" | These are context. Opportunities come from the **trending/risers** lists and new subgenres. |
| Treating downloads as success | Pair each download claim with a monetization signal (grossing rank, IAP, or ad-heavy model). |
| Copying a headline number from an aggregator | Open the original report and check the period it covers. |
| Recommending a mechanic without opening its store page | Read the description and the bad reviews, because that's where the gap is. |
| Ending without a next step | End with this week's 3–6 concrete actions. |
