#!/usr/bin/env bash
#
# translate <target_lang> <text>
#
# Prints the translation to stdout (auto-detects the source language).
# Tries Lingva first, falls back to MyMemory. Both are free, no API key.

_libdir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
source "$_libdir/common.sh"

LINGVA_URL="${LINGVA_URL:-https://lingva.ml}"
MYMEMORY_URL="${MYMEMORY_URL:-https://api.mymemory.translated.net}"

translate() {
    local tl=$1 text=$2 q resp t

    q=$(urlencode "$text")

    # --- 1) MyMemory (no key, auto-detect) ---------------------------------
    resp=$(curl -sf --max-time 10 "$MYMEMORY_URL/get?q=$q&langpair=Autodetect|$tl")
    if [[ -n $resp ]]; then
        t=$(jq -rn --argjson r "$resp" '$r.responseData.translatedText // empty' 2>/dev/null)
        # quota-exceeded warnings come back as text instead of an error
        if [[ -n $t && $t != MYMEMORY\ WARNING* ]]; then
            printf '%s\n' "$t"
            return 0
        fi
    fi

    # --- 2) Lingva fallback (Google backend; sometimes returns input) -------
    resp=$(curl -sf --max-time 10 "$LINGVA_URL/api/v1/auto/$tl/$q")
    if [[ -n $resp ]]; then
        t=$(jq -rn --argjson r "$resp" '$r.translation // empty' 2>/dev/null)
        if [[ -n $t ]]; then
            printf '%s\n' "$t"
            return 0
        fi
    fi

    return 1
}
