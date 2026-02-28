{
  pkgs,
  lib,
  config,
  ...
}:

{

  programs.sway.enable = true;
  programs.sway.wrapperFeatures.gtk = true;
  programs.ssh.startAgent = true;
  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

}
