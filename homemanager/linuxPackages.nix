{pkgs, ...}:{

home.packages = with pkgs; [

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
];
}
