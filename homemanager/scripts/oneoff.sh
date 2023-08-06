#! /usr/bin/env nix-shell
#! nix-shell -i zsh -p fzf 

set - euo pipefail

PACK=(calibre \
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
