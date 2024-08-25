#! /usr/bin/env nix-shell
#! nix-shell -i zsh -p fzf 

export NIXPKGS_ALLOW_UNFREE=1
export NIXPKGS_ALLOW_INSECURE=1

set - euo pipefail

PACK=(calibre \
  discord     \
  dropbox     \
  gimp        \
  inkscape    \
  imagemagick \
  bruno    \
  krita       \
  minder      \
  obs-studio  \
  obsidian    \
  qbittorrent \
  slack       \
  songrec     \
  spotify     \
  sublime-merge \
  sublime3    \
  teams      \
  thunderbird \
  vscodium    \
  zoom-us     \
  zeal        \
  helix \
  bundler \
  bundix \
  newsboat \
  ncspot \
  awscli2 \
  libreoffice \
)

SEL=$(printf  "%s\n" "${PACK[@]}" | fzf)

nix-shell -p "$SEL"
