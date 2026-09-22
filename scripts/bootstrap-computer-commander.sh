#!/usr/bin/env bash
# Build the vendored Computer Commander server from the committed source.
#
# node_modules/ and dist/ are not in git, so a fresh clone has source but no
# runnable server. Run this once after cloning, then relaunch Claude Desktop.
#
# The telemetry patches are already applied in the committed src/ - this only
# installs dependencies and compiles. To take a new upstream release instead,
# use update-computer-commander.sh.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VENDOR="$REPO_ROOT/computer-commander/mcp-vendor"

# npm exec leaks npm_config_* into child shells - notably
# npm_config_allow_scripts, which makes npm ci fail with EALLOWSCRIPTS.
for v in $(env | grep -o "^npm_[A-Za-z0-9_]*" || true); do unset "$v"; done

# tsc emits JS even when it reports errors, and the build chain is
# `tsc && shx cp ... && node build-ui-runtime.cjs`. A non-zero tsc silently
# skips every copy step while still leaving a dist/ that looks fine and passes
# a smoke test. Never swallow this output.
build_or_die() {
  local log="${TMPDIR:-/tmp}/cc-build.log"
  if ! npm run build > "$log" 2>&1; then
    echo "    BUILD FAILED - first errors:"
    grep -E "error TS|npm ERR" "$log" | head -20
    echo "    full log: $log"
    exit 1
  fi
}

# The copy steps after tsc are what break first when the build half-fails.
assert_dist_complete() {
  local missing=0
  for f in dist/index.js dist/data/onboarding-prompts.json \
           dist/remote-device/scripts/blocking-offline-update.js \
           dist/setup-claude-server.js dist/uninstall-claude-server.js; do
    [ -e "$f" ] || { echo "    MISSING $f"; missing=1; }
  done
  [ "$missing" = "0" ] || { echo "    dist/ is incomplete - the build chain halted early"; exit 1; }
}

cd "$VENDOR"
echo "==> Installing dependencies (dev included, install scripts skipped)"
npm ci --ignore-scripts --no-audit --no-fund >/dev/null
echo "==> Building"
build_or_die
assert_dist_complete
echo "==> Pruning to production dependencies"
npm ci --omit=dev --ignore-scripts --no-audit --no-fund >/dev/null

echo "==> Verifying the telemetry patches survived into dist/"
grep -q "LOCAL FORK PATCH" dist/utils/capture.js || { echo "FAIL: telemetry patch missing from dist"; exit 1; }
grep -q "LOCAL FORK PATCH" dist/utils/feature-flags.js || { echo "FAIL: feature-flag patch missing from dist"; exit 1; }
grep -q '"computer-commander"' dist/server.js || { echo "FAIL: server identity patch missing from dist"; exit 1; }
echo "    ok"

echo "==> Smoke test"
printf '%s\n%s\n' \
  '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"bootstrap","version":"1"}}}' \
  '{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}' \
  | node dist/index.js 2>/dev/null | python3 -c "
import sys, json
lines = [json.loads(l) for l in sys.stdin if l.strip().startswith('{')]
init = next((l for l in lines if l.get('id') == 1), None)
tools = next((l for l in lines if l.get('id') == 2), None)
if not init or not tools or 'result' not in tools:
    print('    FAIL: server did not respond'); sys.exit(1)
info = init['result']['serverInfo']
print('    ' + info['name'] + ' ' + info['version'] + ' - ' + str(len(tools['result']['tools'])) + ' tools')
"

echo
echo "Done. Relaunch Claude Desktop."
