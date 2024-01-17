{ pkgs, inputs, ... }:
let
  devenv =
    inputs.devenv.packages.${builtins.currentSystem}.devenv;
in
{
  home.packages = with pkgs;
    [

      #
      cron
      gnumake
      librespeed-cli
      prettyping
      protoc-gen-doc
      tldr
      ponysay
      eww

      #haskell
      cabal-install
      cabal2nix

      # nix
      niv
      nix-doc
      nix-prefetch-git
      nixpkgs-fmt
      rnix-lsp

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

      # ai
      ollama

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

      # nixos vm
      nixos-shell

      #fonts
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "Iosevka"
          "JetBrainsMono"
          "Meslo"
          "VictorMono"
        ];
      })
    ]
    ++ (
      with pkgs.haskellPackages; [
        floskell
        ghc
        ghcid
        haskell-language-server
        hlint
        ormolu
        stack
      ]
    )
    ++ (
      with pkgs.python39Packages; [
        virtualenv
        pip
      ]
    )
    ++ (with pkgs.nodePackages; [
      bash-language-server
      typescript-language-server
      typescript
      vscode-langservers-extracted
    ])
    ++ [
      # additional language servers
      pkgs.lua-language-server
      pkgs.nil
    ];
}
