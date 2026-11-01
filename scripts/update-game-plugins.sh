#!/usr/bin/env bash
# Sync the vendored game-dev plugins (unity-dev, game-trends) with upstream.
#
#   scripts/update-game-plugins.sh            # report only: pinned vs upstream HEAD, diffstat
#   scripts/update-game-plugins.sh --apply    # replace trees with upstream HEAD, re-apply rename + patches
#   scripts/update-game-plugins.sh --apply unity-dev   # one plugin only
#
# Pins live in scripts/game-plugins.lock (name url commit). --apply rewrites the
# pin. Local changes go in <plugin>/patches/*.patch and are re-applied in order
# after every sync; a patch that no longer applies fails the run loudly.
# Nothing is committed. The weekly workflow (.github/workflows/sync-game-plugins.yml)
# runs --apply and opens a PR for review.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOCK="$REPO_ROOT/scripts/game-plugins.lock"
APPLY="no"; ONLY=""
for a in "$@"; do
  case "$a" in
    --apply) APPLY="yes" ;;
    *) ONLY="$a" ;;
  esac
done

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
CHANGED=0

# The only rename: the plugin's own name, so it installs next to the upstream
# plugin without colliding. Skill names stay upstream's so cross-references hold.
rename_plugin() {
  local dir="$1" name="$2" f
  for f in "$dir"/.claude-plugin/plugin.json; do
    node -e '
      const fs = require("fs"); const [f, name] = process.argv.slice(1);
      const j = JSON.parse(fs.readFileSync(f, "utf8"));
      j.name = name;
      if (j.displayName) j.displayName = j.displayName + " (forge)";
      fs.writeFileSync(f, JSON.stringify(j, null, 2) + "\n");
    ' "$f" "$name"
  done
}

sync_one() {
  local name="$1" url="$2" pinned="$3"
  echo "=== $name ==="
  if ! git clone -q "$url" "$TMP/$name" 2>/dev/null; then
    echo "  clone failed (offline?) - skipped"; return 0
  fi
  local head; head="$(git -C "$TMP/$name" rev-parse HEAD)"
  if [ "$head" = "$pinned" ]; then
    echo "  up to date at ${pinned:0:12}"; return 0
  fi
  CHANGED=1
  echo "  pinned ${pinned:0:12} -> upstream ${head:0:12}"
  git -C "$TMP/$name" log --oneline "$pinned..$head" 2>/dev/null | sed 's/^/    /' | head -20 || true

  [ "$APPLY" = "yes" ] || return 0

  local dest="$REPO_ROOT/$name" keep="$TMP/$name-patches"
  [ -d "$dest/patches" ] && cp -R "$dest/patches" "$keep"
  rm -rf "$dest"
  mkdir -p "$dest"
  (cd "$TMP/$name" && git archive HEAD) | tar -x -C "$dest"
  [ -d "$keep" ] && cp -R "$keep" "$dest/patches"
  rename_plugin "$dest" "$name"

  if [ -d "$dest/patches" ]; then
    local p
    for p in "$dest"/patches/*.patch; do
      [ -e "$p" ] || continue
      if ! git -C "$REPO_ROOT" apply --directory="$name" "$p"; then
        echo "  PATCH FAILED: $(basename "$p") - refresh it against the new upstream"; exit 1
      fi
      echo "  applied $(basename "$p")"
    done
  fi

  sed -i.bak "s|^$name $url $pinned\$|$name $url $head|" "$LOCK" && rm -f "$LOCK.bak"
  echo "  updated to ${head:0:12}; review git diff, then update VENDOR.md"
}

while read -r name url pinned; do
  case "$name" in ''|'#'*) continue ;; esac
  [ -n "$ONLY" ] && [ "$ONLY" != "$name" ] && continue
  sync_one "$name" "$url" "$pinned"
done < "$LOCK"

[ "$CHANGED" = "1" ] && echo && echo "Upstream has new commits." || true
