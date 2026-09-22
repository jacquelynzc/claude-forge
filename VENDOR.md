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
| computer-commander | https://github.com/wonderwhy-er/DesktopCommanderMCP.git | v0.2.51 (tag) | re-cloned from upstream 2026-09-22 |

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

## computer-commander

Imported 2026-09-22. Unlike the other four, this tree was re-cloned from
upstream at the `v0.2.51` tag rather than copied from the plugin cache,
because what was running was `npx -y @wonderwhy-er/desktop-commander@latest`
— an unpinned package resolved fresh from the npm registry on every app
launch, declared by a marketplace plugin whose manifest syncs from Anthropic
and overwrites local edits. There was no local copy worth preserving.

### What runs

The `mcpServers` block in `computer-commander/.claude-plugin/plugin.json`
runs `node mcp-vendor/dist/index.js` off local disk. No npx, no registry lookup, no version resolution at launch.

### Local patch

`patches/0001-disable-telemetry-and-remote-flags.patch` is applied to the
vendored source and is the reason this fork exists. It disables, at the
source rather than by config flag:

| Target | Upstream behaviour | After patch |
|---|---|---|
| `capture()` | POSTs GA4 events to telemetry.desktopcommander.app | returns immediately |
| `captureBase()` | same, secondary path | returns immediately |
| `isTelemetryDisabledByEnv()` | reads an env var | always true |
| `FeatureFlags.fetchFlags()` | pulls desktopcommander.app/flags/v2/production.json on every start | returns immediately; cached/default flags only |

The feature-flag fetch mattered as much as the telemetry: it let upstream
change this server's behaviour (A/B experiments, onboarding injection, UI
previews) remotely, after install, without a version bump.

`config.telemetryEnabled` is also set to false, but that is belt-and-braces —
a flag the vendor's own code decides whether to honour is not a control.

`src/remote-device/` still contains a client for mcp.desktopcommander.app.
It is dormant: it only activates when the server is spawned through the
remote-device wrapper with `DC_REMOTE_DEVICE=true`, which `.mcp.json` does
not do. Left in place so the diff against upstream stays small. If that
changes upstream, the updater's diff will show it.

### Dependencies

`mcp-vendor/node_modules/` **is** committed, following the ui-craft precedent:
production dependencies only, 243 MB, 22k files, no single file over 50 MB.
The npm registry is never contacted at runtime or at install. `.gitignore` in
`computer-commander/` excludes `node_modules/`, so the tree is staged with
`git add -f` — same arrangement as ui-craft.

Dependencies were installed with `npm ci --omit=dev --ignore-scripts`, which
pins every transitive package to an exact version and sha512 integrity hash
and runs no install scripts. `dist/` is committed too, so what actually
executes is reviewable in git rather than produced by a build you have to
trust.

Install scripts are skipped, so `@vscode/ripgrep` never downloads its
binary. `src/utils/ripgrep-resolver.ts` falls back to the system `rg`
at /opt/homebrew/bin/rg.

Each update commits a fresh 243 MB snapshot. Update deliberately, not
routinely.

### Pruned

`1080_60.mp4` (50 MB), `testemonials/`, `screenshots/`, `header.png`,
`logo.png`, `icon.png` — marketing assets with no runtime role. The updater
prunes the same paths from upstream before diffing, so they never appear as
changes.

### Updating

    scripts/update-computer-commander.sh                    # report only
    scripts/update-computer-commander.sh v0.2.60 --apply    # update, patch, rebuild, smoke-test

The updater refuses to apply if a patch no longer applies cleanly, and fails
if `LOCAL FORK PATCH` is missing from the rebuilt `dist/`. A half-patched
tree that silently re-enables telemetry is the failure mode it exists to
prevent. It never commits.

### Verified at import

`initialize` + `tools/list` over stdio returns 26 tools. All four patches
confirmed present in the emitted JavaScript, not only the TypeScript source.

### Renamed from desktop-commander

Renamed to `computer-commander` on 2026-09-22. Anthropic ships a synced
plugin named `desktop-commander`. With that name, this fork was hidden from
the marketplace add list and never loaded, while the other four plugins in
this marketplace loaded normally. Everything on disk was correct - installed,
enabled, `.in_use` marker set, `dist/index.js` and `node_modules` present -
so a name clash was the only remaining explanation.

Renamed everywhere: directory, plugin manifest `name`, marketplace entry, and
the MCP server key in `.mcp.json`. Tools are prefixed `computer-commander`.
The marketplace entry is a fresh one rather than an edit of the old, and the
old entry was removed.

The vendored upstream is unchanged and still Desktop Commander v0.2.51.

### Why mcpServers is inline

The server is declared in the `mcpServers` block of `plugin.json`, not in a
standalone `.mcp.json`. Both are valid, but inline is the form Anthropic's own
synced desktop-commander plugin used, and that one demonstrably loaded in
Cowork. While chasing the plugin not loading, matching the known-good shape
exactly removed a variable. The old standalone file is kept at the repo root
as `computer-commander.mcp.json.retired`.

### Server identity patch

`patches/0002-rename-server-identity.patch` changes the two identity
declarations in `src/server.ts` - the `Server` constructor and the
`serverInfo` block - from `desktop-commander` to `computer-commander`.

The plugin, marketplace entry and MCP server key were already renamed, but the
server still announced itself as `desktop-commander` over the wire. If Cowork
deduplicates by the announced name rather than the plugin name, the clash with
Anthropic's synced plugin would have survived the rename.

The other `desktop-commander` strings in that file are deliberately left
alone: they compare against the CLIENT name (`desktop-commander-app`,
`desktop-commander-client`) and gate behaviour on who is connecting. Changing
them would alter logic, not identity.

`dist/server.js` was edited to match rather than rebuilt, because the vendored
tree carries production dependencies only and has no `tsc`. The updater
rebuilds from patched source, so the two stay in sync from the next update on.

### One build, two clients

`plugin.json` points at an absolute path in this repo rather than
`${CLAUDE_PLUGIN_ROOT}`:

    /Users/rude/dev/claude-forge/computer-commander/mcp-vendor/dist/index.js

Cowork and Claude Code both install this plugin. With `${CLAUDE_PLUGIN_ROOT}`
they ran different copies - Cowork the working tree, Claude Code its own cache
copy under ~/.claude/plugins/cache/ - and the cache copy kept serving old code
after an update until it was reinstalled. Same tool names, different builds, no
warning. The absolute path makes the working tree the single source.

Cost: this repo is now load-bearing. Move or delete it and both clients lose
the server. Rebuild the path with DC_MAC_REPO_ROOT if it ever moves.

`mcp-vendor/node_modules` and `mcp-vendor/dist` are no longer committed - see
below.

### Dependencies and build output are not committed

`mcp-vendor/node_modules/` and `mcp-vendor/dist/` are gitignored and untracked.
They were committed initially, following the ui-craft precedent, but the
absolute path in `plugin.json` means nothing executes the marketplace cache
copy any more - it was ~250 MB of dead weight per install, and a fresh 250 MB
snapshot in git per update.

What IS committed: the full patched `src/`, `package-lock.json`, and the patch
files. That is enough to reproduce the exact build.

A fresh clone therefore has no runnable server. Run:

    scripts/bootstrap-computer-commander.sh

It installs from the pinned lockfile with `--ignore-scripts`, compiles,
prunes to production dependencies, verifies all three patches survived into
`dist/`, and smoke-tests over stdio.

Note that `git rm --cached` stops future tracking but leaves the old blobs in
history, so the pack does not shrink retroactively. Rewriting history with
git-filter-repo would reclaim it and require a force-push.
