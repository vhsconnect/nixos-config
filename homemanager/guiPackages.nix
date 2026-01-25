{ pkgs, ... }:
{
  home.packages = with pkgs; [
    alacritty
    anki
    chromium
    flameshot
    gromit-mpx
    gthumb
    popcorntime
    notepad-next
    element-desktop
    mongodb-compass
  ];
}
