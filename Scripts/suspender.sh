#!/usr/bin/env bash

# Temporarily suspends heavy applications for gaming performance

TARGETS=(
    # 1. Firefox
    "firefox"

    # 2. Electron & CEF Apps
    "signal-desktop"
    "vesktop"
    "vesktop-bin"

    # 3. Background Services & Utilities
    "baloo_file"
    "claws-mail"
    "languagetool"
    "nicotine"
    "qbittorrent"
    "syncthing"
)

[[ "$1" == "freeze" || "$1" == "resume" || "$1" == "menu" ]] \
    || { echo "Usage: $0 {freeze|resume|menu}"; exit 1; }

get_descendants() {
    local current_pids=("$@") all_pids=("$@")
    while (( ${#current_pids[@]} > 0 )); do
        mapfile -t current_pids < <(pgrep -P "$(IFS=,; echo "${current_pids[*]}")" 2>/dev/null)
        all_pids+=("${current_pids[@]}")
    done
    printf '%s\n' "${all_pids[@]}"
}

app_state() {
    mapfile -t pids < <(pgrep -f "$1" | grep -v "$$")
    (( ${#pids[@]} == 0 )) && { echo "OFFLINE"; return; }
    local stat; stat=$(ps -o stat= -p "${pids[0]}" 2>/dev/null)
    [[ "$stat" == *[Tt]* ]] && echo "FROZEN" || echo "RUNNING"
}

apply_signal() {
    local app="$1" signal="$2"
    mapfile -t base_pids < <(pgrep -f "$app" | grep -v "$$")
    (( ${#base_pids[@]} == 0 )) && return
    mapfile -t all_pids < <(get_descendants "${base_pids[@]}" | sort -u)
    kill -"$signal" "${all_pids[@]}" 2>/dev/null
    echo "Sent SIG${signal} to ${#all_pids[@]} processes associated with '${app}'"
}

run_menu() {
    for app in "${TARGETS[@]}"; do
        [[ $(app_state "$app") == "RUNNING" ]] && apply_signal "$app" "STOP"
    done

    while true; do
        local opts=()
        for app in "${TARGETS[@]}"; do
            opts+=("$app" "[$(app_state "$app")]")
        done

        CHOICE=$(dialog --title "Application Dashboard" \
            --menu "Press Enter to toggle application state:" \
            0 0 0 "${opts[@]}" 2>&1 >/dev/tty) || break

        case "$(app_state "$CHOICE")" in
            RUNNING) apply_signal "$CHOICE" "STOP" ;;
            FROZEN)  apply_signal "$CHOICE" "CONT" ;;
        esac
    done

    for app in "${TARGETS[@]}"; do
        [[ $(app_state "$app") == "FROZEN" ]] && apply_signal "$app" "CONT"
    done

    clear
}

case "$1" in
    menu)   run_menu ;;
    freeze) for app in "${TARGETS[@]}"; do apply_signal "$app" "STOP"; done ;;
    resume) for app in "${TARGETS[@]}"; do apply_signal "$app" "CONT"; done ;;
esac
