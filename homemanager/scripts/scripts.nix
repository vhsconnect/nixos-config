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
  allight = pkgs.writeScriptBin "allight" ''
    #! /usr/bin/env bash

    A="ansi"
    B="GitHub"

    M="${user.darkVimTheme}"
    N="${user.lightVimTheme}"

    C="\$DARK_FZF_TAB"
    D="\$LIGHT_FZF_TAB"

    chterm --pick=${user.lightAlacrittyTheme}.toml -t

    sed -i "s/$A/$B/" ~/.zstuff
    sed -i "s/$C/$D/" ~/.zstuff
    sed -i "s/$M/$N/" ~/.zstuff
  '';
  aldark = pkgs.writeScriptBin "aldark" ''
    #! /usr/bin/env bash

    A="GitHub"
    B="ansi"

    M="${user.lightVimTheme}"
    N="${user.darkVimTheme}"

    C="\$LIGHT_FZF_TAB"
    D="\$DARK_FZF_TAB"

    chterm --pick=${user.darkAlacrittyTheme}.toml -t

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
    #!/usr/bin/env bash
    xrandr 
    --output DisplayPort-0 --primary --mode 2560x1440 --pos 0x0 --rotate left \
    --output DisplayPort-1 --off \
    --output DisplayPort-2 --off \
    --output HDMI-A-0 --mode 1920x1080 --pos 1440x967 --rotate normal
    xwallpaper --output DisplayPort-0 --zoom ~/.background-image
    xwallpaper --output HDMI-A-0 --stretch ~/.background-image
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
  chterm = pkgs.writeScriptBin "chterm" (builtins.readFile ./chterm.sh);
  changefont = pkgs.writeScriptBin "changefont" ''
    chterm -f "${fontString}"
  '';
  changetheme = pkgs.writeScriptBin "changetheme" ''
    chterm -t
  '';

in
{
  home.packages = [
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
    xwall
    dorebase
    changefont
    changetheme
    chterm
  ];
}
