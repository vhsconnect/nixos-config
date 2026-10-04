#!/usr/bin/env bash
# label: YouTube Search
# Asks for a query, opens YouTube results in a new Firefox window.

set -u
source "$(dirname "$(readlink -f "$0")")/../lib/common.sh"

if (($#)); then
    query=$*
else
    query=$(ask 'youtube' 'Type a search query…')
fi

[[ -n ${query:-} ]] || exit 0

open_url "https://www.youtube.com/results?search_query=$(urlencode "$query")"
