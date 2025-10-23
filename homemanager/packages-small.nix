{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # themePackages
    xfce.xfce4-icon-theme
    # guiPackages
    alacritty
    # x11
    arandr
    xwallpaper
    # hardware mgmt
    acpi
    # applets
    networkmanagerapplet
    #packages
    coreutils
    nixpkgs-fmt
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
  ];

}
