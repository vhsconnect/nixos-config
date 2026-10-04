#!/usr/bin/env bash
# label: GitHub Search
# Asks for a query, opens GitHub search results in a new Firefox window.

set -u
source "$(dirname "$(readlink -f "$0")")/../lib/common.sh"

if (($#)); then
    query=$*
else
    query=$(ask 'github' 'Type a search query…')
fi

[[ -n ${query:-} ]] || exit 0

open_url "https://github.com/search?q=$(urlencode "$query")"
