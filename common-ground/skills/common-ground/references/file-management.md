# Common Ground State

## Location

```text
~/.claude/common-ground/{project}/
```

Files:

```text
COMMON-GROUND.md
ground.index.json
REASONING.html
```

The project key should be stable across sessions. Prefer repository/project identity over current directory name when available.

## Canonical state

`ground.index.json` is canonical.

`COMMON-GROUND.md` is the readable projection.

`REASONING.html` is generated and disposable.

Never treat graph reconstruction as canonical evidence.

## IDs

Every entry receives a unique permanent number.

Its prefix communicates semantic role or current status:

```text
E-###   established premise/constraint
W-###   working premise/constraint
O-###   open premise/question
D-###   decision
G-###   goal
```

For E/W/O entries, status changes preserve the number:

```text
W-014 → E-014
O-021 → W-021
```

`D-###` and `G-###` prefixes remain stable.

Never reuse a number, including numbers belonging to superseded or removed historical entries.

## Entry schema

```json
{
  "id": "W-001",
  "number": 1,
  "type": "premise",
  "text": "Reusable parts are the primary composition model.",
  "provenance": "INFERRED",
  "status": "WORKING",
  "decision_status": null,
  "evidence": ["project architecture"],
  "created": "ISO-8601",
  "updated": "ISO-8601"
}
```

`type` may be:

```text
goal
premise
constraint
decision
open_question
```

For decisions, `decision_status` may be:

```text
ACTIVE
SUPERSEDED
REJECTED
OPEN
```

The numeric `number` is permanent identity.

`id` is its current human-readable representation.

Add fields only when they provide durable value.

## COMMON-GROUND.md

Keep it readable and compact.

Recommended structure:

```markdown
# Common Ground

## Goals

### G-001
Produce believable $10k websites efficiently.

## Established

### E-002 · STATED
Client owns the repository.

## Working

### W-006 · INFERRED
Reusable parts are the primary composition model.

## Open

### O-011 · UNCERTAIN
Preview sites improve outbound response rates.

## Decisions

### D-003 · SUPERSEDED
Themes were the primary system.
Superseded by: D-007

### D-007 · ACTIVE
Use reusable parts as the primary composition system.
```

Do not turn it into a session transcript.

## Updates

When evidence changes:

- preserve numeric identity;
- update E/W/O prefix when status changes;
- update provenance/status/evidence;
- preserve meaningful decision history;
- update timestamps;
- regenerate `COMMON-GROUND.md`.

Do not delete superseded consequential decisions merely because they are no longer active.

Avoid preserving trivial churn.

## Conflicts

When new evidence conflicts with saved ground:

1. identify the conflict;
2. prefer stronger/newer authoritative evidence;
3. downgrade, update, or supersede the old entry;
4. preserve consequential history;
5. surface material changes.

Do not silently rewrite history.

## Read-only modes

`--list` does not mutate state.

`--graph` does not mutate state.

Graph-only reconstructed relationships remain graph-only unless separately validated through normal Common Ground workflow.

## Recovery

If one state file is missing:

- rebuild `COMMON-GROUND.md` from `ground.index.json`;
- if JSON is missing but Markdown exists, reconstruct cautiously and mark ambiguous fields;
- if both are missing, initialize new ground.

Never infer canonical state from `REASONING.html`.
