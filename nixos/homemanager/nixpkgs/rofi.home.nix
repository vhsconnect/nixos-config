{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi.override {
      plugins = [ pkgs.rofi-emoji ];
    };
    terminal = "${pkgs.terminator}/bin/terminator";
    theme = "${config.xdg.configFile."rofi/rofi-theme.rasi".source}";
  };
}
