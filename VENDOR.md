# Vendor provenance

Imported 2026-08-06. Each tree is a verbatim copy of the version that was
installed and running at import time, taken from the local plugin cache
rather than re-cloned, so the bytes here are the bytes that were in use.

| Plugin | Upstream | Version | Imported from |
|---|---|---|---|
| ui-craft | https://github.com/educlopez/ui-craft.git | 1.0.0 | ~/.claude/plugins/cache/ui-craft/ui-craft/1.0.0/ |
| caveman | https://github.com/JuliusBrussee/caveman | commit 0d95a81d35a9 | ~/.claude/plugins/cache/caveman/caveman/0d95a81d35a9/ |
| superpowers | https://github.com/obra/superpowers.git | 6.1.1 | ~/.claude/plugins/cache/superpowers-dev/superpowers/6.1.1/ |
| humanizer | https://github.com/blader/humanizer.git | 2.8.2 | ~/.claude/plugins/cache/humanizer/humanizer/2.8.2/ |

humanizer was verified byte-for-byte against
~/.claude/plugins/.install-manifests/humanizer@humanizer.json at import.

Runtime artifacts (`.in_use/`, `.git/`) were excluded from the copy.

To review upstream changes, run scripts/check-upstream.sh. Nothing is pulled
automatically; applying an upstream change is a manual edit plus a commit,
and this table is updated to record the new fork point.

## ui-craft MCP server

`.mcp.json` runs the MCP server from `ui-craft/mcp-vendor/`, committed to this
repo and executed with `node` off local disk. The npm registry is never
contacted at runtime.

| | |
|---|---|
| Package | `ui-craft-mcp` |
| Version | 0.8.2 (pinned exactly, not a range) |
| Resolved | https://registry.npmjs.org/ui-craft-mcp/-/ui-craft-mcp-0.8.2.tgz |
| Integrity | sha512-c6/YAbJw5k0CuWT5XrDJCzt4/BEMLwmUjRtcVyBaaobzPGUNynxaHVrMsEcScfY/pFWBIjFmPPz0VJZ8rHxU0g== |
| Vendored | 2026-08-06 |
| Verified | initialize + tools/list returns 7 tools; score_ui and its anti-slop rules execute correctly |

This replaces the previous declaration `npx -y ui-craft-mcp`, which resolved
the package from the npm registry at every session start with no version pin
and no integrity check.

**Why the npm package and not `ui-craft/mcp/`.** The ui-craft repo vendors its
own MCP source at `ui-craft/mcp/`, but that source is version 0.2.0 and ships
only 4 of the 7 tools. The published package had drifted to 0.8.2, so `npx -y`
was running code that does not exist anywhere in the ui-craft repo. Vendoring
from `mcp/` would have silently dropped `route_task`, `check_fold`, and
`fold_candidates`.

`ui-craft/mcp/` is retained as part of the verbatim upstream import but is
**not** what runs. Do not point `.mcp.json` at it.

`mcp-vendor/node_modules/` is committed on purpose. `ui-craft/.gitignore` is an
upstream file that excludes `node_modules/`; it was left unmodified and the
vendored tree was staged with `git add -f` instead. Dependency updates go
through the same review path as everything else — see scripts/check-upstream.sh.
