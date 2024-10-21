{ pkgs, inputs, ... }:
let
  fonts = (import ./fonts.nix { }).fonts;

  generateFontTemplate = font_name: ''
    [font.bold]
    family = "${font_name} Nerd Font"
    style = "Italic"

    [font.italic]
    family = "${font_name} Nerd Font"
    style = "Regular"

    [font.normal]
    family = "${font_name} Nerd Font"
    style = "Light"
  '';

in

{
  xdg.configFile = builtins.listToAttrs (
    map (font: {
      name = "alacritty/fonts/${font}.toml";
      value = {
        text = generateFontTemplate font;
      };
    }) fonts
  );

  home.packages =
    with pkgs;
    [
      cron
      gnumake
      librespeed-cli
      # prettyping
      # protoc-gen-doc
      tldr
      ponysay

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
      exa
      fd
      silver-searcher
      bat
      lf
      killall
      tree
      ripgrep

      #daemons
      dropbox

      # nixos vm
      nixos-shell
      nix-tree

      #fonts
      (nerdfonts.override { inherit fonts; })

      #shells
      fish
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
    ++ (with pkgs.python39Packages; [
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
