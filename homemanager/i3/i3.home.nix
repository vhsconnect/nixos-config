{
  config,
  pkgs,
  lib,
  user,
  ...
}: let
  theme = import (../themes/. + "/${user.theme}.nix");
  i3BlocksConfig = config.xdg.configFile."i3blocks/config".source;
  modifier = config.xsession.windowManager.i3.config.modifier;
  secondaryFont = user.secondaryFont;
in {
  imports = [
    ./i3blocks/blockScripts.nix
  ];
  xsession.windowManager.i3.enable = true;
  xsession.windowManager.i3.config.modifier = "Mod1";
  xsession.windowManager.i3.config.gaps = {
    outer = 5;
    inner = 5;
  };
  xsession.windowManager.i3.config.keybindings = lib.mkOptionDefault {
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

    "${modifier}+Tab" = "workspace prev";
    "${modifier}+Shift+Tab" = "workspace next";
    "F2" = "exec rofi -show emoji -modi emoji";
    "F3" = "exec eww open --toggle quick-menu";
    "F4" = "exec bluetoothctl power off";
    "F6" = "exec amixer set Master 5%-";
    "F7" = "exec amixer set Master 5%+";
    #"F9" >> reserved for mpx-gromit
    "F10" = "exec xscreensaver-command -lock";
    #"F11" >> reserved for full screen
  };
  xsession.windowManager.i3.config.keycodebindings = lib.mkOptionDefault {
    "121" = "exec pamixer -m";
    "122" = "exec pamixer -d 5";
    "123" = "exec pamixer -i 5";
  };
  xsession.windowManager.i3.config.modes = {
    resize = {
      k = "resize shrink height 10 px or 10 ppt";
      j = "resize grow height 10 px or 10 ppt";
      l = "resize grow width 10 px or 10 ppt";
      h = "resize shrink width 10 px or 10 ppt";
      Escape = "mode default";
      Return = "mode default";
    };
  };
  xsession.windowManager.i3.config.startup = [
    {command = "systemctl --user import-environment";}
    # { command = "keys"; }
    {
      command = "long-command & sleep 2; trips4";
      always = true;
    }
    {
      command = "xset -dpms";
      always = true;
    }
    {
      command = "gromit-mpx";
      notification = false;
    }
    {command = "blueman-applet";}
  ];
  xsession.windowManager.i3.config.bars = [];
  xsession.windowManager.i3.config.window.border = 1;
  xsession.windowManager.i3.config.workspaceAutoBackAndForth = true;
  xsession.windowManager.i3.config.colors = {
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
      text = "${theme.secondary}";
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

  xsession.windowManager.i3.extraConfig = ''
    bar {
      status_command i3blocks -c ${i3BlocksConfig}
      font pango: ${secondaryFont} Regular 13
      colors {
        background ${theme.main}
        focused_workspace ${theme.secondary} ${theme.secondary} ${theme.main}
        active_workspace ${theme.main} ${theme.main} ${theme.accent2}
        inactive_workspace ${theme.main} ${theme.main} ${theme.secondary}
        urgent_workspace ${theme.urgent} ${theme.urgent} ${theme.secondary}
        separator ${theme.secondary}
      }
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

    exec --no-startup-id export QT_QPA_PLATFORMTHEME=qt5ct
  '';
}
