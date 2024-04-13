{ pkgs, ... }: {
  home.packages = with pkgs; [
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
    popcorntime
    freetube
    syncthingtray
  ];
}
