{ config, pkgs, ... }:
let
  source = fetchTarball {
    name = "base16";
    url = "https://github.com/atpotts/base16-nix/archive/4f192af.tar.gz";
    sha256 = "1yf59vpd1i8lb2ml7ha8v6i4mv1b0xwss8ngzw08s39j838gyx6h";
  };
  font = (import ./user.nix).font;
in
{
  imports = [ "${source}/base16.nix" ];

  # More schemes at: https://github.com/atpotts/base16-nix/blob/master/schemes.json
  themes.base16 = {
    enable = true;
    scheme = "rebecca";
    variant = "rebecca";
  };

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
        frame_color = "${base00-hex}";
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
        background = "#${base04-hex}";
        foreground = "#${base07-hex}";
        frame_color = "#${base0D-hex}";
        timeout = 4;
      };
      urgency_normal = {
        background = "#${base04-hex}";
        foreground = "#${base07-hex}";
        frame_color = "#${base0D-hex}";
        timeout = 4;
      };
      urgency_critical = {
        background = "#${base0F-hex}";
        foreground = "#${base07-hex}";
        frame_color = "#${base05-hex}";
        timeout = 10;
      };
      shortcuts = { close = "ctrl+space"; };
    };
  };
}
#based on theme by github/gvolpe
