# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelParams = [ "systemd.debug-shell=1" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/1db1b002-b984-4b1d-92af-8156c2b87247";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/8C09-582A";
      fsType = "vfat";
    };

  fileSystems."/home/vhs/Data" =
    {
      device = "/dev/disk/by-uuid/d536bf84-da2d-49ad-83df-710d3d0daf23";
      fsType = "ext4";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/fb2fd9c3-0a5a-4de6-b05d-ed44f2589cab"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  #hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
