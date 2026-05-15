{
  user,
  pkgs,
  ...
}:
let
  theme = import (../themes/. + "/${user.theme}.nix");
  script = ''
    DIRECTION=$1
    WS_DIR=$2

    # Get geometry of focused window and the workspace area
    TREE=$(swaymsg -t get_tree)

    FOCUSED=$(echo "$TREE" | jq '.. | objects | select(.focused? == true)')
    F_X=$(echo "$FOCUSED" | jq '.rect.x')
    F_Y=$(echo "$FOCUSED" | jq '.rect.y')
    F_W=$(echo "$FOCUSED" | jq '.rect.width')
    F_H=$(echo "$FOCUSED" | jq '.rect.height')

    # Get current workspace rect
    WS=$(swaymsg -t get_workspaces | jq '.[] | select(.focused==true)')
    WS_X=$(echo "$WS" | jq '.rect.x')
    WS_Y=$(echo "$WS" | jq '.rect.y')
    WS_W=$(echo "$WS" | jq '.rect.width')
    WS_H=$(echo "$WS" | jq '.rect.height')

    # Check if window is flush against the edge in the given direction
    case "$DIRECTION" in
        left)  AT_EDGE=$(( F_X <= WS_X )) ;;
        right) AT_EDGE=$(( F_X + F_W >= WS_X + WS_W )) ;;
        up)    AT_EDGE=$(( F_Y <= WS_Y )) ;;
        down)  AT_EDGE=$(( F_Y + F_H >= WS_Y + WS_H )) ;;
    esac

    if [ "$AT_EDGE" = "1" ]; then
        swaymsg workspace "$WS_DIR"_on_output
    else
        swaymsg focus "$DIRECTION"
    fi

  '';

  move_flip = pkgs.writeScriptBin "exe" script;

in
{
  imports = [ ./waybar2.nix ];
  home.packages = with pkgs; [
    swaylock
    swayidle
    wl-clipboard
    shotman
    grim
    xscreensaver
    font-awesome
    wdisplays
    xorg.xhost
  ];

  services.cliphist = {
    enable = true;
    extraOptions = [
      "-max-dedupe-search"
      "10"
      "-max-items"
      "100"
    ];
  };

  programs.zsh.shellAliases = {
    clip = "cliphist-rofi | rofi -show -dmenu| wl-copy";
  };

  home.file = {

    ".config/xkb/keymap/k400.xkb" = {
      enable = true;

      text = ''
        xkb_keymap {
        	xkb_keycodes  { include "evdev+aliases(qwerty)"	};
        	xkb_types     { include "complete"	};
        	xkb_compat    { include "complete"	};
        	xkb_symbols   { 
        		include "pc+us+inet(evdev)"
            replace key <I171> { [ i, I ] };
            replace key <I122> { [ 0 ] };
            replace key <I172> { [ 7 ] };
            replace key <I173> { [ 6 ] };
            replace key <MUTE> { [ o, O ] }; 
        	};
        	xkb_geometry  { include "pc(pc105)"	};
        };

      '';
    };

    ".config/sway/config" = {
      enable = true;

      text = builtins.concatStringsSep "\n" [
        (builtins.readFile ../sway/config)
        (if user.host == "mbison" then "workspace 10 output DP-2" else "")
        #
        ''

          output * background ~/.background-image fill

          bar {
            swaybar_command ${pkgs.waybar}/bin/waybar
          }

          set $left h
          set $down j
          set $up k
          set $right l

          # Move your focus around
          bindsym $mod+$left focus left
          bindsym $mod+$down exec "${move_flip}/bin/exe down next"
          bindsym $mod+$up exec "${move_flip}/bin/exe up previous"
          bindsym $mod+$right focus right
          # Or use $mod+[up|down|left|right]
          bindsym $mod+Left focus left
          bindsym $mod+Down focus down
          bindsym $mod+Up focus up
          bindsym $mod+Right focus right

          # Move the focused window with the same, but add Shift
          bindsym $mod+Shift+$left move left
          bindsym $mod+Shift+$down move down
          bindsym $mod+Shift+$up move up
          bindsym $mod+Shift+$right move right
          # Ditto, with arrow keys
          bindsym $mod+Shift+Left move left
          bindsym $mod+Shift+Down move down
          bindsym $mod+Shift+Up move up
          bindsym $mod+Shift+Right move right

          mode "resize" {
              bindsym $left resize shrink width 20px
              bindsym $down resize grow height 20px
              bindsym $up resize shrink height 20px
              bindsym $right resize grow width 20px

              # Ditto, with arrow keys
              bindsym Left resize shrink width 20px
              bindsym Down resize grow height 20px
              bindsym Up resize shrink height 20px
              bindsym Right resize grow width 20px

              # Return to default mode
              bindsym Return mode "default"
              bindsym Escape mode "default"
          }



          client.focused          ${theme.secondary} ${theme.secondary} ${theme.main} ${theme.secondary}
          client.focused_inactive ${theme.main} ${theme.main} ${theme.secondary} ${theme.secondary}
          client.unfocused        ${theme.main} ${theme.main} ${theme.secondary} ${theme.secondary}
          client.urgent           ${theme.secondary} ${theme.accent2} ${theme.accent2} ${theme.secondary}


          # startup applications
          exec "sh -c 'sleep 2s' && ${pkgs.blueman}/bin/blueman-applet" 
          exec "sh -c 'sleep 2s' && ${pkgs.networkmanagerapplet}/bin/nm-applet" 
          exec "sh -c 'sleep 2s' && ${pkgs.jamesdsp}/bin/jamesdsp --tray" 
          exec_always ${user.monitorsCmd}

        ''
      ];
    };

  };

}
