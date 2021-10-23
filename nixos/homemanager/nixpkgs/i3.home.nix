{ config, pkgs, lib, ... }:
let
  theme = (import ./themes/current.nix).theme;
  i3BlocksConfig = config.xdg.configFile."i3blocks/config".source;
  modifier = config.xsession.windowManager.i3.config.modifier;
in
{
  xsession.windowManager.i3.enable = true;
  xsession.windowManager.i3.package = pkgs.i3-gaps;
  xsession.windowManager.i3.config.modifier = "Mod1";
  xsession.windowManager.i3.config.gaps = {
    outer = 5;
    inner = 5;
  };
  xsession.windowManager.i3.config.keybindings =
    lib.mkOptionDefault {
      "${modifier}+Return" = "exec --no-startup-id terminator";
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

      # "${modifier}+d" = "exec zsh -c 'rofi -show run'";
      "${modifier}+d" = ''
        exec "rofi -run-command '/usr/bin/env zsh -c -i {cmd}' -show run"
      '';

      "${modifier}+backslash" = "scratchpad show";
      "${modifier}+slash" = "move scratchpad";

      "${modifier}+Tab" = "workspace prev";
      "${modifier}+Shift+Tab" = "workspace next";
      "F2" = "exec rofi -show emoji -modi emoji";
      "F6" = "exec amixer set Master 10%-";
      "F7" = "exec amixer set Master 10%+";
      #"F9" >> reserved for mpx-gromit
      "XF86AudioRaiseVolume" = "exec amixer -D pulse sset Master 5%+";
      "XF86AudioLowerVolume" = "exec amixer -D pulse sset Master 5%-";
      "XF86AudioMute" = "exec amixer -D pulse sset Master 0%";
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
    # { command = "exec_always --no-startup-id xss-lock -- xscreensaver-command -lock"; }
    { command = "systemctl --user import-environment"; }
    { command = "i3-msg workspace 1"; }
    { command = "~/bin/keys"; }
    { command = "exec --no-startup-id /.nix-profile/libexec/polkit-gnome-authentication-agent-1 &"; }
    # { command = "exec --no-startup-id gromit-mpx"; }
    # { command = "exec --no-startup-id blueman-applet"; }
  ];
  xsession.windowManager.i3.config.bars = [ ];
  xsession.windowManager.i3.config.window.border = 1;
  xsession.windowManager.i3.config.workspaceAutoBackAndForth = true;
  xsession.windowManager.i3.config.colors = {
    focused = {
      background = "${theme.main}";
      border = "${theme.secondary}";
      childBorder = "${theme.secondary}";
      indicator = "${theme.main}";
      text = "${theme.secondary}";
    };
    focusedInactive = {
      background = "${theme.secondary}";
      border = "${theme.main}";
      childBorder = "${theme.main}";
      indicator = "${theme.secondary}";
      text = "${theme.secondary}";
    };
    unfocused = {
      background = "${theme.secondary}";
      border = "${theme.main}";
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


  xsession.windowManager.i3.extraConfig =
    ''
      bar {
              status_command i3blocks -c ${i3BlocksConfig}
              font pango: MesloLGLDZ Nerd Font Regular 13
              colors {
                      background ${theme.main}
                      focused_workspace ${theme.secondary} ${theme.secondary} ${theme.main}
                      active_workspace ${theme.accent} ${theme.accent} ${theme.secondary}
                      inactive_workspace ${theme.main} ${theme.main} ${theme.secondary}
                      urgent_workspace ${theme.urgent} ${theme.urgent} ${theme.secondary}
                      separator ${theme.secondary}
                      }
      }
      exec --no-startup-id export QT_QPA_PLATFORMTHEME=qt5ct
    '';
}
