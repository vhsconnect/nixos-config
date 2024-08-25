{ pkgs, user, ... }:
let
  font = user.font;
  light-icons = user.foreground == "light";
in
{
  gtk.enable = true;
  gtk.gtk3 = {
    extraConfig = {
      gtk-theme-name = "Arc-Dark";
      gtk-icon-theme-name = if light-icons then "Paper" else "Paper-Mono-Dark";
      gtk-font-name = "${font} Light 11";
      # gtk-cursor-theme-name = "capitaine-cursors-light";
      # gtk-cursor-theme-size = "14";
      gtk-toolbar-style = "GTK_TOOLBAR_BOTH_HORIZ";
      gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
      gtk-button-images = "0";
      gtk-menu-images = "0";
      gtk-enable-event-sounds = "1";
      gtk-enable-input-feedback-sounds = "1";
      gtk-xft-antialias = "1";
      gtk-xft-hinting = "1";
      gtk-xft-hintstyle = "hintmedium";
      gtk-xft-rgba = "rgb";
    };
  };
  qt.enable = true;
  qt.platformTheme.name = "qtct";
  qt.style.package = pkgs.adwaita-qt;
  qt.style.name = "adwaita-dark";

  home.pointerCursor = {
    package = pkgs.vanilla-dmz;
    gtk.enable = true;
    x11.enable = true;
    name = "Vanilla-DMZ";
  };
}
