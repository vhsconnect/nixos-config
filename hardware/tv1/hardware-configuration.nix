# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config
, lib
, pkgs
, modulesPath
, ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "ohci_pci" "ehci_pci" "ahci" "firewire_ohci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ "wl" ];
  boot.kernelModules = [ "kvm-intel" "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_340;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9565906f-31b4-41fd-96f4-5d149e82fb3d";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/950F-3C22";
    fsType = "vfat";
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/f92fddba-4295-47e0-9e03-e9ea755c16f1"; }];
}
