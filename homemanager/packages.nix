{
  pkgs,
  inputs,
  lib,
  ...
}:

with builtins;
let
  inherit (import ./fonts.nix { }) fonts;
  inherit (import ./packages-small.nix { inherit pkgs; }) essential;
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
      devenv

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
      diff-so-fancy
      tig

      #audio/video
      ffmpeg
      yt-dlp
      scdl

      #utils
      zip
      lf
      killall
      tree
      ripgrep

      # nixos vm
      nixos-shell
      nix-tree

      #misc
      gh
      gleam
      erlang_28

      # android
      android-studio
    ]
    ++ essential
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
      pkgs.nil
    ];
}
