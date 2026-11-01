# Game Trend Skills

A skill library that turns your coding agent into a market analyst and producer for simple games: it scans what's trending on mobile and web, scouts TikTok/Reels/Shorts for mechanics you can steal, brainstorms and scores game ideas against live market evidence, tracks your KPIs and tells you what to fix first, writes build briefs for coding agents, and plans a zero-budget launch. Built for solo devs and small teams who want to ship games that make money — every number is looked up live and cited, never recalled from memory.

## Skills

| Skill | When it triggers |
|---|---|
| `using-game-trend-skills` | Any conversation about games as a business: trends, ideas, KPIs, publishing, monetization |
| `scanning-game-trends` | "What's hot right now", a market overview, or a weekly/monthly insight report |
| `scouting-social-trends` | TikTok / Reels / Shorts / memes that could become a mechanic, theme, reskin or video format |
| `brainstorming-game-ideas` | You want new game ideas, a twist on a hit, or concepts that fit a small budget |
| `evaluating-game-ideas` | "Is this idea worth building?", compare to competitors, continue / pivot / kill |
| `tracking-game-metrics` | You share KPIs (D1, D7, CPI, ARPDAU…) and ask what to do — kill, iterate, pitch or scale |
| `writing-game-agent-briefs` | A chosen idea needs a build spec a coding agent can execute with no other context |
| `launching-on-zero-budget` | Publishing, monetizing or growing a game with little or no money |

## Workflow

The usual chain is **scan → scout → brainstorm → evaluate → brief → launch → track**. Any skill can be entered directly.

Along the way the library writes files into your project:

- `reports/YYYY-MM-DD-<type>.md` — trend reports, idea sets, evaluations
- `briefs/<game-slug>.md` — agent build briefs
- `metrics/<game-slug>.md` — an append-only metric log per game
- `game-trend-profile.md` — your constraints (budget, engine, team, markets)

## Principles

Every skill follows the same five rules:

1. **Live evidence only** — market numbers are searched and cited `(Source, Month YYYY)`, never stated from memory.
2. **State assumptions first** — the creator's budget, team, engine and markets are written down before any recommendation.
3. **Simplest game that tests the hypothesis** — scope a solo dev can ship in weeks; every system needs a reason tied to a metric.
4. **Every idea has a kill switch** — each recommendation names the metric and threshold that kills, iterates or scales it.
5. **Verdict first, in the user's language** — the decision opens the answer; the reasons follow.

## Install

Installation differs by harness. If you use more than one, install separately for each one.

### Claude Code

Register the marketplace and install the plugin:

```bash
/plugin marketplace add malicaki/game-trend-skills
/plugin install game-trend-skills@game-trend-skills
```

### Codex (CLI, IDE, and the ChatGPT desktop app)

```bash
codex plugin marketplace add malicaki/game-trend-skills
codex plugin add game-trend-skills@game-trend-skills
```

In the ChatGPT desktop app (Codex, or ChatGPT with Work on): after adding the marketplace, restart the app, open Plugins, pick the **Game Trend Skills** source and click **+** on Game Trend Skills. Start a new chat.

### ChatGPT (web Skills upload)

For eligible ChatGPT Business, Enterprise, Healthcare and Edu workspaces (subject to workspace settings):

1. Download the per-skill zips from the [latest GitHub Release](https://github.com/malicaki/game-trend-skills/releases/latest).
2. In ChatGPT: sidebar Plugins → Plugin Directory → **Skills** tab → **Create** → "Upload from your computer".
3. Upload `using-game-trend-skills.zip` first, then the other skills you want.

Uploads are scanned by ChatGPT and may show as "Needs Review". Each zip is self-contained — shared references (`sources.md`, `metrics-glossary.md`, `scoring-rubric.md`) are copied into the skills that cite them. To rebuild the zips locally: `node scripts/package-chatgpt.mjs`.

### Cursor

Install a plugin from the marketplace in Cursor Agent chat:

```text
/add-plugin game-trend-skills
```

Or use the manual-copy path below into your project or user skills directory.

### Devin CLI

```bash
devin plugins install malicaki/game-trend-skills
```

Update to the latest version with:

```bash
devin plugins update game-trend-skills
```

### Antigravity

```bash
agy plugin install https://github.com/malicaki/game-trend-skills
```

### Gemini CLI

```bash
gemini extensions install https://github.com/malicaki/game-trend-skills
```

Update later:

```bash
gemini extensions update game-trend-skills
```

### GitHub Copilot CLI

```bash
copilot plugin marketplace add malicaki/game-trend-skills
copilot plugin install game-trend-skills@game-trend-skills
```

### Universal (skills.sh)

```bash
npx skills add malicaki/game-trend-skills
```

### Manual copy

Copy `skills/*` into `~/.agents/skills/`, `~/.claude/skills/`, or a project-level `.devin/skills/` directory — whichever your agent reads. Or just copy `AGENTS.md` into your project; it routes to the skills on its own.

## What the plugin runs, sends and stores

- Instructions only: Markdown skills. No hooks, no MCP servers, no bundled executables, nothing runs on install.
- The skills ask your agent to use its own web search/fetch tools to read public market sources (charts, reports, store pages, platform docs). No data is sent to any service operated by this project.
- The agent writes plain Markdown files into your current project (`reports/`, `briefs/`, `metrics/`, `game-trend-profile.md`). Nothing is stored elsewhere.
- `scripts/` holds maintainer tools (`validate.mjs`, `package-chatgpt.mjs`) that run only when you run them yourself.

## Credits / inspiration

- [obra/superpowers](https://github.com/obra/superpowers) — multi-harness plugin packaging and install commands
- [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) — repo-as-marketplace install pattern
- [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills)

## Contributing

Each skill is `skills/<name>/SKILL.md` with a `name` matching the folder and a `description` that starts with "Use when". No benchmark values are hardcoded — skills look them up live. Run the validator before committing:

```bash
node scripts/validate.mjs
```

## License

MIT — see [LICENSE](LICENSE).
