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
