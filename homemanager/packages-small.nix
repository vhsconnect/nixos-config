{ pkgs, ... }:
{
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
    signal-desktop
    # x11
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
    tree
    bat
    magic-wormhole-rs
    inotify-tools
    nodePackages.typescript-language-server
    # shell
    fish
    # lsp / formatters
    nixfmt
  ];

}
