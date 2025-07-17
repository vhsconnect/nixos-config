{ pkgs, ... }:
{
  home.packages = with pkgs; [
    alacritty
    anki
    arandr
    chromium
    evince
    flameshot
    gromit-mpx
    gthumb
    signal-desktop
    popcorntime
    libsForQt5.kate
    element-desktop
    mongodb-compass
  ];
}
