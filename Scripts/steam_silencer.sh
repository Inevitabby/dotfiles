#!/usr/bin/env bash
# Modifies Steam shortcuts to launch games without opening the Steam Store
for file in ~/.local/share/applications/*.desktop; do
    [ -f "$file" ] || continue
    sed -i 's|^Exec=steam steam://rungame|Exec=steam -silent steam://rungame|' "$file"
done
