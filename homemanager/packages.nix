{ pkgs, inputs, ... }:
{
  home.packages =
    with pkgs;
    [

      #
      cron
      gnumake
      librespeed-cli
      prettyping
      protoc-gen-doc
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

      # ai
      # ollama

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
      nix-tree

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
      typescript
      vscode-langservers-extracted
    ])
    ++ [
      # additional language servers
      pkgs.lua-language-server
      pkgs.nil
    ];
}
