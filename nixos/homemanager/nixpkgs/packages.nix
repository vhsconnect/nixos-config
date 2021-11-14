{ pkgs, lib, config, ... }:
{
  home.packages = with pkgs; [
    awscli2
    acpi
    ag
    cabal-install
    cabal2nix
    cron
    coreutils
    dispad
    exa
    evince
    fd
    ffmpeg
    gitAndTools.diff-so-fancy
    gitAndTools.tig
    gparted
    glimpse
    gksu
    gnumake
    gromit-mpx
    hexchat
    killall
    insomnia
    lxqt.lxqt-sudo
    lxqt.lxqt-openssh-askpass
    lxappearance
    networkmanagerapplet
    nix-doc
    nixpkgs-fmt
    nix-prefetch-git
    niv
    pastel
    prettyping
    qt5ct
    rnix-lsp
    signal-desktop
    sublime3
    sublime-merge
    slack
    tldr
    tdesktop
    teams
    tree
    terminator
    thunderbird
    unzip
    xfce.thunar
    xss-lock
    xorg.xmodmap
    xorg.xev
    qbittorrent
    youtube-dl
    zip
    zoom-us
    cowsay

    pop-icon-theme
    vivid
    paper-icon-theme
    adapta-gtk-theme
    pop-gtk-theme
    arc-theme
    font-awesome
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "DroidSansMono"
        "Iosevka"
        "Meslo"
        "3270"
        "Hack"
        "JetBrainsMono"
        "Agave"
        "Cousine"
      ];
    })

  ] ++ (with pkgs.haskellPackages;
    [
      ghc
      haskell-language-server
      stack
      ghcid
    ]
  ) ++ (with pkgs.python39Packages;
    [
      virtualenv
      pip
    ]
  );

}
