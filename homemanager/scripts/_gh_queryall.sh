# vim: syntax=bash
#! /usr/bin/env nix-shell

#! nix-shell -i curl jq
#! nix-shell -I nixpkgs=http://nixos.org/channels/nixos-24.05/nixexprs.tar.xz

set -euo pipefail

DATA=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $1" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/notifications)

jq '.[] | select(.repository.owner.login == "budbee" or .repository.owner.login == "instabox") | select(.subject.title | contains("chore(deps") | not )' <<< "$DATA" > ~/Public/github/notifications.json
 




