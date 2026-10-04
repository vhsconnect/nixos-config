#!/usr/bin/env bash
# label: Translate
# Asks for text and a target language, translates it, then lets you choose
# what to do with the result (copy to clipboard / search it on Google).

set -u
_libdir=$(dirname "$(dirname "$(readlink -f "$0")")")/lib
source "$_libdir/common.sh"
source "$_libdir/translate.sh"

DEFAULT_TARGET="${TRANSLATE_TARGET:-es}"

# --- input ---------------------------------------------------------------------
# Terminal testing:  ./translate.sh "some text" [lang] [copy|google]
if (($# >= 1)); then
    text=$1
else
    text=$(ask 'translate' 'Text to translate…')
fi
[[ -n ${text:-} ]] || exit 0

if (($# >= 2)); then
    target=$2
else
    langs=("$DEFAULT_TARGET" da de es fr it ja ko nl pl pt ru sv zh)
    target=$(printf '%s\n' "${langs[@]}" | awk '!seen[$0]++' \
        | "$ROFI_BIN" -dmenu -i -p 'translate to')
    # empty input in the second window aborts everything
    [[ -n ${target:-} ]] || exit 0
fi

# --- translate -------------------------------------------------------------------
result=$(translate "$target" "$text") || {
    notify-send -u critical 'Translate' "translation to '$target' failed"
    exit 1
}

# --- pick what to do with the result ----------------------------------------------
result_action=${3:-}
if [[ -z $result_action ]]; then
    if (($# >= 1)); then
        result_action=copy              # terminal mode: stay non-interactive
    else
        # show the translation in the message line (escape pango markup)
        esc=${result//&/'&amp;'}; esc=${esc//</'&lt;'}; esc=${esc//>/'&gt;'}
        result_action=$(printf 'copy\ngoogle\n' \
            | "$ROFI_BIN" -dmenu -i -no-custom -p 'result' -mesg "$esc")
        [[ -n ${result_action:-} ]] || result_action=copy   # escape = copy
    fi
fi

case $result_action in
    google)
        open_url "https://www.google.com/search?q=$(urlencode "$result")"
        ;;
    *)
        copy_to_clipboard "$result"
        notify-send "Translate → $target" "$result"
        ;;
esac
