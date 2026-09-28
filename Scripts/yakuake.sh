#!/usr/bin/env bash
sleep 1
# === Create Splits ===
# Create 3 vertical columns
for run in {1..2}; do qdbus6 org.kde.yakuake /yakuake/sessions splitTerminalLeftRight "$(qdbus6 org.kde.yakuake /yakuake/sessions activeTerminalId)"; done
# Split each column horizontally
qdbus6 org.kde.yakuake /yakuake/sessions splitTerminalTopBottom 0
qdbus6 org.kde.yakuake /yakuake/sessions splitTerminalTopBottom 1
qdbus6 org.kde.yakuake /yakuake/sessions splitTerminalTopBottom 2
# === Run Commands ===
# Run commands in splits
function runInSplit () { qdbus6 org.kde.yakuake /yakuake/sessions runCommandInTerminal "$1" " sleep 2; $2"; }
runInSplit 0 "watch -t 'claws-mail --statistics | cowsay -f www'"
runInSplit 1 "watch -tc 'cal -y --color=always | sed \"s/^/                 /\"'"
runInSplit 2 "notes"
runInSplit 3 "cmus"
runInSplit 5 "eselect news list new"
runInSplit 4 "nicotine --headless"
# === Resize Splits ===
qdbus6 org.kde.yakuake /yakuake/window toggleWindowState
# Center-column horizontal splits
for run in {1..30}; do qdbus6 org.kde.yakuake /yakuake/sessions tryGrowTerminalBottom 1; done
# Center-column vertical split
for run in {1..12}; do qdbus6 org.kde.yakuake /yakuake/sessions tryGrowTerminalLeft 1; done
for run in {1..12}; do qdbus6 org.kde.yakuake /yakuake/sessions tryGrowTerminalRight 1; done
qdbus6 org.kde.yakuake /yakuake/window toggleWindowState
