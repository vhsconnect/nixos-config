{ config, pkgs, ... }:
let
  font = (import ../../../../user.nix).font;
  theme = (import ../../nixpkgs/themes/current.nix).theme;
in
{
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Pop";
      package = pkgs.pop-icon-theme;
      size = "16x16";
    };
    settings = with config.lib.base16.theme; {
      global = {
        monitor = 0;
        geometry = "600x50-50+65";
        shrink = "yes";
        transparency = 10;
        padding = 16;
        horizontal_padding = 16;
        frame_width = 3;
        frame_color = theme.main;
        separator_color = "frame";
        font = "${font} Regular 10";
        line_height = 4;
        idle_threshold = 120;
        markup = "full";
        format = ''<b>%s</b>\n%b'';
        alignment = "left";
        vertical_alignment = "center";
        icon_position = "left";
        max_icon_size = 16;
        word_wrap = "yes";
        ignore_newline = "no";
        show_indicators = "yes";
        sort = true;
        stack_duplicates = true;
        startup_notification = true;
        hide_duplicate_count = true;
      };
      urgency_low = {
        background = theme.accent;
        foreground = theme.main;
        frame_color = theme.main;
        timeout = 4;
      };
      urgency_normal = {
        background = theme.accent;
        foreground = theme.main;
        frame_color = theme.main;
        timeout = 4;
      };
      urgency_critical = {
        background = theme.urgent;
        foreground = theme.main;
        frame_color = theme.urgent;
        timeout = 10;
      };
      shortcuts = { close = "ctrl+q"; };
    };
  };
}
