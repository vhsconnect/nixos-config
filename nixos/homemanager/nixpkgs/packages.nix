{ pkgs, ... }:
{
  home.packages = with pkgs; [

    obs-studio
    vscodium
    xwallpaper
    gimp

    awscli2
    acpi
    ag
    cabal-install
    cabal2nix
    calibre
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
    gksu
    gnvim
    gnumake
    gromit-mpx
    hexchat
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
    pastel
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
    unzip
    xfce.thunar
    xorg.xmodmap
    xorg.xev
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
      virtualenv
      pip
    ]
  ) ++ (with pkgs.nodePackages;
    [
      bash-language-server
    ]);

}
