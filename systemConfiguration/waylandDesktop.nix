{ ... }:

{

  programs.sway.enable = true;
  programs.sway.wrapperFeatures.gtk = true;
  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;
  xdg.portal.xdgOpenUsePortal = true;

  programs.niri.enable = false;

}
