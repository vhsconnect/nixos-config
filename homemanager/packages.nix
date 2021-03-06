{ pkgs, ... }:
{
  home.packages = with pkgs; [

    alacritty
    obs-studio
    vscodium
    gimp
    krita
    newsboat
    watchman
    inotify-tools
    vscodium
    epiphany
    inkscape
    songrec
    magic-wormhole
    lf

    #python
    yapf
    black

    awscli2
    acpi
    silver-searcher
    bat
    cabal-install
    cabal2nix
    calibre
    chromium
    cron
    coreutils
    discord
    dropbox
    exa
    evince
    fd
    flameshot
    ffmpeg
    gitAndTools.diff-so-fancy
    gitAndTools.tig
    gparted
    gthumb
    gnvim
    gnumake
    gromit-mpx
    killall
    insomnia
    lxqt.lxqt-sudo
    lxqt.lxqt-openssh-askpass
    lxappearance
    minder
    nix-doc
    nixpkgs-fmt
    nix-prefetch-git
    niv
    networkmanagerapplet
    pastel
    pdftk
    pamixer
    protoc-gen-doc
    prettyping
    qt5ct
    rnix-lsp
    signal-desktop
    sublime3
    sublime-merge
    spotify
    shellcheck
    slack
    tldr
    tdesktop
    teams
    tree
    terminator
    thunderbird
    # unzip
    xfce.thunar
    xorg.xmodmap
    xorg.xev
    xwallpaper
    qbittorrent
    youtube-dl
    zip
    zoom-us

    #theming
    pop-icon-theme
    vivid
    paper-icon-theme
    adapta-gtk-theme
    pop-gtk-theme
    arc-theme
    font-awesome

    #ruby
    bundler
    bundix

    #fonts
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "Iosevka"
        "Meslo"
        "Hack"
        "JetBrainsMono"
        "VictorMono"
        "Terminus"
        "Monoid"
        "Inconsolata"
      ];
    })

  ] ++ (with pkgs.haskellPackages;
    [
      ghc
      haskell-language-server
      hlint
      ormolu
      floskell
      stack
      ghcid
    ]
  ) ++ (with pkgs.python39Packages;
    [
      #virtualenv
      #pip
    ]
  ) ++ (with pkgs.nodePackages;
    [
      #bash-language-server
    ]);

}
