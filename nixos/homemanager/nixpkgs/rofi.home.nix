{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi.override {
      plugins = [ pkgs.rofi-emoji ];
    };
    terminal = "${pkgs.alacritty}/bin/alacritty";
    theme = "${config.xdg.configFile."rofi/rofi-theme.rasi".source}";
  };
}
