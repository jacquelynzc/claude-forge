# Assumption Classification

Every Common Ground premise or constraint has independent provenance and status.

## Provenance

### STATED

Explicitly established by the user or authoritative source.

```text
STATED: Client must own the repository.
```

Do not reinterpret clear statements merely because another approach seems better.

### INFERRED

Supported by project evidence but not explicitly stated.

```text
INFERRED: Preview speed is prioritized over per-lead customization.
```

State the evidence.

### ASSUMED

Currently relied upon without enough evidence.

```text
ASSUMED: Five-page sites are the default deliverable.
```

Use sparingly. Material assumptions should be surfaced for validation.

### UNCERTAIN

Evidence is missing, weak, or conflicting.

```text
UNCERTAIN: Preview sites materially increase response rate.
```

Do not resolve uncertainty by guessing.

### RECONSTRUCTED

A historical relationship inferred from present evidence rather than directly documented.

```text
RECONSTRUCTED: Theme limitations likely contributed to the move toward reusable parts.
```

Useful for reasoning maps, but not equivalent to known history.

## Status

### ESTABLISHED

Supported strongly enough to rely on during work.

Prefix: `E-`

### WORKING

Current operating premise that may change.

Prefix: `W-`

### OPEN

Unresolved and potentially consequential.

Prefix: `O-`

## Independence

Provenance and status are separate.

Valid combinations include:

```text
E-001 · STATED
E-002 · INFERRED
W-003 · INFERRED
W-004 · ASSUMED
O-005 · UNCERTAIN
O-006 · RECONSTRUCTED
```

Do not mechanically promote `STATED` to `ESTABLISHED` if later evidence contradicts it.

When status changes, preserve numeric identity:

```text
W-003 → E-003
W-004 → O-004
O-005 → W-005
```

## Materiality

Track an item when changing it could alter:

- architecture;
- product behavior;
- scope;
- strategy;
- deliverable;
- user experience;
- significant implementation;
- downstream decisions.

Do not fill the ledger with trivial observations.

## Decisions

Consequential decisions use `D-###`.

Decision states:

- `ACTIVE`
- `SUPERSEDED`
- `REJECTED`
- `OPEN`

The `D-` prefix remains stable regardless of lifecycle.

Distinguish:

- **Alternative** – genuinely considered.
- **Rejected** – explicitly ruled out.
- **Superseded** – previously active, later replaced.

Do not infer “rejected” merely because another option was chosen.

## Goals

Material project goals use `G-###`.

Goals retain their IDs even when achieved, changed, or no longer primary.

## Evidence

Attach concise evidence pointers when practical:

```text
Evidence:
- docs/ARCHITECTURE.md
- package.json
- user statement
- D-004
```

Never fabricate quotes, dates, files, or historical rationale.

If evidence proves only what exists now, it does not automatically prove why it was chosen.

## Classification test

Before saving an entry ask:

1. What exactly is being claimed?
2. What evidence supports it?
3. Is that evidence current?
4. Does it establish fact, inference, assumption, or uncertainty?
5. How materially would work change if this were wrong?

When uncertain, classify downward rather than manufacturing certainty.
