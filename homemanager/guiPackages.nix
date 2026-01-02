{ pkgs, ... }:
{
  home.packages = with pkgs; [
    alacritty
    anki
    arandr
    chromium
    evince
    gedit
    flameshot
    gromit-mpx
    gthumb
    signal-desktop
    popcorntime
    notepad-next
    element-desktop
    mongodb-compass
  ];
}
