{
  inputs,
  config,
  user,
  lib,
  pkgs,
  ...
}:
let
  modifier = "Mod4";
  theme = import (../themes/. + "/${user.theme}.nix");
in
{
  home.packages = with pkgs; [
    #swaynotificationcenter
    #xdg-desktop-portal-wlr
    kanshi
    swaylock
    wl-clipboard
    shotman
    grim
    wofi
    font-awesome
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
    clip = "cliphist-rofi | wofi -show -dmenu| wl-copy";
  };

  home.file = {

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


          for_window [app_id=".*"] border pixel 2

          default_border pixel 2
          default_floating_border normal

          gaps inner 5
          gaps outer 5

          client.focused          ${theme.main} ${theme.main} ${theme.secondary} ${theme.secondary}
          client.focused_inactive ${theme.secondary} ${theme.secondary} ${theme.main} ${theme.secondary}
          client.unfocused        ${theme.secondary} ${theme.secondary} ${theme.main} ${theme.secondary}
          client.urgent           ${theme.secondary} ${theme.accent2} ${theme.accent2} ${theme.secondary}


          # startup applications
          exec ${pkgs.blueman}/bin/blueman-applet

        ''
      ];
    };

  };

  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
      target = "sway-session.target";
    };
  };

}
