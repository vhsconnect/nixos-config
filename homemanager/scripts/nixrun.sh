#! /usr/bin/env nix-shell
#! nix-shell -i zsh -p fzf 

export NIXPKGS_ALLOW_UNFREE=1
export NIXPKGS_ALLOW_INSECURE=1

set - euo pipefail

PACK=(github:stannls/bandrip)

SEL=$(printf  "%s\n" "${PACK[@]}" | fzf)

nix run "$SEL" -- $1
