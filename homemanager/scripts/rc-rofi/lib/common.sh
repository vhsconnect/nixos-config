#!/usr/bin/env bash
#
# Shared helpers for rc-rofi actions.
# Source it from an action:
#   source "$(dirname "$(readlink -f "$0")")/../lib/common.sh"

ROFI_BIN="${ROFI_BIN:-rofi}"

# urlencode <string> — percent-encode for use in a query string
urlencode() {
    jq -rn --arg v "$1" '$v|@uri'
}

# ask <prompt> [hint] — open a second rofi window and read a line of input.
# Prints the text; prints nothing if the user cancels.
ask() {
    local prompt=$1 hint=${2:-}
    local args=(-dmenu -i -p "$prompt")
    [[ -n $hint ]] && args+=(-mesg "$hint")
    "$ROFI_BIN" "${args[@]}"
}

# copy_to_clipboard <text> — Wayland first, X11 fallback
copy_to_clipboard() {
    if command -v wl-copy >/dev/null 2>&1; then
        printf '%s' "$1" | wl-copy
    elif command -v xclip >/dev/null 2>&1; then
        printf '%s' "$1" | xclip -selection clipboard -in
    fi
}

# open_url <url> — open a browser window, detached so rofi doesn't wait
open_url() {
    if command -v firefox >/dev/null 2>&1; then
        (exec setsid firefox --new-window "$1" >/dev/null 2>&1 &) 2>/dev/null
    else
        (exec setsid xdg-open "$1" >/dev/null 2>&1 &) 2>/dev/null
    fi
}
