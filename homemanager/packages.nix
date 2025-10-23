{
  pkgs,
  inputs,
  lib,
  ...
}:

with builtins;
let
  inherit (import ./fonts.nix { }) fonts;
  firstAttrName = z: head (attrNames z);
in
with lib;
with lib.trivial;
with builtins;

{

  home.packages =
    with pkgs;
    [
      cron
      gnumake
      librespeed-cli
      # prettyping
      # protoc-gen-doc
      tldr

      #haskell
      cabal-install
      cabal2nix

      # nix
      niv
      nix-prefetch-git
      nixpkgs-fmt

      # rust
      cargo
      rustc

      #python
      pyright
      pycritty

      #ruby
      # bundler
      # bundix

      #bash
      shellcheck

      #git
      gitAndTools.diff-so-fancy
      gitAndTools.tig

      #audio/video
      ffmpeg
      yt-dlp
      scdl

      #utils
      zip
      eza
      magic-wormhole-rs
      fd
      jq
      silver-searcher
      fd
      bat
      lf
      killall
      tree
      ripgrep

      # nixos vm
      nixos-shell
      nix-tree

      #shells
      fish

      #misc
      gh
      gleam
      erlang_28
    ]
    ++ (map (f: nerd-fonts.${firstAttrName f}) fonts)
    ++ (with pkgs.haskellPackages; [
      floskell
      ghc
      ghcid
      haskell-language-server
      hlint
      ormolu
      stack
    ])
    ++ (with pkgs.python312Packages; [
      virtualenv
      pip
    ])
    ++ (with pkgs.nodePackages; [
      bash-language-server
      typescript-language-server
      typescript # needed?
      prettier
      # vscode-langservers-extracted #broken
    ])
    ++ [
      # additional language servers
      pkgs.lua-language-server
      # pkgs.nil
    ];
}
