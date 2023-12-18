#!/usr/bin/env bash
sleep 1
# === Create Splits ===
# Create 3 vertical columns
for run in {1..2}; do qdbus org.kde.yakuake /yakuake/sessions splitTerminalLeftRight "$(qdbus org.kde.yakuake /yakuake/sessions activeTerminalId)"; done
# Split each column horizontally
qdbus org.kde.yakuake /yakuake/sessions splitTerminalTopBottom 0
qdbus org.kde.yakuake /yakuake/sessions splitTerminalTopBottom 1
qdbus org.kde.yakuake /yakuake/sessions splitTerminalTopBottom 2
# Split bottom-center window in half
qdbus org.kde.yakuake /yakuake/sessions splitTerminalTopBottom 4
# Split center-most window into quads
qdbus org.kde.yakuake /yakuake/sessions splitTerminalLeftRight 4
qdbus org.kde.yakuake /yakuake/sessions splitTerminalTopBottom 4
qdbus org.kde.yakuake /yakuake/sessions splitTerminalTopBottom 7
# === Run Commands ===
# Utility variables and functions
TODO="todo.sh -d ${HOME}/.config/todo/config.sh"
MSG=""
function msg () { MSG="echo -e \"\e[1m${1}\e[0m\""; }
GREP_TODAY="grep \"due:\$(date '+%Y-%m-%d')\""
GREP_TOMORROW="grep \"due:\$(date --date='tomorrow' '+%Y-%m-%d')\""
# Run commands in splits
qdbus org.kde.yakuake /yakuake/sessions runCommandInTerminal 0 " watch -t 'claws-mail --statistics | cowsay -f dragon'"
qdbus org.kde.yakuake /yakuake/sessions runCommandInTerminal 1 " watch -tc 'cal -y --color=always | sed \"s/^/     	  			  /\"'"
qdbus org.kde.yakuake /yakuake/sessions runCommandInTerminal 2 " notes"
qdbus org.kde.yakuake /yakuake/sessions runCommandInTerminal 3 " cmus"
qdbus org.kde.yakuake /yakuake/sessions runCommandInTerminal 5 " eselect news list new"
msg "DUE TODAY!" 
qdbus org.kde.yakuake /yakuake/sessions runCommandInTerminal 4 " watch -tc '${MSG}; ${TODO} | ${GREP_TODAY}'"
msg "NOT DUE TODAY OR TOMORROW"
qdbus org.kde.yakuake /yakuake/sessions runCommandInTerminal 7 " watch -tc '${MSG}; ${TODO} ls due | ${GREP_TODAY} -v | ${GREP_TOMORROW} -v'"
msg "DUE TOMORROW!" 
qdbus org.kde.yakuake /yakuake/sessions runCommandInTerminal 8 " watch -tc '${MSG}; ${TODO} ls due | ${GREP_TOMORROW}'"
msg "NOT DUE."
qdbus org.kde.yakuake /yakuake/sessions runCommandInTerminal 9 " watch -tc '${MSG}; ${TODO} ls -due'"
# === Resize Splits ===
qdbus org.kde.yakuake /yakuake/window toggleWindowState
# Center-column horizontal splits
for run in {1..30}; do qdbus org.kde.yakuake /yakuake/sessions tryGrowTerminalBottom 1; done
for run in {1..12}; do qdbus org.kde.yakuake /yakuake/sessions tryGrowTerminalBottom 9; done
# Center-column vertical split
for run in {1..12}; do qdbus org.kde.yakuake /yakuake/sessions tryGrowTerminalLeft 1; done
for run in {1..12}; do qdbus org.kde.yakuake /yakuake/sessions tryGrowTerminalRight 1; done
qdbus org.kde.yakuake /yakuake/window toggleWindowState
