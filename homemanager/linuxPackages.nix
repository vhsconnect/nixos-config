{ pkgs, ... }:
{
  home.packages = with pkgs; [
    file
    nix-doc
    steam-run
    libsForQt5.qt5ct
    inotify-tools
    acpi
    coreutils
    lxqt.lxqt-sudo
    lxqt.lxqt-openssh-askpass
    lxappearance
    networkmanagerapplet
    pamixer
    xfce.thunar
    xorg.xmodmap
    xorg.xev
    xwallpaper
    nautilus
    nix-output-monitor
    lsof
  ];
}
