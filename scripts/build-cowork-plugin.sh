#!/usr/bin/env bash
# Build the thin Cowork .plugin package for computer-commander.
#
# Cowork installs plugins from a .plugin zip delivered in chat, and chat
# uploads are capped at 30 MB. The full plugin is ~56 MB zipped because the
# vendored node_modules is committed, so the Cowork package ships only the
# manifest, skills and an .mcp.json that points at the build in THIS repo on
# THIS machine. Claude Code installs the full tree from the git marketplace
# and uses ${CLAUDE_PLUGIN_ROOT} instead - that copy is unaffected.
#
# Consequence: moving or deleting this repo breaks the Cowork plugin. Updates
# need no reinstall - run the updater, restart Claude Desktop.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$REPO_ROOT/computer-commander"
MAC_ROOT="${DC_MAC_REPO_ROOT:-/Users/rude/dev/claude-forge}"
OUT="${1:-$REPO_ROOT/../computer-commander.plugin}"
BUILD="$(mktemp -d)"
trap 'rm -rf "$BUILD"' EXIT

mkdir -p "$BUILD/.claude-plugin"
cp "$SRC/.claude-plugin/plugin.json" "$BUILD/.claude-plugin/"
cp -R "$SRC/skills" "$BUILD/skills"
cp "$SRC/README.md" "$BUILD/README.md"

cat > "$BUILD/.mcp.json" <<EOF
{
  "mcpServers": {
    "computer-commander": {
      "command": "node",
      "args": ["$MAC_ROOT/computer-commander/mcp-vendor/dist/index.js"]
    }
  }
}
EOF

cat > "$BUILD/COWORK.md" <<EOF
# Cowork package

This package intentionally does NOT contain the MCP server. It runs:

    node $MAC_ROOT/computer-commander/mcp-vendor/dist/index.js

That path is this repo's working tree. Move or delete the repo and this
plugin stops working. Rebuild the package with scripts/build-cowork-plugin.sh
if the repo moves, or set DC_MAC_REPO_ROOT to override the path.

To update the server, run scripts/update-computer-commander.sh and restart
Claude Desktop. The plugin does not need reinstalling.
EOF

rm -f "$OUT"
(cd "$BUILD" && zip -rq "$OUT" . -x "*.DS_Store")
echo "built: $OUT ($(du -h "$OUT" | cut -f1))"
