{ pkgs, ... }:
{
  home.packages = with pkgs; [

    # rust
    cargo
    rustc

    #python
    #yapf
    #black

    #ruby
    bundler
    bundix

    # unzip
    awscli2
    bat
    cabal-install
    cabal2nix
    cron
    exa
    fd
    ffmpeg
    gitAndTools.diff-so-fancy
    gitAndTools.tig
    gnumake
    killall
    lf
    #magic-wormhole
    newsboat
    niv
    nix-doc
    nix-prefetch-git
    nixpkgs-fmt
    pastel
    pdftk
    prettyping
    protoc-gen-doc
    rnix-lsp
    shellcheck
    silver-searcher
    tldr
    tree
    watchman
    youtube-dl
    zip



    #fonts
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "Hack"
        "Inconsolata"
        "Iosevka"
        "JetBrainsMono"
        "Meslo"
        "Monoid"
        "Terminus"
        "VictorMono"
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
    ]);

}
