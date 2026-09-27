# Common Ground – Standalone Claude Skill

A tiny standalone version of the Common Ground workflow: assumption ledger + decision history + reasoning/mind maps, without installing a large skill bundle.

## Files

```text
common-ground/
├── .claude-plugin/plugin.json
├── README.md
├── LICENSE-NOTICE.md
└── skills/common-ground/
    ├── SKILL.md
    └── references/
        ├── assumption-classification.md
        ├── file-management.md
        └── reasoning-graph.md
```

## Use

Installed as a plugin from the claude-forge marketplace. The skill is exposed as
`/common-ground:common-ground` and also fires on natural-language requests.
`SKILL.md` is the authoritative workflow.

Supported modes:

```text
/common-ground:common-ground
/common-ground:common-ground --list
/common-ground:common-ground --check
/common-ground:common-ground --graph
```

The standalone `COMMAND.md` wrapper was dropped: a command and a skill with the
same name in one plugin collide, and its only extra, `argument-hint`, now lives
in the skill frontmatter.

## What it stores

By default, project state lives outside the repo:

```text
~/.claude/common-ground/{project-id}/
├── COMMON-GROUND.md
├── ground.index.json
└── REASONING.mermaid
```

See `references/file-management.md` for the complete persistence model.
