{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vivid
    paper-icon-theme
    adapta-gtk-theme
    arc-theme
    # font-awesome
    xfce.xfce4-icon-theme
    papirus-icon-theme
  ];
}
