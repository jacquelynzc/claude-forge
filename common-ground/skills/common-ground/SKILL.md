---
name: common-ground
description: Surface, validate, persist, and visualize the assumptions and decision history underlying the current project. Use when asked to show assumptions, establish common ground, audit what Claude is treating as true, check whether prior premises still hold, explain how the project reached its current approach, or generate a reasoning/mind map. Supports default review plus --list, --check, and --graph modes.
argument-hint: "[--list] [--check] [--graph]"
---

# Common Ground

Make the project's hidden premises and reasoning history inspectable before they quietly harden into requirements.

This skill maintains two complementary artifacts:

- **Assumption ledger** – what is currently being treated as true, where it came from, and how confidently it should be used.
- **Reasoning graph** – how goals, evidence, assumptions, decisions, alternatives, and unresolved questions led to the present approach.

## Modes

Interpret the user's request as one of four modes:

| Invocation | Behavior |
|---|---|
| `common-ground` | Surface assumptions, validate them with the user, adjust confidence, then persist |
| `common-ground --list` | Read-only view of tracked assumptions |
| `common-ground --check` | Revalidate existing assumptions against current project evidence |
| `common-ground --graph` | Generate/update a Mermaid reasoning map |

Natural-language requests such as “show me what we’re assuming,” “how did we get here?”, “mind map this reasoning,” or “check our premises” should activate the corresponding mode without requiring literal flags.

## References

Load only what is needed:

| Need | File |
|---|---|
| Classify provenance and confidence | `references/assumption-classification.md` |
| Identify project and persist state | `references/file-management.md` |
| Build reasoning/mind map | `references/reasoning-graph.md` |

## Project identity

Before reading or writing Common Ground state:

1. Try `git remote get-url origin`.
2. Normalize the remote into a stable project ID.
3. If there is no remote, use the absolute working directory and normalize it as a local project ID.
4. Never merge state across distinct repositories merely because they share a name.

See `references/file-management.md`.

## Default workflow

### 1. Recover existing ground

Read the existing machine index first if present. Treat it as prior state, not unquestionable truth.

### 2. Inspect the present

Use the evidence actually available in the current session and repository. Relevant sources include:

- explicit user statements and corrections;
- current conversation decisions;
- project instructions such as CLAUDE.md;
- package/config files;
- architecture and directory structure;
- representative implementation patterns;
- tests and scripts;
- git history when it materially explains a decision;
- the existing Common Ground ledger.

Do not exhaustively scan the repository when a small number of authoritative files establishes the point.

### 3. Surface assumptions

Identify premises that materially affect current or future work. Do not clutter the ledger with trivial observations.

For each item capture:

- concise title;
- full premise;
- provenance type: `stated`, `inferred`, `assumed`, or `uncertain`;
- confidence tier: `ESTABLISHED`, `WORKING`, or `OPEN`;
- evidence/source;
- scope/context;
- dependencies or downstream decisions when relevant.

Distinguish **facts** from **assumptions**. A verified fact may still belong in Common Ground when it is an important premise, but its evidence should make that clear.

### 4. Show the user before persisting

Present a compact review grouped by tier or topic. Highlight especially:

- high-impact assumptions;
- assumptions inherited from old conversation context;
- premises contradicted by current code;
- things Claude supplied as defaults rather than the user choosing them;
- unresolved choices with downstream consequences.

Ask the user to confirm/correct only where their input is genuinely needed. Do not make them approve obvious repository facts one by one.

### 5. Reconcile

Apply corrections without erasing provenance.

- Types record **how the item originally entered the reasoning** and are immutable.
- Tiers record **how much confidence to place in it now** and may change.
- Superseded items are archived rather than silently deleted.
- Contradicting evidence demotes or archives an item; it does not rewrite history.

### 6. Persist

Write both:

- `~/.claude/common-ground/{project_id}/ground.index.json` – source of truth;
- `~/.claude/common-ground/{project_id}/COMMON-GROUND.md` – generated human-readable view.

Preserve history and timestamps. See `references/file-management.md`.

## `--list`

Read existing state and display it without modification.

Show:

- project and last update;
- ESTABLISHED premises;
- WORKING premises;
- OPEN questions/premises;
- stale or contradicted items if any.

If no ledger exists, say so and recommend running the default mode. Do not invent one in list mode.

## `--check`

Re-evaluate tracked premises against the current repository and conversation.

For each materially changed item classify the result as:

- **still supported**;
- **weakened**;
- **contradicted**;
- **cannot verify**;
- **superseded**.

Automatically update evidence-backed changes that are objective. Ask the user before changing a premise whose validity depends on intent, preference, business policy, or an unresolved choice.

Update validation timestamps only for items actually checked.

## `--graph`

Create a Mermaid map of the reasoning that led to the current approach.

The graph should answer:

1. What was the root goal/problem?
2. What evidence or constraints mattered?
3. What assumptions entered the reasoning?
4. What decisions were made?
5. What alternatives were considered or implicitly rejected?
6. What downstream decisions depend on earlier choices?
7. Where is uncertainty still open?

Do **not** fabricate a historical branch merely to make the graph look complete. If an alternative was reconstructed rather than actually discussed, label it `reconstructed alternative`.

Embed the current graph in `COMMON-GROUND.md`. Also write `REASONING.mermaid` inside the Common Ground project directory for easy reuse. Do not write generated state into the user's repository unless explicitly requested.

See `references/reasoning-graph.md`.

## Important behavior

- Surface assumptions; do not silently add new ones while auditing old ones.
- Prefer evidence over confidence language.
- Preserve corrections and abandoned paths because they explain why the project looks the way it does.
- Never treat an old user statement as permanently binding when newer evidence contradicts it.
- Never infer user intent from code when the distinction affects product/business behavior; mark it OPEN.
- Keep the ledger compact enough to remain useful. Archive stale detail.
- The reasoning graph is an audit aid, not a claim to expose private chain-of-thought. Represent observable premises, decisions, evidence, alternatives, and dependencies only.

## Completion

After a modifying run, report only the useful summary:

- number of active premises by tier;
- what changed;
- unresolved items that could materially alter work;
- saved state path;
- graph path when generated.
