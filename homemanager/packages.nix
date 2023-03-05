{ pkgs, ... }:
{
  home.packages = with pkgs; [

    # rust
    cargo
    rustc

    #python
    #yapf
    #black
    pyright

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
    helix
    killall
    librespeed-cli
    lf
    newsboat
    niv
    nix-doc
    nix-prefetch-git
    nixpkgs-fmt
    ncspot
    pastel
    pdftk
    prettyping
    protoc-gen-doc
    rnix-lsp
    shellcheck
    silver-searcher
    tldr
    tmuxinator
    tree
    watchman
    # youtube-dl
    yt-dlp
    zip

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
