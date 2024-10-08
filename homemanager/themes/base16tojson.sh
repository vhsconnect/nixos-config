#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl yq jq
#! nix-shell -I nixpkgs=http://nixos.org/channels/nixos-24.05/nixexprs.tar.xz

set -euo pipefail

curl -s "$1" | \
    yq 'to_entries[] | select(.key | startswith("base")) | .value |= "#" + .' | \
    jq -s 'from_entries'

# thanks https://github.com/thiagokokada
