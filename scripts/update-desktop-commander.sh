#!/usr/bin/env bash
# Update the vendored Desktop Commander fork to a new upstream tag.
#
#   scripts/update-desktop-commander.sh                 # report only: what changed, do the patches still apply
#   scripts/update-desktop-commander.sh v0.2.60         # report against a specific tag
#   scripts/update-desktop-commander.sh v0.2.60 --apply # actually update, patch, build, smoke-test
#
# Nothing is committed. Review, then commit by hand and update VENDOR.md.
set -euo pipefail

UPSTREAM="https://github.com/wonderwhy-er/DesktopCommanderMCP.git"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VENDOR="$REPO_ROOT/desktop-commander/mcp-vendor"
PATCHES="$REPO_ROOT/desktop-commander/patches"

TAG="${1:-}"
APPLY="no"
for a in "$@"; do [ "$a" = "--apply" ] && APPLY="yes"; done
[ "${TAG:-}" = "--apply" ] && TAG=""

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Desktop Commander itself runs under this shell when invoked from a Claude
# session, and npm exec leaks npm_config_* into the environment (notably
# npm_config_allow_scripts, which makes npm ci fail with EALLOWSCRIPTS).
clean_npm_env() {
  for v in $(env | grep -o "^npm_[A-Za-z0-9_]*" || true); do unset "$v"; done
}

echo "==> Fetching upstream tags"
git clone -q --bare --filter=blob:none "$UPSTREAM" "$TMP/bare"
if [ -z "$TAG" ]; then
  TAG="$(git --git-dir="$TMP/bare" tag --sort=-v:refname | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | head -1)"
  echo "    latest upstream tag: $TAG"
fi

CURRENT="$(node -e "console.log(require('$VENDOR/package.json').version)")"
echo "==> vendored: v$CURRENT   target: $TAG"
[ "v$CURRENT" = "$TAG" ] && echo "    already on $TAG (patches may still differ)"

echo "==> Checking out $TAG"
git clone -q "$UPSTREAM" "$TMP/new"
git -C "$TMP/new" checkout -q "tags/$TAG"
rm -rf "$TMP/new/.git"
# Match what this fork prunes (large marketing assets, not runtime code).
rm -rf "$TMP/new/1080_60.mp4" "$TMP/new/testemonials" "$TMP/new/screenshots" \
       "$TMP/new/header.png" "$TMP/new/logo.png" "$TMP/new/icon.png"

DIFF="/tmp/upstream-review-desktop-commander.diff"
diff -ru -x node_modules -x dist "$TMP/new" "$VENDOR" > "$DIFF" 2>/dev/null || true
echo "==> $(grep -c '^diff ' "$DIFF" 2>/dev/null || echo 0) file(s) differ - full diff: $DIFF"

echo "==> Testing local patches against $TAG"
FAILED=0
for p in "$PATCHES"/*.patch; do
  [ -e "$p" ] || continue
  if git -C "$TMP/new" apply --check "$p" 2>/dev/null; then
    echo "    OK    $(basename "$p")"
  else
    echo "    FAIL  $(basename "$p")  <- upstream moved this code; re-derive the patch by hand"
    FAILED=1
  fi
done

if [ "$APPLY" != "yes" ]; then
  echo
  echo "Report only. Re-run with --apply to update."
  exit 0
fi
if [ "$FAILED" = "1" ]; then
  echo
  echo "ABORTING: a patch no longer applies. Fix it before updating - applying a"
  echo "half-patched tree would silently re-enable telemetry."
  exit 1
fi

echo "==> Applying patches"
for p in "$PATCHES"/*.patch; do [ -e "$p" ] && git -C "$TMP/new" apply "$p"; done

echo "==> Replacing vendored tree (node_modules kept)"
find "$VENDOR" -mindepth 1 -maxdepth 1 ! -name node_modules -exec rm -rf {} +
(cd "$TMP/new" && tar -cf - .) | (cd "$VENDOR" && tar -xf -)

echo "==> Installing dev deps and building"
clean_npm_env
cd "$VENDOR"
npm ci --ignore-scripts --no-audit --no-fund >/dev/null
npm run build >/dev/null
echo "==> Pruning to production dependencies"
npm ci --omit=dev --ignore-scripts --no-audit --no-fund >/dev/null

echo "==> Verifying patches survived into dist/"
HITS="$(grep -rc "LOCAL FORK PATCH" dist/utils/capture.js dist/utils/feature-flags.js | tr "\n" " ")"
echo "    $HITS"
grep -q "LOCAL FORK PATCH" dist/utils/capture.js || { echo "    FAIL: telemetry patch missing from dist"; exit 1; }

echo "==> Smoke test (initialize + tools/list)"
printf "%s\n%s\n" \
  "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"protocolVersion\":\"2024-11-05\",\"capabilities\":{},\"clientInfo\":{\"name\":\"smoke\",\"version\":\"1\"}}}" \
  "{\"jsonrpc\":\"2.0\",\"id\":2,\"method\":\"tools/list\",\"params\":{}}" \
  | node dist/index.js 2>/dev/null > "$TMP/smoke.json" || true
node -e "
const fs=require('fs');
const l=fs.readFileSync('$TMP/smoke.json','utf8').trim().split('\n').filter(Boolean).map(x=>{try{return JSON.parse(x)}catch{return null}}).filter(Boolean);
const i=l.find(x=>x.id===1), t=l.find(x=>x.id===2);
if(!i||!t||!t.result) { console.error('    FAIL: server did not respond'); process.exit(1); }
console.log('    '+i.result.serverInfo.name+' '+i.result.serverInfo.version+' - '+t.result.tools.length+' tools');
"

echo
echo "Done. Nothing committed. Next:"
echo "  1. git -C $REPO_ROOT add -f desktop-commander/mcp-vendor/node_modules   # gitignored, -f required"
  echo "  2. git -C $REPO_ROOT diff --cached --stat"
echo "  3. bump version in desktop-commander/.claude-plugin/plugin.json"
echo "  4. update the VENDOR.md row for desktop-commander"
echo "  5. commit, then restart Claude Desktop"
