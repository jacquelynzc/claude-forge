# Reasoning Graph

`/common-ground --graph` shows how the project arrived at its current state.

It is read-only.

A truthful incomplete history is better than an invented complete one.

## Model

Default reasoning spine:

```text
GOAL → DECISION → CHOSEN PATH → DECISION → IMPLEMENTATION
                 ↘ ALTERNATIVE
```

Node types:

- `ROOT` – task/goal
- `DECISION` – meaningful fork
- `CHOSEN` – selected path
- `ALTERNATIVE` – genuinely considered path
- `REJECTED` – explicitly ruled-out path
- `SUPERSEDED` – formerly active path later replaced
- `UNCERTAIN` – unresolved path/question
- `IMPLEMENTATION` – concrete result

Do not invent a decision node merely to explain an implementation.

Unknown rationale may remain unknown.

## Traceability

Important nodes may reference Common Ground IDs:

```text
G-001
E-004
W-007
O-011
D-015
```

Use IDs only when they help connect the graph to canonical ground.

For E/W/O entries, the numeric portion is permanent while the prefix may change with status.

Do not clutter every node with an ID when traceability adds no value.

## Evidence

Reconstruct from:

1. canonical Common Ground
2. authoritative project docs
3. code/config/history
4. current conversation evidence
5. cautious reconstruction

Never fabricate quotes, dates, alternatives, or causality.

Current architecture proves what exists, not necessarily why it exists.

## Relationships

Solid edge = documented/supported relationship.

Dashed edge = reconstructed relationship.

Examples:

```text
A -->|chosen| B
A -.->|reconstructed| B
OLD -->|superseded by| NEW
D -->|considered| ALT
D -->|rejected| X
```

Distinguish:

- considered ≠ rejected;
- rejected ≠ superseded;
- correlation ≠ causality.

Use chronological order when known.

## Source tags

Where useful:

```text
[stated]
[inferred]
[assumed]
[uncertain]
[reconstructed]
```

No numerical confidence weights.

## Layout

Default to `flowchart LR`.

Keep one clear reasoning spine with meaningful branches.

Prefer ≤25 nodes. For larger histories, create an overview plus detail sections.

Use short labels.

Decision nodes should visually read as forks.

Suggested styling:

```text
Decision       yellow
Chosen         green
Alternative    gray
Rejected       muted/dashed
Superseded     muted violet
Uncertain      orange
Implementation blue
```

## Rendering

The deliverable is a rendered visual artifact, not Mermaid source.

Preferred output:

```text
~/.claude/common-ground/{project}/REASONING.html
```

Use Mermaid or another available renderer.

The HTML should contain:

- rendered graph;
- title;
- compact legend;
- responsive/scrollable canvas;
- embedded source for reproducibility.

Open it when possible; otherwise return the exact path.

If the environment can directly produce another reliable rendered visual artifact, that is acceptable.

Never treat raw Mermaid in chat as successful rendering.

## Mind Map

If explicitly asked for a mind map, render conceptual relationships instead of chronology:

```text
Project
├── Goals
├── Premises
├── Decisions
├── Current System
├── Open Questions
└── Historical Alternatives
```

`--graph` defaults to reasoning history.

## Updates

If a decision changes:

1. mark the old path `SUPERSEDED`;
2. mark the new path active/chosen;
3. preserve real downstream history;
4. regenerate.

If an alternative is explored later, expand that branch.

Never rewrite the graph as though superseded choices never existed.

## Quality Gate

Before returning verify:

- the goal is clear;
- known decisions are traceable;
- rationale is shown only when supported;
- alternatives were genuinely considered;
- rejected and superseded paths are distinct;
- reconstructed relationships are visibly different;
- open uncertainty is visible;
- the artifact renders visually.

If rendering fails, fix it before returning.

## Response

```text
Reasoning map updated:
~/.claude/common-ground/{project}/REASONING.html
```

Do not paste graph source unless requested.
