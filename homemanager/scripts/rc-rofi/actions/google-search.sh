#!/usr/bin/env bash
# label: Google Search
# Asks for a query, opens it in a new Firefox window.

set -u
source "$(dirname "$(readlink -f "$0")")/../lib/common.sh"

# Accept a query as $1 to test from a terminal: ./google-search.sh hello world
if (($#)); then
    query=$*
else
    query=$(ask 'google' 'Type a search query…')
fi

[[ -n ${query:-} ]] || exit 0

open_url "https://www.google.com/search?q=$(urlencode "$query")"
