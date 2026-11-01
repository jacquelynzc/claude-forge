---
name: launching-on-zero-budget
description: Use when planning how to publish, distribute, monetize, or grow a game with little or no money — store accounts, web game portals, in-app game platforms, publisher submissions, ad monetization setup, organic TikTok/Reels/Shorts growth, or when to start spending on user acquisition.
---

# Launching on Zero Budget

Get a game in front of players and earning with **near-zero cash**. Every fee, revenue share, policy and threshold here changes over time, so **verify each one live** and cite it.

**REQUIRED BACKGROUND:** `using-game-trend-skills`.

## Step 1 — Verify current terms (every run)

Search and record, with source and date:

| Channel | Verify |
|---|---|
| Google Play | Registration fee; testing requirements for **new personal accounts** (closed-test tester count and days); identity verification; organization vs personal differences |
| Apple App Store | Program fee and renewal; local-currency price in the user's country |
| Web portals (CrazyGames, Poki, GameDistribution, Playgama, others) | Revenue model, **exclusivity terms**, payout minimum, payout method, engine/SDK support (e.g. Unity WebGL SDK) |
| In-app platforms (YouTube Playables, TikTok Minis, others) | Who can join (individual vs verified business), runtime requirements, monetization status |
| Publishers | Which accept outside prototypes, what they test (CPI, D1, playtime), how to submit |
| Ad monetization | Current ad network/mediation onboarding, payout minimums |

Flag any lock-in (for example, multi-year web exclusivity) **before** the user commits.

## Step 2 — Pick a launch sequence

Default order, adjusted to the profile:

1. **Start slow clocks now.** If a store account has a waiting period or a testing requirement, open the account and start the closed test with any small build on day 1. Recruit more testers than the minimum, because dropouts reset the clock.
2. **Web first.** Ship to a non-exclusive web portal. It costs nothing, the review is fast, it produces real play data, and it gets the release pipeline working end to end.
3. **Mobile next.** Use the same build plus a mobile ad SDK. Release on the store whose account and testing rules are already satisfied.
4. **Pitch publishers in parallel** once early metrics meet their published targets (see `tracking-game-metrics`). They pay for marketability tests.
5. **Add the second store, mediation and IAP** once revenue justifies the fee and the work.

## Step 3 — Organic growth engine (no ad spend)

- **Daily short videos.** Post the same clip to TikTok, Reels and Shorts. Movement in the first second, a text hook, the payoff before the process ("proof-first"). Devlog clips count too.
- **In-game sharing.** Use a result card (daily-puzzle style), a 5-second timelapse of the finished level, or a before/after. Every player becomes a distribution channel.
- **Store page basics.** Icon readable at small size, a first screenshot that shows the payoff, a short video, and keywords in the title and short description.
- **Seasonal reskins** on fixed dates (holidays, local festivals) give a reason to post and an update to ship.
- **Build a creative bank.** Today's organic clips become tomorrow's Spark Ads and paid creatives.

## Step 4 — Monetization setup (minimum viable)

- Rewarded ads at natural "want" moments (retry, +slot, hint, booster) and interstitials only at level breaks, with **none in the first few levels**.
- A no-ads IAP once the game is on a store with IAP.
- Track ad impressions per DAU by format so `tracking-game-metrics` can estimate ARPDAU.

## Step 5 — When to spend

Spend only when the next step needs it. Use the profile's budget rule and the decisions from `tracking-game-metrics`:
- Before validated retention, spend only on tools or assets that save build time (sounds, fonts, generation credits). **Not on ads**, because tiny ad budgets can't measure CPI reliably.
- After SMALL PAID TEST or SCALE decisions, spend capped amounts with a stop-loss.

## Output

Write a launch plan: verified terms table (with sources) → chosen sequence with dates → organic plan (posting cadence, 3 hook ideas) → monetization placements → spend rules. Save it as `reports/YYYY-MM-DD-launch-<slug>.md`.

## Common mistakes

| Mistake | Fix |
|---|---|
| Quoting fees or revenue shares from memory | Verify live and cite. |
| Signing a portal exclusivity deal by default | Compare exclusive vs non-exclusive, and default to non-exclusive for a first game. |
| Waiting until the game is "done" to open store accounts | Start waiting periods and test clocks on day 1. |
| Spending a tiny budget on ads "to see what happens" | It can't produce reliable CPI. Use publisher tests or organic data. |
| Aggressive interstitials from level 1 | They hurt retention and ratings. Hold back early, reward voluntarily. |
