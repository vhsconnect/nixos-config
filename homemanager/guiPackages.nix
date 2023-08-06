{ pkgs, ... }:
{
  home.packages = with pkgs;[
    alacritty
    arandr
    chromium
    evince
    filezilla
    flameshot
    gnvim
    gparted
    gromit-mpx
    gthumb
    signal-desktop
    tdesktop
    freetube
    syncthingtray
  ];

}
