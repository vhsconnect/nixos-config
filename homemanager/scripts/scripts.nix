{ pkgs, ... }:
let
  ttheme1 = pkgs.writeScriptBin "ttheme1" ''
    #! /usr/bin/env bash
    CURRENT=$(${pkgs.silver-searcher}/bin/ag "profile =" --nonumbers ~/.config/terminator/config | xargs)
    X="profile = light"
    sed -i "s/$CURRENT/$X/" ~/.config/terminator/config
  '';
  ttheme2 = pkgs.writeScriptBin "ttheme2" ''
    #! /usr/bin/env bash
    CURRENT=$(${pkgs.silver-searcher}/bin/ag "profile =" --nonumbers ~/.config/terminator/config | xargs)
    X="profile = purple"
    sed -i "s/$CURRENT/$X/" ~/.config/terminator/config
  '';
  ttheme3 = pkgs.writeScriptBin "ttheme3" ''
    #! /usr/bin/env bash
    CURRENT=$(${pkgs.silver-searcher}/bin/ag "profile =" --nonumbers ~/.config/terminator/config | xargs)
    X="profile = dark"
    sed -i "s/$CURRENT/$X/" ~/.config/terminator/config
  '';
  allight = pkgs.writeScriptBin "allight" ''
    #! /usr/bin/env bash

    Y="*dracula"
    X="*carrots"

    A="ansi"
    B="GitHub"

    M="seoul256"
    N="PaperColor"

    C="\$DARK_FZF_TAB"
    D="\$LIGHT_FZF_TAB"

    sed -i "s/$Y/$X/" ~/.config/alacritty/alacritty.yml
    sed -i "s/$A/$B/" ~/.zstuff
    sed -i "s/$C/$D/" ~/.zstuff
    sed -i "s/$M/$N/" ~/.zstuff
  '';
  aldark = pkgs.writeScriptBin "aldark" ''
    #! /usr/bin/env bash

    Y="*carrots"
    X="*dracula"

    A="GitHub"
    B="ansi"

    M="PaperColor"
    N="seoul256"

    C="\$LIGHT_FZF_TAB"
    D="\$DARK_FZF_TAB"

    sed -i "s/$Y/$X/" ~/.config/alacritty/alacritty.yml
    sed -i "s/$A/$B/" ~/.zstuff
    sed -i "s/$C/$D/" ~/.zstuff
    sed -i "s/$M/$N/" ~/.zstuff
  '';

  pfire = pkgs.writeScriptBin "pfire" ''
    #! /usr/bin/env zsh
    firefox --private-window
  '';
  c-unsecure = pkgs.writeScriptBin "c-unsecure" ''
    #! /usr/bin/env zsh
    chromium --disable-web-security --user-data-dir="Public/chromium"
  '';
  watchexec = pkgs.writeScriptBin "watchexec" ''
    #! /usr/bin/env sh 
    echo "watching..."
    while inotifywait -e close_write $1; do $1; done
  '';
  keys = pkgs.writeScriptBin "keys" ''
    #! /usr/bin/env zsh 

    xmodmap -e "clear control"
    xmodmap -e "clear mod1"
    xmodmap -e "clear mod4"
    xmodmap -e "keycode 37 = Alt_L Meta_L"
    xmodmap -e "keycode 105 = Alt_R Meta_R"
    xmodmap -e "keycode 64 = Control_L"
    xmodmap -e "keycode 133 = Control_R"
    xmodmap -e "add control = Control_L Control_R"
    xmodmap -e "add mod1 = Alt_L Meta_L"
    xmodmap -e "remove lock = Caps_Lock" # disable capslock functionality from CAPS_LOCK
    xmodmap -e "add mod1 = Caps_Lock" #add ALT to capslock
    xmodmap -e "keycode 66 = Alt_R" #assign keycode
  '';
  trips4 = pkgs.writeScriptBin "trips4" ''
    #! /usr/bin/env zsh
    xrandr --auto --output HDMI2 --primary --mode 1920x1080 --same-as eDP1
    xrandr --auto --output DP1 --mode 2560x1440 --left-of eDP1
    xwallpaper --screen 0 --stretch ~/.background-image
    xwallpaper --screen 1 --stretch ~/.background-image
  '';

  monitorsDisconnected = pkgs.writeScriptBin "monitorsDisconnected" ''
    #! /usr/bin/env zsh
    xrandr --output HDMI2 --off --output DP1 --off
  '';
  robl = pkgs.writeScriptBin "robl" (builtins.readFile ./robl);
in
{
  home.packages = [
    ttheme1
    ttheme2
    ttheme3
    allight
    aldark
    pfire
    c-unsecure
    watchexec
    keys
    trips4
    monitorsDisconnected
    robl
  ];
}

