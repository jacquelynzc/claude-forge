# /common-ground

Surface and maintain the assumptions, constraints, decisions, and unresolved questions the current project rests on.

## Modes

### `/common-ground`

Inspect current evidence plus saved ground.

Surface only material items.

For each item show:

```text
W-012 · INFERRED
Reusable parts outperform rigid themes.
Evidence: current engine architecture + project docs
```

Prioritize:

- assumptions affecting current work;
- constraints;
- important decisions;
- contradictions;
- uncertainty that could change direction.

Ask for correction or confirmation where it materially matters.

Do not interrogate the user about obvious or low-impact facts.

After validation, persist changes.

### `/common-ground --list`

Read saved ground only.

Group by:

```text
ESTABLISHED
WORKING
OPEN
DECISIONS
GOALS
```

Keep output compact.

Do not re-analyze or mutate state.

### `/common-ground --check`

Revalidate saved entries against current evidence.

Classify each material change:

```text
UNCHANGED
SUPPORTED
WEAKENED
CONTRADICTED
SUPERSEDED
STALE
```

Focus on drift, not restating the entire ledger.

For changed entries show:

```text
D-008 · SUPERSEDED
Was: Use themes as primary site system.
Now: Parts/component system is canonical.
Evidence: ...
```

Update canonical state only when supported by evidence.

When an E/W/O entry changes status, preserve its number and update its prefix.

Do not convert absence of evidence into contradiction.

### `/common-ground --graph`

Load `references/reasoning-graph.md`.

Render the reasoning and decision history behind the current project.

This mode is read-only.

Do not create, promote, or validate canonical assumptions while graphing.

If history is incomplete, show incomplete history.

Never invent causality or rejected alternatives to make the graph coherent.

Return or open the rendered artifact rather than dumping Mermaid source.

## General behavior

Prefer evidence over narrative coherence.

Distinguish:

- current fact from historical reasoning;
- decision from implementation;
- considered alternative from rejected path;
- superseded decision from rejected alternative;
- documented causality from reconstructed causality.

If a rationale is unknown, leave it unknown.

A truthful incomplete model is better than a complete fictional one.
