{ pkgs, ... }:
{
  home.packages = with pkgs; [
    alacritty
    anki
    arandr
    chromium
   brave 
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
