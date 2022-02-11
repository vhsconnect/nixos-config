{ config, lib, pkgs, ... }:
let
  font = (import ./user.nix).font;
in
{
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.terminator}/bin/terminator";
    package = with pkgs; rofi.override { plugins = [ rofi-calc rofi-emoji ]; };
    font = "${font} Medium 14";
    theme =
      let mkLitteral = config.lib.formats.rasi.mkLiteral;
      in
      with
      (import ./themes/current.nix).theme;
      {
        "*" = {
          background-color = mkLitteral main;
          border-color = mkLitteral main;
          text-color = mkLitteral secondary;
          spacing = 0;
          width = mkLitteral "512px";
        };

        inputbar = {
          border = mkLitteral "0 0 1px 0";
          children = map mkLitteral [ "prompt" "entry" ];
        };

        prompt = {
          padding = mkLitteral "16px";
          border = mkLitteral "0 1px 0 0";
        };

        textbox = {
          background-color = mkLitteral main;
          border = mkLitteral "0 0 1px 0";
          border-color = mkLitteral secondary;
          padding = mkLitteral "8px 16px";
        };

        entry = { padding = mkLitteral "16px"; };

        listview = {
          cycle = true;
          margin = mkLitteral "0 0 -1px 0";
          scrollbar = false;
        };

        element = {
          border = mkLitteral "1px";
          # border-color = mkLitteral accent;
          padding = mkLitteral "8px";
        };

        element-icon = {
          size = mkLitteral "28px";
          border = mkLitteral "0 4px";
          # border-color = mkLitteral accent;
        };

        "element selected" = {
          background-color = mkLitteral accent2;
          border-color = mkLitteral accent2;
          color = mkLitteral secondary;
        };
      };

    extraConfig = {
      max-history-size = 4;
      show-icons = false;
      modi = "drun,emoji,ssh";
      display-run = "> ";
      kb-row-up = "Up,Control+k";
      kb-row-down = "Down,Control+j";
      kb-accept-entry = "Control+m,Return,KP_Enter";
      kb-remove-to-eol = "Control+Shift+e";
      kb-mode-next = "Shift+Right,Control+Tab";
      kb-mode-previous = "Shift+Left,Control+Shift+Tab";
      kb-remove-char-back = "BackSpace";
    };
  };
}


