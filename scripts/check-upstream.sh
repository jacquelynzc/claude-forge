#!/usr/bin/env bash
# Report what changed upstream since the vendored import. Never writes to the
# vendored trees — review the diff, then apply changes by hand and commit.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

check() {
  local name="$1" url="$2"; shift 2
  echo "=== $name ==="
  if ! git clone -q --depth 1 "$url" "$TMP/$name" 2>/dev/null; then
    echo "  clone failed (offline?) — skipped"; return 0
  fi
  local out="/tmp/upstream-review-$name.diff"
  # Exclude .git and the paths this fork deliberately pruned, so the report
  # is upstream's changes and not our own deletions.
  diff -ru -x '.git' -x 'node_modules' -x 'mcp-vendor' \
    "$TMP/$name" "$REPO_ROOT/$name" > "$out" 2>/dev/null || true
  local n; n=$(grep -c '^diff ' "$out" 2>/dev/null || echo 0)
  echo "  $n file(s) differ — full diff: $out"
}

check ui-craft    https://github.com/educlopez/ui-craft.git
check caveman     https://github.com/JuliusBrussee/caveman
check superpowers https://github.com/obra/superpowers.git
check humanizer   https://github.com/blader/humanizer.git

echo
echo "Review each diff before applying anything. Update VENDOR.md when you do."
