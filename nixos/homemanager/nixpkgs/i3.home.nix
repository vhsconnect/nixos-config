{ config, pkgs, lib, ... }:
let
  colors = import ./colors.nix;
  black = "#282430";
  white = "#F9F9F9";
  red = "#e85a62";
  olive = "#B6C867";
  mint = "#CDF0EA";
  pink = "#F7DBF0";
  purple = "#BEAEE2";
  purplegray = "#878194";
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
      "${modifier}+Return" = "exec terminator";
      "${modifier}+Escape" = "kill";

      "${modifier}+h" = "focus left";
      "${modifier}+j" = "focus down";
      "${modifier}+k" = "focus up";
      "${modifier}+l" = "focus right";

      "${modifier}+Shift+h" = "move left";
      "${modifier}+Shift+j" = "move down";
      "${modifier}+Shift+k" = "move up";
      "${modifier}+Shift+l" = "move right";

      "${modifier}+d" = "exec zsh -c 'rofi -show run'";

      "${modifier}+backslash" = "scratchpad show";
      "${modifier}+slash" = "move scratchpad";

      "${modifier}+Tab" = "workspace prev";
      "${modifier}+Shift+Tab" = "workspace next";
      "F6" = "exec amixer set Master 10%-";
      "F7" = "exec amixer set Master 10%+";
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
  ];
  xsession.windowManager.i3.config.bars = [ ];
  xsession.windowManager.i3.config.window.border = 1;
  xsession.windowManager.i3.config.workspaceAutoBackAndForth = true;
  xsession.windowManager.i3.config.colors = {
    focused = {
      background = "${colors.brown}";
      border = "${colors.brown}";
      childBorder = "${colors.brown}";
      indicator = "${colors.brown}";
      text = "${white}";
    };
    focusedInactive = {
      background = "${colors.white}";
      border = "${colors.white}";
      childBorder = "${colors.white}";
      indicator = "${colors.white}";
      text = "${white}";
    };
    unfocused = {
      background = "${colors.white}";
      border = "${colors.white}";
      childBorder = "${colors.white}";
      indicator = "${colors.white}";
      text = "${white}";
    };
    urgent = {
      background = "${colors.white}";
      border = "${colors.white}";
      childBorder = "${colors.white}";
      indicator = "${colors.white}";
      text = "${white}";
    };
  };


  xsession.windowManager.i3.extraConfig =
    ''
      bar {
              status_command i3blocks -c ${i3BlocksConfig}
              font pango: MesloLGLDZ Nerd Font Regular 13
              colors {
                      background ${colors.brown}
                      focused_workspace ${colors.white} ${colors.white} ${colors.brown}
                      active_workspace ${purplegray} ${purplegray} ${colors.white}
                      inactive_workspace ${colors.brown} ${colors.brown} ${colors.white}
                      urgent_workspace ${mint} ${mint} ${colors.white}
                      separator ${colors.white}
                      }
      }
    '';
}
