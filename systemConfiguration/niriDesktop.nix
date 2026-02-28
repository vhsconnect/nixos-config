{
  pkgs,
  lib,
  config,
  ...
}:

{

  programs.niri.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.QML_IMPORT_PATH = lib.makeSearchPath "lib/qt-6/qml" [
    pkgs.kdePackages.qt5compat
    pkgs.kdePackages.qtbase
    pkgs.kdePackages.qtdeclarative
    pkgs.kdePackages.qtmultimedia
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ ];
  };

  environment.systemPackages = with pkgs; [
    swaylock
    swayidle
    swaybg
    fuzzel # launcher
    mako # notification daemon
    wl-clipboard
    wlr-randr
    grim
    slurp
    wallust
    cliphist
    swappy
    kanshi
    brightnessctl
    playerctl
    pavucontrol
    wdisplays
  ];

}
