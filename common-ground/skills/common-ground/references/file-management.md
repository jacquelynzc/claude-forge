# Common Ground File Management

## Storage

Persist Common Ground outside the repository by default:

```text
~/.claude/common-ground/
├── index.md
└── {project-id}/
    ├── COMMON-GROUND.md
    ├── ground.index.json
    ├── REASONING.mermaid
    └── archive/
        └── {timestamp}-{reason}.json
```

`ground.index.json` is the source of truth. Markdown and Mermaid are generated views.

## Project identification

### Preferred: git remote

Run:

```bash
git remote get-url origin 2>/dev/null
```

Normalize common forms:

```text
https://github.com/acme/app.git -> github.com/acme/app
git@github.com:acme/app.git     -> github.com/acme/app
```

Rules:

1. remove protocol/user transport syntax;
2. convert SSH `host:path` to `host/path`;
3. remove trailing `.git`;
4. sanitize only characters unsafe for the local directory structure.

### Fallback: absolute path

If there is no remote, use the absolute working directory and derive a stable local ID. Include enough path information to avoid collisions between unrelated projects with the same basename.

## Machine index schema

Use a compact schema such as:

```json
{
  "version": "1.1",
  "project_id": "github.com/acme/app",
  "project_name": "app",
  "created": "2026-09-27T12:00:00-04:00",
  "last_updated": "2026-09-27T12:00:00-04:00",
  "last_checked": null,
  "next_id": 4,
  "assumptions": [
    {
      "id": "A001",
      "title": "Short title",
      "type": "stated",
      "tier": "ESTABLISHED",
      "status": "active",
      "assumption": "Full premise",
      "source": "User explicitly required this in project instructions",
      "context": "Applies to preview generation",
      "created": "2026-09-27T12:00:00-04:00",
      "validated": "2026-09-27T12:00:00-04:00",
      "dependencies": ["D002"],
      "supersedes": null,
      "history": [
        {
          "date": "2026-09-27T12:00:00-04:00",
          "action": "created",
          "from_tier": null,
          "to_tier": "ESTABLISHED",
          "reason": "Explicit user requirement"
        }
      ]
    }
  ],
  "decisions": [
    {
      "id": "D002",
      "title": "Chosen implementation direction",
      "status": "chosen",
      "source": "Conversation and repository evidence",
      "depends_on": ["A001"],
      "alternatives": ["D003"],
      "created": "2026-09-27T12:00:00-04:00"
    }
  ],
  "archived": []
}
```

The `decisions` collection is optional until `--graph` or decision-history analysis needs it. Do not manufacture decisions solely to populate the schema.

## IDs

- Assumptions: `A001`, `A002`, ...
- Decisions: `D001`, `D002`, ...
- Questions/unknowns may use assumption IDs with type `uncertain`; avoid another ID namespace unless necessary.
- Never reuse IDs.

## Human-readable file

Generate `COMMON-GROUND.md` from the JSON source of truth.

Recommended shape:

```markdown
# Project Common Ground

**Project:** ...
**Project ID:** ...
**Last Updated:** ...
**Last Checked:** ...

## ESTABLISHED

### A001: Title
- **Type:** stated
- **Premise:** ...
- **Evidence:** ...
- **Context:** ...
- **Validated:** ...

## WORKING
...

## OPEN
...

## Superseded / Archived
...

## Decision History
...

## Reasoning Graph
```mermaid
...
```

## History
...
```

Do not manually maintain duplicated facts in Markdown that are absent from JSON.

## Global registry

Maintain `~/.claude/common-ground/index.md` as a lightweight registry:

```markdown
# Common Ground Projects

| Project | ID | Active premises | Open | Last checked |
|---|---|---:|---:|---|
| app | github.com/acme/app | 12 | 2 | 2026-09-27 |
```

This is convenience metadata, not authoritative project state.

## Safe update procedure

For every modifying operation:

1. Read `ground.index.json` if it exists.
2. Validate that it parses.
3. Preserve existing IDs/history.
4. Apply additions, tier changes, supersessions, or evidence updates.
5. Update timestamps narrowly – do not mark unchecked items as checked.
6. Write valid JSON.
7. Regenerate `COMMON-GROUND.md` from JSON.
8. Regenerate `REASONING.mermaid` if graph state changed.
9. Update global registry.

When practical, write to a temporary file then replace the destination to reduce corruption risk.

## Archiving

Before a destructive schema migration or recovery operation, save the prior machine index under `archive/` with timestamp and reason.

Normal tier changes do not require a full archive because each item carries history.

Superseded assumptions should leave the active list but remain available in `archived` with:

- original ID;
- full original provenance;
- date archived;
- reason;
- replacement ID when applicable.

## Corruption / mismatch handling

### JSON corrupt, Markdown readable

Do not silently overwrite. Preserve the broken JSON in `archive/`, reconstruct conservatively from Markdown, and tell the user recovery occurred.

### Markdown missing, JSON valid

Regenerate Markdown.

### Mermaid missing

Regenerate only when graph mode is requested or graph state already exists.

### Permission denied

Report the exact path and do not pretend persistence succeeded.

## Privacy and repository hygiene

- Default storage is under `~/.claude`, not the repository.
- Do not persist secrets, credentials, tokens, raw private keys, or unnecessary personal data.
- Evidence should identify the source sufficiently for audit without copying sensitive content.
- Do not commit Common Ground state unless the user explicitly asks to make it project-shared.
