{
  user,
  pkgs,
  ...
}:
let
  theme = import (../themes/. + "/${user.theme}.nix");
  script1 = ''

    #!/usr/bin/env bash
    DIRECTION=$1
    FORWARD=$2

    TREE=$(swaymsg -t get_tree)
    FOCUSED=$(echo "$TREE" | jq '.. | objects | select(.focused? == true)')
    F_Y=$(echo "$FOCUSED" | jq '.rect.y')
    F_H=$(echo "$FOCUSED" | jq '.rect.height')

    WS=$(swaymsg -t get_workspaces | jq '.[] | select(.focused==true)')
    WS_Y=$(echo "$WS" | jq '.rect.y')
    WS_H=$(echo "$WS" | jq '.rect.height')
    WS_NUM=$(echo "$WS" | jq '.num')
    CURRENT_OUTPUT=$(echo "$WS" | jq -r '.output')

    OUTPUT_WS=$(swaymsg -t get_workspaces | jq "[.[] | select(.output==\"$CURRENT_OUTPUT\") | .num] | sort[]")

    case "$DIRECTION" in
        up)   AT_EDGE=$(( F_Y <= WS_Y + 20 )) ;;
        down) AT_EDGE=$(( F_Y + F_H >= WS_Y + WS_H - 20 )) ;;
    esac

    if [ "$AT_EDGE" = "1" ]; then
        if [ "$FORWARD" = "1" ]; then
            TARGET=$(echo "$OUTPUT_WS" | awk -v cur="$WS_NUM" '$1 > cur {print $1; exit}')
        else
            TARGET=$(echo "$OUTPUT_WS" | awk -v cur="$WS_NUM" '$1 < cur {print $1}' | tail -1)
        fi

        if [ -n "$TARGET" ]; then
            swaymsg workspace "$TARGET"
        fi
    else
        swaymsg focus "$DIRECTION"
    fi

  '';

  script2 =
    # bash
    ''

      #!/usr/bin/env bash
      MODE=$1
      DIRECTION=$2
      FORWARD=$3

      TREE=$(swaymsg -t get_tree)
      EFFECTIVE=$(echo "$TREE" | jq '
          def effective_ancestor($root):
              . as $current_id |
              ($root | [.. | objects | select(
                  .nodes? and (.nodes | type == "array") and
                  (.nodes | any(.id? == $current_id))
              )] | last) as $parent |
              if ($parent | type) == "object" and
                 ($parent.layout? == "tabbed" or $parent.layout? == "stacked") then
                  $parent.id | effective_ancestor($root)
              else
                  $current_id
              end
          ;

          . as $root |
          ($root | .. | objects | select(.focused? == true) | .id) | effective_ancestor($root) as $eid |
          $root | .. | objects | select(.id? == $eid) | .rect
      ')
      E_Y=$(echo "$EFFECTIVE" | jq '.y')
      E_H=$(echo "$EFFECTIVE" | jq '.height')

      WS=$(swaymsg -t get_workspaces | jq '.[] | select(.focused==true)')
      WS_Y=$(echo "$WS" | jq '.rect.y')
      WS_H=$(echo "$WS" | jq '.rect.height')
      WS_NUM=$(echo "$WS" | jq '.num')
      CURRENT_OUTPUT=$(echo "$WS" | jq -r '.output')

      OUTPUT_WS=$(swaymsg -t get_workspaces | jq "[.[] | select(.output==\"$CURRENT_OUTPUT\") | .num] | sort[]")

      case "$DIRECTION" in
          up)   AT_EDGE=$(( E_Y <= WS_Y + 20 )) ;;
          down) AT_EDGE=$(( E_Y + E_H >= WS_Y + WS_H - 20 )) ;;
      esac

      if [ "$AT_EDGE" = "1" ]; then
          if [ "$FORWARD" = "1" ]; then
              TARGET=$(echo "$OUTPUT_WS" | awk -v cur="$WS_NUM" '$1 > cur {print $1; exit}')
          else
              TARGET=$(echo "$OUTPUT_WS" | awk -v cur="$WS_NUM" '$1 < cur {print $1}' | tail -1)
          fi

          if [ -n "$TARGET" ]; then
              case "$MODE" in
                  focus) swaymsg workspace "$TARGET" ;;
                  move)  swaymsg move container to workspace "$TARGET", workspace "$TARGET" ;;
              esac
          fi
      else
          case "$MODE" in
              focus) swaymsg focus "$DIRECTION" ;;
              move)  swaymsg move "$DIRECTION" ;;
          esac
      fi

    '';

  move = pkgs.writeScriptBin "exe" script2;

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
          bindsym $mod+$down exec "${move}/bin/exe focus down 1"
          bindsym $mod+$up exec "${move}/bin/exe focus up 0"
          bindsym $mod+$right focus right
          # Or use $mod+[up|down|left|right]
          bindsym $mod+Left focus left
          bindsym $mod+Down focus down
          bindsym $mod+Up focus up
          bindsym $mod+Right focus right

          # Move the focused window with the same, but add Shift
          bindsym $mod+Shift+$left move left
          bindsym $mod+Shift+$right move right

          # Move the focused window across workspaces
          bindsym $mod+Shift+$down exec "${move}/bin/exe move down 1"
          bindsym $mod+Shift+$up exec "${move}/bin/exe move up 0"

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
