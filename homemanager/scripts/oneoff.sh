#! /usr/bin/env nix-shell
#! nix-shell -i zsh -p gum 

set - euo pipefail


PACK=$(gum choose \
  calibre \
  discord     \
  dropbox     \
  gimp        \
  inkscape    \
  imagemagick \
  insomnia    \
  krita       \
  minder      \
  obs-studio  \
  obsidian    \
  qbittorrent \
  qt5ct       \
  slack       \
  songrec     \
  spotify     \
  sublime-merrge \
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


)

nix-shell -p "$PACK"

