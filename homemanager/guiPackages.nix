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
    rhythmbox
    signal-desktop
    tdesktop
    popcorntime
    freetube
    syncthingtray
    obsidian
  ];
}
