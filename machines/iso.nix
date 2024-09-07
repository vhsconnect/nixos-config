{ lib, ... }:
{
  system = "x86_64-linux";
  modules = [
    (
      {
        pkgs,
        modulesPath,
        lib,
        ...
      }:
      {
        imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
        boot.kernelPackages = pkgs.linuxPackages_latest;
        boot.supportedFilesystems = lib.mkForce [
          "btrfs"
          "reiserfs"
          "vfat"
          "f2fs"
          "xfs"
          "ntfs"
          "cifs"
        ];
        environment.systemPackages = with pkgs; [
          firefox
          git
          neovim
          curl
        ];
      }
    )
  ];
}
