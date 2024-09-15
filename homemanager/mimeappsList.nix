{ ... }:
let
  defaultEditor = "gnvim";
in
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
      "inode/directory" = [ "Thunar.desktop" ];
      "text/plain" = [ "${defaultEditor}.desktop" ];
      "text/markdown" = [ "${defaultEditor}.desktop" ];
      "application/ogg" = [ "vlc.desktop" ];
      "video/ogg" = [ "vlc.desktop" ];
      "video/x-msvideo" = [ "vlc.desktop" ];
      "video/quicktime" = [ "vlc.desktop" ];
      "video/webm" = [ "vlc.desktop" ];
      "video/x-flv" = [ "vlc.desktop" ];
      "video/mp4" = [ "vlc.desktop" ];
      "video/mkv" = [ "vlc.desktop" ];
      "audio/mpeg" = [ "vlc.desktop" ];
      "audio/opus" = [ "vlc.desktop" ];
      "audio/wav" = [ "vlc.desktop" ];
      "audio/x-flac" = [ "vlc.desktop" ];
      "audio/mp4" = [ "vlc.desktop" ];
      "application/x-flash-video" = [ "vlc.desktop" ];
      "text/html" = [ "firefox.desktop;" ];
      "x-scheme-handler/http" = [ "firefox.desktop;" ];
      "x-scheme-handler/https" = [ "firefox.desktop;" ];
      "x-scheme-handler/ftp" = [ "firefox.desktop;" ];
      "x-scheme-handler/chrome" = [ "firefox.desktop;" ];
      "x-scheme-handler/msteams" = [ "teams.desktop" ];
      "application/x-extension-htm" = [ "firefox.desktop;" ];
      "application/x-extension-html" = [ "firefox.desktop;" ];
      "application/x-extension-shtml" = [ "firefox.desktop;" ];
      "application/xhtml+xml" = [ "firefox.desktop;" ];
      "application/x-extension-xhtml" = [ "firefox.desktop;" ];
      "application/x-extension-xht" = [ "firefox.desktop;" ];
    };
  };
}
