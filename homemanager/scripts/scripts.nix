{
  pkgs,
  lib,
  user,
  ...
}:
let
  firstAttributeName = x: builtins.head (builtins.attrNames x);
  fonts = map firstAttributeName (import ../fonts.nix { }).fonts;
  fontString = builtins.concatStringsSep " " fonts;
  changefont = pkgs.writeScriptBin "changefont" ''
    #! /usr/bin/env nix-shell
    #! nix-shell -i bash -p gnused

    set -e
    options=(${fontString})

    selected_option=$(printf '%s\n' "''${options[@]}" | fzf --height 70% )
    if [ -z "$selected_option" ]; then
        echo "Exiting"
        exit 0
    fi
    selected_option+=.toml

    Y="\"~/.config/alacritty/fonts/$selected_option\""
    sed -i  "/config\/alacritty\/fonts/c\\"$Y\\"" ~/.config/alacritty/alacritty.toml

  '';
  allight = pkgs.writeScriptBin "allight" ''
    #! /usr/bin/env bash

    Y="${user.darkAlacrittyTheme}"
    X="${user.lightAlacrittyTheme}"

    A="ansi"
    B="GitHub"

    M="${user.darkVimTheme}"
    N="${user.lightVimTheme}"

    C="\$DARK_FZF_TAB"
    D="\$LIGHT_FZF_TAB"

    sed -i "s/$Y/$X/" ~/.config/alacritty/alacritty.toml
    sed -i "s/$A/$B/" ~/.zstuff
    sed -i "s/$C/$D/" ~/.zstuff
    sed -i "s/$M/$N/" ~/.zstuff
  '';
  aldark = pkgs.writeScriptBin "aldark" ''
    #! /usr/bin/env bash

    Y="${user.lightAlacrittyTheme}"
    X="${user.darkAlacrittyTheme}"

    A="GitHub"
    B="ansi"

    M="${user.lightVimTheme}"
    N="${user.darkVimTheme}"

    C="\$LIGHT_FZF_TAB"
    D="\$DARK_FZF_TAB"

    sed -i "s/$Y/$X/" ~/.config/alacritty/alacritty.toml
    sed -i "s/$A/$B/" ~/.zstuff
    sed -i "s/$C/$D/" ~/.zstuff
    sed -i "s/$M/$N/" ~/.zstuff
  '';

  pfire = pkgs.writeScriptBin "pfire" ''
    #! /usr/bin/env bash
    firefox --private-window
  '';
  c-unsecure = pkgs.writeScriptBin "c-unsecure" ''
    #! /usr/bin/env bash 
    chromium --disable-web-security --user-data-dir="Public/chromium"
  '';
  watchexec = pkgs.writeScriptBin "watchexec" ''
    #! /usr/bin/env bash
    echo "watching..."
    while inotifywait -e close_write $1; do $1; done
  '';
  nix-watch-exec = pkgs.writeScriptBin "nix-watch-exec" ''

    #!/usr/bin/env bash
    echo "watching..."
    while inotifywait -e close_write "$1"; do
    	nix eval --expr "builtins.getAttr \"x\" (import $(realpath "$1") { lib = (import <nixpkgs> {}).lib; })" --impure
    done
  '';

  keys = pkgs.writeScriptBin "keys" ''
    #! /usr/bin/env bash

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
  controlcaps = pkgs.writeScriptBin "controlcaps" ''
    #! /usr/bin/env bash
    xmodmap -e "remove Lock = Caps_Lock" 
    xmodmap -e "remove Control = Control_L"
    xmodmap -e "remove Lock = Control_L" 
    xmodmap -e "remove Control = Caps_Lock"
    xmodmap -e "keysym Control_L = Caps_Lock"
    xmodmap -e "keysym Caps_Lock = Control_L"
    xmodmap -e "add Lock = Caps_Lock" 
    xmodmap -e "add Control = Control_L" 
  '';
  trips4 = pkgs.writeScriptBin "trips4" ''
    #! /usr/bin/env bash
    xrandr --auto --output HDMI2 --primary --mode 1920x1080 --same-as eDP1
    xrandr --auto --output DP1 --mode 2560x1440 --left-of eDP1
    xwallpaper --screen 0 --stretch ~/.background-image
    xwallpaper --screen 1 --stretch ~/.background-image
  '';
  trips5 = pkgs.writeScriptBin "trips5" ''
    #! /usr/bin/env bash
    xrandr \
    --output DP-1 --mode 2560x1440 --pos 0x0 --rotate left \
    --output DP-2 --off \
    --output DP-3 --off \
    --output HDMI-1 --mode 1920x1080 --pos 1440x1480 --rotate normal
    xwallpaper --output DP-1 --zoom ~/.background-image
    xwallpaper --output HDMI-1 --stretch ~/.background-image
  '';

  trips10 = pkgs.writeScriptBin "trips10" ''
    #! /usr/bin/env bash

     xrandr \
     --output eDP-1 --off \
     --output HDMI-1 --off \
     --output DP-1 --mode 3440x1440 --pos 1920x0 --rotate normal \
     --output DP-2 --off \
     --output DP-3 --off \
     --output DP-4 --off

     xwallpaper --screen 0 --zoom ~/.background-image

  '';
  trips11 = pkgs.writeScriptBin "trips11" ''
    #! /usr/bin/env bash

    xrandr eDP-1 --mode 1920x1200 --pos 0x0 --rotate normal 
    xwallpaper --screen 0 --zoom ~/.background-image
  '';

  mprezrez = pkgs.writeScriptBin "mprezrez" ''
    #! /usr/bin/env bash
    xrandr --output eDP1 --mode 1920x1200
    controlcaps
  '';
  xwall = pkgs.writeScriptBin "xwall" ''
    #! /usr/bin/env bash
    xwallpaper --screen 0 --stretch ~/.background-image
  '';

  monitorsDisconnected = pkgs.writeScriptBin "monitorsDisconnected" ''
    #! /usr/bin/env zsh
    xrandr --output HDMI2 --off --output DP1 --off
  '';
  robl = pkgs.writeScriptBin "robl" (builtins.readFile ./robl);
  oneoff = pkgs.writeScriptBin "oneoff" (builtins.readFile ./oneoff.sh);
  nixrun = pkgs.writeScriptBin "nixrun" (builtins.readFile ./nixrun.sh);
  rave-connect = pkgs.writeScriptBin "rave-connect" (builtins.readFile ./rave-connect.sh);
  dorebase = pkgs.writeScriptBin "dorebase" (builtins.readFile ./dorebase.sh);

in
{
  home.packages = [
    changefont
    allight
    aldark
    pfire
    c-unsecure
    watchexec
    nix-watch-exec
    keys
    trips4
    trips5
    trips10
    trips11
    monitorsDisconnected
    robl
    oneoff
    nixrun
    rave-connect
    controlcaps
    mprezrez
    xwall
    dorebase
  ];
}
