{ pkgs, ... }:
rec {
  essential = with pkgs; [
    # themePackages
    xfce.xfce4-icon-theme
    # guiPackages
    signal-desktop
    alacritty
    evince
    gedit
    nautilus
    # display
    arandr
    wdisplays
    xwallpaper
    # hardware mgmt
    acpi
    # applets
    networkmanagerapplet
    #packages
    coreutils
    # fonts
    nerd-fonts.hack
    # utils
    eza
    silver-searcher
    fd
    lsof
    jq
    bat
    magic-wormhole-rs
    inotify-tools
    # shell
    fish
    # lsp / formatters
    nixfmt
  ];

  home.packages = essential;
}
