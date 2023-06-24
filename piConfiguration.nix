{ config, pkgs, user, ... }:

{

  imports = [
    (
      ./. +
      "/hardware/${user.host}" +
      "/hardware-configuration.nix"
    )
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  nix.extraOptions = "experimental-features = nix-command flakes";

  networking.hostName = "munin";
  networking.wireless.enable = true;
  networking.wireless.interfaces = [ "wlan0" ];
  networking.wireless.networks.${user.network1}.psk = user.psk;
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  time.timeZone = "Europe/Paris";

  users.users.vhs = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  programs.vim.defaultEditor = true;

  # gpg
  services.pcscd.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; pinentryFlavor = "gtk2"; };


  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;

  services.bbrf = {
    enable = true;
    user = "vhs";
    faderValue = 60;
    port = 8898;
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      localhost = {
        forceSSL = false;
        enableACME = false;
        locations."/" = { proxyPass = "http://localhost:8898"; };
      };
    };
  };


  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
  ];

  system.stateVersion = "23.05";

}
