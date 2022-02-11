#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl yq jq

set -euo pipefail

curl -s "$1" | \
    yq 'to_entries[] | select(.key | startswith("base")) | .value |= "#" + .' | \
    jq -s 'from_entries'


# thanks https://github.com/thiagokokada
