{ config
, pkgs
, user
, ...
}:
let
  font = user.font;
  theme = import (../themes/. + "/${user.theme}.nix");
in
{
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Pop";
      package = pkgs.pop-icon-theme;
      size = "32x32";
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
        frame_color = theme.secondary;
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
        background = theme.accent3;
        foreground = theme.secondary;
        frame_color = theme.secondary;
        timeout = 4;
      };
      urgency_normal = {
        background = theme.accent3;
        foreground = theme.secondary;
        frame_color = theme.secondary;
        timeout = 4;
      };
      urgency_critical = {
        background = theme.urgent;
        foreground = theme.secondary;
        frame_color = theme.urgent;
        timeout = 10;
      };
      shortcuts = { close = "ctrl+q"; };
    };
  };
}
