---
name: writing-game-agent-briefs
description: Use when a game idea has been chosen and needs to be handed to coding agents (e.g. Unity via MCP, Godot, web) as a build spec, project brief, prototype plan, or task breakdown.
---

# Writing Game Agent Briefs

Turn one chosen idea into a brief that a coding agent with **no other context** can build and verify. One brief per game project. Each brief targets the **smallest build that tests the idea's hypothesis**.

**REQUIRED BACKGROUND:** `using-game-trend-skills`.

## Before writing

- You need the idea card (from `brainstorming-game-ideas`) or the evaluation (from `evaluating-game-ideas`). If neither exists, write the core loop in one sentence and confirm it with the user.
- Read the creator profile for engine, platforms and tooling. Don't choose an engine or SDK the profile doesn't use.
- Ask about anything that changes the build and that you can't infer: orientation, target platforms, art source. Ask in one message.

## Brief structure

Save the brief as `briefs/<game-slug>.md`, with these sections in this order:

1. **Goal & hypothesis.** "We believe {loop + twist} will reach {metric targets from tracking-game-metrics}. This build exists to test that."
2. **Non-goals.** Systems deliberately left out of this build (accounts, backend, multiplayer, shop UI, localization…). Agents add what they aren't told to skip, so list the skipped items explicitly.
3. **Core loop spec.** Input → action → feedback → win → lose, with exact rules and numbers (grid size, slot count, timers). Ambiguous rules lead to wrong builds.
4. **Controls & feel.** Input mapping, plus the "juice" list: the satisfying moment (particles, sound, haptics, camera) that the muted 3-second clip depends on.
5. **Content pipeline.** Build this **first, as a separate tool**: the generator (procedural levels, image-to-level, etc.), a solver/validator that proves each level is solvable, a difficulty metric, and an export format. The acceptance check is "generates N levels, all validated, with difficulty rising across them".
6. **Systems, in build order.** Numbered, each with a one-line purpose. Systems go in only if the hypothesis or monetization needs them.
7. **Monetization hooks.** Rewarded and interstitial call sites behind one small interface (`ShowRewarded(placement, onReward)`), stubbed in the MVP. The real SDK goes in at launch (see `launching-on-zero-budget`).
8. **Analytics events.** The minimum set: `level_start`, `level_complete`, `level_fail` (with level id and time), `booster_used`, `ad_rewarded_shown`, `ad_interstitial_shown`, `session_start`, `session_end`. Stub them behind one interface.
9. **Tech constraints.** Engine version, target platforms (e.g. WebGL + Android), orientation, a performance budget (frame rate on a low-end Android device, build size limit for web portals), no new dependencies unless named.
10. **Milestones with acceptance criteria.** Each milestone is something a person can check:
    - M0 content tool: N validated levels generated
    - M1 graybox loop: a full level is playable start → win/lose
    - M2 juice + 20–50 levels + stubs: a muted 10-second capture looks like an ad
    - M3 build: WebGL and/or Android build runs on target devices within the performance budget
11. **Verification.** How the agent proves each milestone: automated tests for the generator and solver, a play-mode test for win/lose, a build command, a screenshot or capture.
12. **Open questions.** Anything unresolved, each with the default to use if nobody answers.

## Splitting into projects

If the user runs separate agent projects, give each brief **its own repo/project and its own slug**. Shared code (ad and analytics interfaces, level tools) goes into a small separate package brief only after a second game needs it.

## Common mistakes

| Mistake | Fix |
|---|---|
| "Make a game like X" | Spell out the exact rules and numbers. The agent has never seen X. |
| Content made by hand inside the game build | Generator and solver come first, as a tool with tests. |
| Real ad/analytics SDKs in the prototype | Interfaces with stubs. Integrate at launch. |
| Milestones like "polish" | Every milestone has a check a person can run. |
| One mega-brief for several games | One brief per game. |
