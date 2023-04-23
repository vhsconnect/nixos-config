{ pkgs, ... }:
{
  home.packages = with pkgs; [

    #
    cron
    gnumake
    helix
    librespeed-cli
    pastel
    pdftk
    prettyping
    protoc-gen-doc
    tldr
    tmuxinator
    watchman
    ponysay
    neofetch

    #3rd party
    awscli2

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
    #yapf
    #black
    pyright
    pycritty

    #ruby
    bundler
    bundix

    #bash
    shellcheck

    #git
    gitAndTools.diff-so-fancy
    gitAndTools.tig

    #audio/video
    ffmpeg
    yt-dlp

    #utils
    zip
    exa
    fd
    bat
    silver-searcher
    lf
    killall
    tree

    #tui
    newsboat
    ncspot

    # nixos vm
    nixos-shell

    #fonts
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "Hack"
        "Iosevka"
        "JetBrainsMono"
        "Meslo"
        "Terminus"
        "VictorMono"
        "Noto"
        "Overpass"
        "SpaceMono"
      ];
    })

  ] ++ (with pkgs.haskellPackages;
    [
      floskell
      ghc
      ghcid
      haskell-language-server
      hlint
      ormolu
      stack
    ]
  ) ++ (with pkgs.python39Packages;
    [
      virtualenv
      pip
    ]
  ) ++ (with pkgs.nodePackages;
    [
      bash-language-server
      typescript-language-server
      typescript
      vscode-langservers-extracted
    ]) ++ [
    # additional language servers
    pkgs.sumneko-lua-language-server
  ];

}
