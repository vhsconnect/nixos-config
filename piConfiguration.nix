{ pkgs, user, ... }:
{
  imports = [ (./. + "/hardware/${user.host}" + "/hardware-configuration.nix") ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  nix.extraOptions = "experimental-features = nix-command flakes";

  nixpkgs.buildPlatform = {
    config = "x86_64-unknown-linux-gnu";
    system = "x86_64-linux";
  };

  networking.hostName = "munin";
  networking.wireless.enable = true;
  networking.wireless.interfaces = [ "wlan0" ];
  networking.wireless.networks.${user.network1}.psk = user.psk;
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    21
    80
    443
  ];
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 51000;
      to = 51999;
    }
  ];

  time.timeZone = "Europe/Paris";
  security.sudo.wheelNeedsPassword = false;
  users.users.vhs = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBhw5g6xfxbwPcjThdsTYAk6fH/juhIXameVa21j+seG ${user.email}"
    ];
  };

  programs.vim.defaultEditor = true;

  # gpg
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gtk2";
  };

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;

  services.vsftpd = {
    enable = true;
    writeEnable = true;
    localRoot = "/home/vhs/Data";
    localUsers = true;
    userlist = [ "vhs" ];
    extraConfig = ''
      pasv_enable=Yes
      pasv_min_port=51000
      pasv_max_port=51999
    '';
  };

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
        locations."/" = {
          proxyPass = "http://localhost:8898";
        };
      };
    };
  };

  environment.variables.EDITOR = "vim";
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
  ];

  systemd.services.mount-drive-2010 = {
    enable = true;
    after = [ "local-fs.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.util-linux}/bin/mount /dev/disk/by-label/DRIVE2010 /home/vhs/Data/Drive2010";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 50";
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  systemd.timers.mount-drive-2010 = {
    wantedBy = [ "timers.target" ];
    timerConfig.OnBootSec = "2min";
    timerConfig.Unit = "test";
  };

  system.stateVersion = "23.05";
}
