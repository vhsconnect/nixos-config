{ pkgs, config, ... }:

{

  programs.sway.enable = true;
  programs.sway.wrapperFeatures.gtk = true;
  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  programs.niri.enable = false;

}
