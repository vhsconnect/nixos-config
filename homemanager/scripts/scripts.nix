{
  pkgs,
  lib,
  user,
  ...
}:
with lib;
with builtins;
let
  fonts = (import ../fonts.nix { }).fonts;
  fontString = pipe fonts [
    (map (mapAttrs (key: value: ''${key}:${value}'')))
    (fold (a: b: a // b) { })
    attrValues
    (concatStringsSep " ")
  ];

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

    # system lightmode 
    ${pkgs.dconf}/bin/dconf write \
            /org/gnome/desktop/interface/color-scheme "'prefer-light'"

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

    # system darkmode
    ${pkgs.dconf}/bin/dconf write \
            /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
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
    	nix eval --expr "builtins.getAttr \"x\" (import $(realpath "$1") { lib = (import <nixpkgs> {}).lib;  pkgs = (import <nixpkgs> {}).pkgs; })" --impure
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
  clone = pkgs.writeScriptBin "clone" ''
    #! /usr/bin/env fish

    argparse 'u/user=' -- $argv


    if set -q _flag_help
        echo "Usage: script_name [options] [positional arguments]"
        echo "Options:"
        echo "  -h/--help     Show this help message"
        echo "  -u/--user     User name (required)"
        return 0
    end


    if not set -q _flag_user
        echo "Error: --user option is required"
        return 1
    end

    if test -z "$_flag_user"
        echo "Error: --user must have a value"
        return 1
    end


    echo $_flag_user

    gh repo list $_flag_user --limit 100 --json name | jq 'map(.name)' | jq -r '.[]' | fzf | xargs -I {} bash -c "gh repo clone '$_flag_user/{}'"

  '';
  changels = pkgs.writeScriptBin "changels" (builtins.readFile ./chls.fish);
  changecompletion = pkgs.writeScriptBin "changecompletion" ''
    #! /usr/bin/env bash

    Y="export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=$1'"
    sed -i "/ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE/c\\$Y" ~/.zstuff
  '';
  pskill = pkgs.writeScriptBin "pskill" ''
    #! /usr/bin/env bash

    search_term="$1"

    selected_processes=$(ps -e |
    	grep -i "$search_term" |
    	fzf --multi \
    		--header="kill" \
    		--layout=reverse \
    		--border \
    		--preview="echo {}" \
    		--preview-window=down:3:wrap)

    pids=$(echo "$selected_processes" | awk '{print $1}')

    for pid in $pids; do
    	if kill -15 "$pid" 2>/dev/null; then
    		echo "$pid stopped gracefully"
    	else
    		if kill -9 "$pid" 2>/dev/null; then
    			echo "$pid force killed"
    		else
    			echo "$pid is going berserk, failed to force kill"
    		fi
    	fi
    done

  '';
  vpn = pkgs.writeScriptBin "vpn" ''
    #! /usr/bin/env fish 

    set configPath /home/vhs/SShark/

    switch $argv[1]
        case -c
            set selected_path (find $configPath -type f | fzf --height 40% --reverse)
            if test -n "$selected_path"
                nmcli connection import type wireguard file $selected_path
            end
        case -d
            set deletion_config (nmcli connection show | grep wireguard | awk '{print $1}' | fzf --height 40%)
            nmcli connection delete "$deletion_config"
        case '*'
            echo "Usage: "(status filename)" [-c|-d]"
            echo "  -c    Connect mode - select path with fzf"
            echo "  -d    Disconnect mode"
            exit 1
    end

  '';

in
{
  imports = [ ./displays.nix ];

  home.packages = [
    allight
    aldark
    pfire
    c-unsecure
    watchexec
    nix-watch-exec
    keys
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
    clone
    changels
    changecompletion
    pskill
    vpn
  ];
}
