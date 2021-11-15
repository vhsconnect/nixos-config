{ pkgs, ... }:

{
  gtk.enable = true;
  gtk.gtk3 = {
    bookmarks = [
      "file:///home/vhs/Downloads"
      "file:///home/vhs/Documents"
      "file:///home/vhs/Repos"
      "file:///home/vhs/Music"
      "file:///home/vhs/Pictures"
      "file:///home/vhs/Videos"
    ];
    extraConfig =
      {
        gtk-theme-name = "Arc-Dark";
        gtk-icon-theme-name = "Paper";
        gtk-font-name = "Iosevka Light 13";
        gtk-cursor-theme-name = "capitaine-cursors-light";
        gtk-cursor-theme-size = "14";
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
}

