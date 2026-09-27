---
name: common-ground
description: Maintain an evidence-backed ledger of the assumptions, constraints, decisions, uncertainties, and reasoning history a project currently rests on. Use when asked to establish common ground, inspect assumptions, audit drift, explain how a project arrived at its current approach, or visualize its reasoning history.
argument-hint: "[--list] [--check] [--graph]"
---

# Common Ground

Maintain shared project understanding without silently turning inference into fact.

## Commands

```text
/common-ground
/common-ground --list
/common-ground --check
/common-ground --graph
```

- default – surface and validate current ground
- `--list` – show saved ground
- `--check` – revalidate saved ground against current evidence
- `--graph` – render decision/reasoning history without mutating ground

Mode behavior: `COMMAND.md`.

## State

Store project state at:

```text
~/.claude/common-ground/{project}/
  COMMON-GROUND.md
  ground.index.json
  REASONING.html
```

`COMMON-GROUND.md` is human-readable.
`ground.index.json` is canonical structured state.
`REASONING.html` is generated visualization, not canonical state.

## Core rule

Every meaningful claim must distinguish:

1. provenance – where it came from;
2. status – how settled it is.

Never promote inference into established ground merely because it sounds reasonable.

Never reconstruct a clean history when evidence only supports the current state.

## Provenance

- `STATED` – explicitly established by user/source
- `INFERRED` – strongly supported by evidence
- `ASSUMED` – relied upon without sufficient confirmation
- `UNCERTAIN` – conflicting or insufficient evidence
- `RECONSTRUCTED` – historical relationship inferred after the fact

## Status

- `ESTABLISHED` – safe to rely on
- `WORKING` – current operating premise, revisable
- `OPEN` – unresolved; do not silently depend on it

Do not use numerical confidence scores.

## Evidence priority

Prefer:

1. explicit current user statement
2. authoritative project docs/config
3. current code/state
4. persisted Common Ground
5. conversation context
6. cautious inference

Newer explicit evidence may supersede older ground.
When sources conflict, surface the conflict.

## IDs

Every persistent entry receives a permanent number and semantic prefix:

```text
E-001   established premise/constraint
W-002   working premise/constraint
O-003   open premise/question
D-004   decision
G-005   goal
```

Prefixes:

- `E` – ESTABLISHED
- `W` – WORKING
- `O` – OPEN
- `D` – decision
- `G` – goal

The number is permanent identity.
If a premise changes status, change only its prefix:

```text
W-002 → E-002
W-006 → O-006
O-009 → E-009
```

Never reuse or renumber an existing number.

Decisions retain `D-###`; their lifecycle is stored separately as `ACTIVE`, `SUPERSEDED`, `REJECTED`, or `OPEN`.

Goals retain `G-###`.

## Mutations

Default `/common-ground` may add/update ground after validation.

`--check` may update statuses when evidence clearly changed; surface material changes.

`--list` is read-only.

`--graph` is read-only. It may reconstruct relationships for visualization but must not silently write those reconstructions into canonical ground.

See:

- `COMMAND.md`
- `references/assumption-classification.md`
- `references/file-management.md`
- `references/reasoning-graph.md`
