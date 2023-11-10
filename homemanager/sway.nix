{ inputs
, config
, home
, user
, lib
, pkgs
, ...
}:
let
  modifier = "Mod4";
  theme = import (./themes/. + "/${user.theme}.nix");
in
{
  home.packages = with pkgs; [
    kanshi
    xdg-desktop-portal-wlr
    swaylock
    shotman
    grim
  ];

  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;
    xwayland = true;
    config.modifier = modifier;
    config.bars = [ ];
    config.gaps = {
      outer = 8;
      inner = 10;
    };
    config.keybindings = lib.mkOptionDefault {
      "${modifier}+Return" = "exec --no-startup-id alacritty";
      "${modifier}+Escape" = "kill";
      "${modifier}+g" = "exec gnome-screenshot -a";

      "${modifier}+h" = "focus left";
      "${modifier}+j" = "focus down";
      "${modifier}+k" = "focus up";
      "${modifier}+l" = "focus right";

      "${modifier}+Shift+h" = "move left";
      "${modifier}+Shift+j" = "move down";
      "${modifier}+Shift+k" = "move up";
      "${modifier}+Shift+l" = "move right";

      "${modifier}+d" = ''
        exec "rofi -lines 4 -run-command '/usr/bin/env zsh -c -i {cmd}' -show run"
      '';

      "${modifier}+backslash" = "scratchpad show";
      "${modifier}+slash" = "move scratchpad";

      "${modifier}+Print" = ''exec ${pkgs.grim}/bin/grim \"''${HOME}/screenshot-$(date '+%s').png\"'';
      "${modifier}+Shift+Print" = ''exec ${pkgs.grim}/bin/grim  -g \"$(slurp)\" \"''${HOME}/screenshot-$(date '+%s').png\"'';

      "${modifier}+Next" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +10";
      "${modifier}+Prior" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 10-";

      "${modifier}+Tab" = "workspace prev";
      "${modifier}+Shift+Tab" = "workspace next";
      "F2" = "exec rofi -show emoji -modi emoji";
      "F6" = "exec amixer set Master 5%-";
      "F7" = "exec amixer set Master 5%+";
      #"F9" >> reserved for mpx-gromit
      "F10" = "exec xscreensaver-command -lock";
      #"F11" >> reserved for full screen
    };
    config.keycodebindings = lib.mkOptionDefault {
      "121" = "exec pamixer -m";
      "122" = "exec pamixer -d 5";
      "123" = "exec pamixer -i 5";
    };
    config.modes = {
      resize = {
        k = "resize shrink height 10 px or 10 ppt";
        j = "resize grow height 10 px or 10 ppt";
        l = "resize grow width 10 px or 10 ppt";
        h = "resize shrink width 10 px or 10 ppt";
        Escape = "mode default";
        Return = "mode default";
      };
    };
    config.startup = [
      { command = "systemctl --user import-environment"; }
      # { command = "keys"; }
      # { command = "long-command & sleep 2; trips4"; always = true; }
      # { command = "xset -dpms"; always = true; }
      # { command = "gromit-mpx"; notification = false; }
      # { command = "blueman-applet"; }
    ];
    config.window.border = 1;
    config.workspaceAutoBackAndForth = true;
    config.colors = {
      focused = {
        background = "${theme.main}";
        border = "${theme.main}";
        childBorder = "${theme.secondary}";
        indicator = "${theme.main}";
        text = "${theme.secondary}";
      };
      focusedInactive = {
        background = "${theme.secondary}";
        border = "${theme.secondary}";
        childBorder = "${theme.main}";
        indicator = "${theme.secondary}";
        text = "${theme.accent2}";
      };
      unfocused = {
        background = "${theme.secondary}";
        border = "${theme.secondary}";
        childBorder = "${theme.main}";
        indicator = "${theme.secondary}";
        text = "${theme.secondary}";
      };
      urgent = {
        background = "${theme.secondary}";
        border = "${theme.accent2}";
        childBorder = "${theme.accent2}";
        indicator = "${theme.secondary}";
        text = "${theme.secondary}";
      };
    };
    extraSessionCommands = ''
      export WLC_REPEAT_DELAY=200;
      export WLC_REPEAT_RATE=30;
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';

    extraConfig = ''
      input "type:keyboard" {
        # xkb_options
        xkb_options ctrl:swap_lalt_lctl,caps:super
      }

      output * background ~/.background-image fill


        for_window [window_type="dialog"] floating enable
        for_window [window_type="utility"] floating enable
        for_window [window_type="toolbar"] floating enable
        for_window [window_type="splash"] floating enable
        for_window [window_type="menu"] floating enable
        for_window [window_type="dropdown_menu"] floating enable
        for_window [window_type="popup_menu"] floating enable
        for_window [window_type="tooltip"] floating enable
        for_window [window_type="notification"] floating enable

        exec --no-startup-id export QT_QPA_PLATFORMTHEME=qt5ct
    '';
  };
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: ${user.font};
      }
      window#waybar {
        background: ${theme.secondary};
        color: ${theme.main};
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 60;
        output = [
          "eDP-1"
          "HDMI-1"
        ];
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-right = [ "pulseaudio" "battery" "memory" "clock" ];

        "clock" = {
          interval = 60;
          tooltip = true;
          format = "{:%H.%M}";
          tooltip-format = "{:%Y-%m-%d}";
        };

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };
        "battery" = {
          interval = 60;
          format = "{icon} {capacity}% ";
          format-icons = [ "" ];
        };
        "memory" = {
          format-icons = [ "" ];
          format = "{icon} {percentage}% ";
        };
        "pulseaudio" = {
          format-icons = [ "" ];
          format = "{icon} {volume}% ";
        };
      };
    };
  };
}
