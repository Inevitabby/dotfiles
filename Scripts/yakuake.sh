#!/usr/bin/env bash
sleep 1
# === Create Splits ===
# Create 3 vertical columns
for run in {1..2}; do qdbus6 org.kde.yakuake /yakuake/sessions splitTerminalLeftRight "$(qdbus6 org.kde.yakuake /yakuake/sessions activeTerminalId)"; done
# Split each column horizontally
qdbus6 org.kde.yakuake /yakuake/sessions splitTerminalTopBottom 0
qdbus6 org.kde.yakuake /yakuake/sessions splitTerminalTopBottom 1
qdbus6 org.kde.yakuake /yakuake/sessions splitTerminalTopBottom 2
# Split bottom-center window in half
qdbus6 org.kde.yakuake /yakuake/sessions splitTerminalTopBottom 4
# Split center-most window into quads
qdbus6 org.kde.yakuake /yakuake/sessions splitTerminalLeftRight 4
qdbus6 org.kde.yakuake /yakuake/sessions splitTerminalTopBottom 4
qdbus6 org.kde.yakuake /yakuake/sessions splitTerminalTopBottom 7
# === Run Commands ===
# Utility variables and functions
TODO="todo.sh -d ${HOME}/.config/todo/config.sh"
MSG=""
function msg () { MSG="echo -e \"\e[1m${1}\e[0m\""; }
GREP_TODAY="grep \"due:\$(date '+%Y-%m-%d')\""
GREP_TOMORROW="grep \"due:\$(date --date='tomorrow' '+%Y-%m-%d')\""
# Run commands in splits
function runInSplit () { qdbus6 org.kde.yakuake /yakuake/sessions runCommandInTerminal "$1" " sleep 1; $2"; }
runInSplit 0 "watch -t 'claws-mail --statistics | cowsay -f dragon'"
runInSplit 1 "watch -tc 'cal -y --color=always | sed \"s/^/                 /\"'"
runInSplit 2 "notes"
runInSplit 3 "cmus"
runInSplit 5 "eselect news list new"
msg "DUE TODAY!" 
runInSplit 4 "watch -tc '${MSG}; ${TODO} | ${GREP_TODAY}'"
msg "NOT DUE TODAY OR TOMORROW"
runInSplit 7 "watch -tc '${MSG}; ${TODO} ls due | ${GREP_TODAY} -v | ${GREP_TOMORROW} -v'"
msg "DUE TOMORROW!" 
runInSplit 8 "watch -tc '${MSG}; ${TODO} ls due | ${GREP_TOMORROW}'"
msg "NOT DUE."
runInSplit 9 "watch -tc '${MSG}; ${TODO} ls -due'"
# === Resize Splits ===
qdbus6 org.kde.yakuake /yakuake/window toggleWindowState
# Center-column horizontal splits
for run in {1..30}; do qdbus6 org.kde.yakuake /yakuake/sessions tryGrowTerminalBottom 1; done
for run in {1..12}; do qdbus6 org.kde.yakuake /yakuake/sessions tryGrowTerminalBottom 9; done
# Center-column vertical split
for run in {1..12}; do qdbus6 org.kde.yakuake /yakuake/sessions tryGrowTerminalLeft 1; done
for run in {1..12}; do qdbus6 org.kde.yakuake /yakuake/sessions tryGrowTerminalRight 1; done
qdbus6 org.kde.yakuake /yakuake/window toggleWindowState
