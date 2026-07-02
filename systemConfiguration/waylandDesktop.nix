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

  environment.systemPackages = with pkgs; [ kanshi ];

  environment.sessionVariables.QML_IMPORT_PATH = lib.makeSearchPath "lib/qt-6/qml" [
    pkgs.kdePackages.qt5compat
    pkgs.kdePackages.qtbase
    pkgs.kdePackages.qtdeclarative
    pkgs.kdePackages.qtmultimedia
  ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  systemd.user.services.kanshi = {
    enable = true;
    description = "kanshi daemon";
    wantedBy = [ "sway-session.target" ];
    bindsTo = [ "sway-session.target" ];
    after = [ "sway-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.kanshi}/bin/kanshi";
      Restart = "on-failure";
    };
  };

}
