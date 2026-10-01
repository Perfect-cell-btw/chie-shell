#!/usr/bin/env bash
set -u

render_line() {
    local status="${1:-}"
    local artist="${2:-}"
    local title="${3:-}"
    local icon

    case "$status" in
        Playing) icon="▶" ;;
        Paused)  icon="Ⅱ" ;;
        *)       icon="♪" ;;
    esac

    if [[ -n "$artist" && -n "$title" ]]; then
        printf '%s %s — %s\n' "$icon" "$artist" "$title"
    elif [[ -n "$title" ]]; then
        printf '%s %s\n' "$icon" "$title"
    else
        printf '%s Media\n' "$icon"
    fi
}

while true; do
    emitted=false

    while IFS='|' read -r status artist title; do
        render_line "$status" "$artist" "$title"
        emitted=true
    done < <(
        playerctl --follow metadata \
            --format '{{status}}|{{artist}}|{{title}}' 2>/dev/null
    )

    if [[ "$emitted" == false ]]; then
        printf '♪\n'
    fi

    sleep 2
done
