#!/usr/bin/env bash
set -euo pipefail

TEMP_IMG=$(mktemp --suffix=.png)
trap 'rm -f "$TEMP_IMG"' EXIT

spectacle --region --background --nonotify --output "$TEMP_IMG"

# GUARD: Screenshot aborted
[[ ! -s "$TEMP_IMG" ]] && exit 0

uv run --with easyocr python -c "
import easyocr
import sys
import warnings

warnings.filterwarnings('ignore')
reader = easyocr.Reader(['en'], verbose=False)
results = reader.readtext(sys.argv[1], detail=0, paragraph=True)

print('\n'.join(results))
" "$TEMP_IMG" | wl-copy

qdbus6 org.kde.plasmashell /org/kde/osdService org.kde.osdService.showText "edit-copy" "OCR Text Copied"
pw-play /usr/share/sounds/freedesktop/stereo/complete.oga
