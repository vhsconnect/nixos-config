{ user
, pkgs
, ...
}:
let
  theme = import (../themes/. + "/${user.theme}.nix");
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
        ''

          output * background ~/.background-image fill

          bar {
            swaybar_command ${pkgs.waybar}/bin/waybar
          }


          for_window [window_type="dialog"] floating enable
          for_window [window_type="utility"] floating enable
          for_window [window_type="toolbar"] floating enable
          for_window [window_type="splash"] floating enable
          for_window [window_type="menu"] floating enable
          for_window [window_type="dropdown_menu"] floating enable
          for_window [window_type="popup_menu"] floating enable
          for_window [window_type="tooltip"] floating enable
          for_window [window_type="notification"] floating enable


          for_window [app_id=".*"] border pixel 1

          default_border pixel 1
          default_floating_border normal

          gaps inner 5
          gaps outer 5

          client.focused          ${theme.secondary} ${theme.secondary} ${theme.main} ${theme.secondary}
          client.focused_inactive ${theme.main} ${theme.main} ${theme.secondary} ${theme.secondary}
          client.unfocused        ${theme.main} ${theme.main} ${theme.secondary} ${theme.secondary}
          client.urgent           ${theme.secondary} ${theme.accent2} ${theme.accent2} ${theme.secondary}


          # startup applications
          exec "sh -c 'sleep 2s' && ${pkgs.blueman}/bin/blueman-applet" 
          exec_always ${user.monitorsCmd}

        ''
      ];
    };

  };

}
