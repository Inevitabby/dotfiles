#!/usr/bin/env bash
export PATH="$HOME/.local/bin:$PATH"
D="$HOME/Sync/Phone/Crosswords"
SOURCES="nd uni lat latm usa wp pzm pzmb pop sdp sdpq sdpc tny tnym vult atl db vox bill prince prince-mini club"

tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT

# 1. Install/update xword-dl
uv tool install --upgrade --quiet git+https://github.com/thisisparker/xword-dl.git

# 2. Download files
for s in $SOURCES; do
  (cd "$tmp" && xword-dl "$s") >/dev/null 2>&1
done

# 3. Move new puzzles to Forkyz' import dir
for f in "$tmp"/*.puz; do
  [ -e "$f" ] || continue
  n=$(basename "$f")
  [ -e "$D/to-import/$n" ] || [ -e "$D/to-import-done/$n" ] || [ -e "$D/to-import-failed/$n" ] || mv "$f" "$D/to-import/"
done
