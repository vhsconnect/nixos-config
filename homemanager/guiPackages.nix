{ pkgs, ... }: {
  home.packages = with pkgs; [
    sublime
    alacritty
    anki
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
