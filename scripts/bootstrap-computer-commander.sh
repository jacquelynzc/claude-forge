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

cd "$VENDOR"
echo "==> Installing dependencies (dev included, install scripts skipped)"
npm ci --ignore-scripts --no-audit --no-fund >/dev/null
echo "==> Building"
npm run build >/dev/null
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
