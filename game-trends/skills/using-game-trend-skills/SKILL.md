---
name: using-game-trend-skills
description: Use when the conversation is about mobile, hyper-casual, hybrid-casual or web games as a business — market trends, game ideas, judging a concept, social-media trends to turn into games, KPIs like D1/D7/CPI/ARPDAU, or how to publish and monetize a game on a small budget.
---

# Using Game Trend Skills

A library for solo devs and small teams who want to ship simple games that make money. Every skill shares the five rules below.

## The five rules

1. **Live evidence only.** Market numbers, benchmarks, fees, revenue shares and platform policies change monthly. Never state one from memory. Search for it, open the source, and cite it as `(Source, Month YYYY)`. Anything you calculated or inferred gets the label **estimate**. If you cannot find a current source, say "not verified" and don't use the number.
2. **State assumptions first.** Before you recommend anything, write down what you assume about the creator: budget, team, engine, platforms, markets, time. If the profile is missing and an assumption would change the recommendation, ask one question.
3. **Simplest game that tests the hypothesis.** Choose ideas, scopes and briefs that a solo dev can ship in weeks. Every extra system needs a reason tied to a metric. A smaller idea that ships beats a better idea that doesn't.
4. **Every idea has a kill switch.** Each recommendation says which metric and threshold kill it, which iterate it, and which scale it, plus where the threshold came from.
5. **Verdict first, in the user's language.** Open with the decision or the top finding, then the reasons. Skill text is English, but you answer in the language the user writes in.

## Creator profile

Read `game-trend-profile.md` in the project root if it exists. If it doesn't and the user has stated constraints, create it from `profile-template.md` in this directory. Update it whenever the user changes a constraint (for example, a new budget).

## Which skill

| Situation | Skill |
|---|---|
| "What's trending / give me an insight report" | `scanning-game-trends` |
| TikTok / Reels / Shorts / meme → game | `scouting-social-trends` |
| "Give me game ideas" | `brainstorming-game-ideas` |
| "Is this idea / my game any good?" | `evaluating-game-ideas` |
| "Here are my numbers, what now?" | `tracking-game-metrics` |
| Turn a chosen idea into a build spec for coding agents | `writing-game-agent-briefs` |
| Publish, monetize, grow with little or no money | `launching-on-zero-budget` |

The usual chain is scan → scout → brainstorm → evaluate → brief → launch → track. Any skill can be entered directly.

## Files this library writes

- `reports/YYYY-MM-DD-<type>.md`: trend reports, idea sets, evaluations
- `briefs/<game-slug>.md`: agent build briefs
- `metrics/<game-slug>.md`: an append-only metric log for each game
- `game-trend-profile.md`: creator constraints

Before writing a new file, read the latest earlier file of the same type and carry its open items forward.

## Shared references

- `metrics-glossary.md`: KPI definitions and formulas (definitions only, no benchmark values)
- `sources.md`: where to look and what each source is good for

## Red flags

| Thought | Reality |
|---|---|
| "I know roughly what D1 benchmarks are" | Memory is stale. Search. |
| "This number is close enough without a source" | Uncited = unusable. Label it estimate or drop it. |
| "A few extra features will make it stand out" | Features cost weeks. Differentiate with theme, feel and content automation. |
| "The genre is growing, so this idea is good" | Genre totals hide title-level spread. Check comparable titles. |
