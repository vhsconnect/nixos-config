{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.libimobiledevice
    pkgs.ifuse
  ];
  services.usbmuxd.enable = true;
}
