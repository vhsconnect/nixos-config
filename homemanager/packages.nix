{
  pkgs,
  inputs,
  lib,
  ...
}:

with builtins;
let
  inherit (import ./fonts.nix { }) fonts generateFontTemplate;
  firstAttrName = z: head (attrNames z);
  firstAttrValue = z: head (attrValues z);
in
with lib;
with lib.trivial;
with builtins;

{
  xdg.configFile =
    let
      mapper = map (y: {
        name = "alacritty/fonts/${firstAttrName y}.toml";
        value = {
          text = generateFontTemplate (firstAttrValue y);
        };
      });
    in
    pipe fonts [
      mapper
      listToAttrs
    ];

  home.packages =
    with pkgs;
    [
      #temp
      kitty

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
      magic-wormhole
      fd
      silver-searcher
      bat
      lf
      killall
      tree
      ripgrep

      # nixos vm
      nixos-shell
      nix-tree

      #fonts
      (nerdfonts.override {
        fonts = (map firstAttrName fonts);
      })

      #shells
      fish

      #misc
      gh

    ]
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
