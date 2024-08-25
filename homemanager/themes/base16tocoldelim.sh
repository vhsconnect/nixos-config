#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl yq jq
#! nix-shell -I nixpkgs=http://nixos.org/channels/nixos-21.11/nixexprs.tar.xz
set -euo pipefail

curl -s "$1" | \
    yq 'to_entries[] | select(.key | startswith("base")) | .value |= "#" + .' | \
    jq -s 'from_entries' | \
    jq -r '.[]' | xargs | \
    sed --expression 's/\s/:/g'


# thanks https://github.com/thiagokokada
