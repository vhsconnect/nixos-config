{ config, pkgs, options, ... }:
let
  user = (import ../homemanager/nixpkgs/user.nix);
  nodejs-overlay = self: super: {
    nodejs-16_x = super.nodejs-16_x.overrideAttrs
      (old: {
        buildInputs = old.buildInputs ++ [ pkgs.makeWrapper ];
        postInstall = old.postInstall or "" + ''
          wrapProgram "$out/bin/node" --set TMPDIR  --set TMP "/home/vhs/tmp/"
        '';
      });
  };
  nvim-nightly-overlay = (import (builtins.fetchTarball {
    url = https://github.com/vhsconnect/neovim-nightly-overlay/archive/master.tar.gz;
  }));
in
{
  imports = [
    /etc/nixos/hardware-configuration.nix
    # ./work.nix
  ];

  nix = {
    nixPath =
      [
        "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
        "nixos-config=/home/vhs/Repos/nixos-config/nixos/nixos/configuration.nix"
        "/nix/var/nix/profiles/per-user/root/channels"
      ];
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    autoOptimiseStore = true;
    #cache environments for nix-direnv
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };


  boot.loader =
    if user.efiBoot then {
      efi = { canTouchEfiVariables = true; };
      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
      };
    } else {
      grub = {
        enable = true;
        device = user.mbrDevice;
      };
    };

  nixpkgs.overlays = [ nvim-nightly-overlay ];
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.hostName = "mpu3";
  networking.useDHCP = false;
  networking.extraHosts = ''
    ${builtins.readFile /home/vhs/Public/extraHosts}
  '';

  sound.enable = true;

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 25;
    desktopManager = {
      xterm.enable = false;
      wallpaper = { mode = "max"; combineScreens = false; };
    };
    displayManager = {
      defaultSession = "none+i3";
    };
    windowManager.i3 = {
      package = pkgs.i3-gaps;
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3blocks
      ];
    };
  };

  #gnome
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.layout = "us";
  services.printing.enable = true;
  hardware.opengl.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
    Policy = {
      AutoEnable = false;
    };
  };
  services.blueman.enable = true;
  services.xserver.libinput.enable = true;
  services.xserver.videoDrivers = [ "intel" ];
  services.xserver.deviceSection = ''
    Option "TearFree" "true"
  '';
  services.picom = {
    enable = true;
    vSync = true;
    inactiveOpacity = 0.86;
    fade = true;
    fadeDelta = 8;
    fadeSteps = [ 0.028 0.03 ];
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users = {
    users.vhs = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "docker" "adbusers" "libvirtd" "qemu-libvirtd" ];
    };
    extraGroups.vboxusers.members = [ "vhs" ];
  };

  environment.pathsToLink = [ "/share/zsh" ];

  environment.systemPackages = with pkgs;
    let
      myPy3Packages = python-packages: with python-packages; [
        pandas
        pynvim
        virtualenv
      ];
      python3Plus = python3.withPackages myPy3Packages;
    in
    [
      python3Plus
      zsh
      wget
      curl
      vim
      firefox
      vlc
      gnupg
      htop
      jq
      neofetch
      docker
      pavucontrol
      nmap
      neovim-nightly
      xfce.terminal
      xclip
      xscreensaver
      blueman
      x11_ssh_askpass
      nodejs-16_x
      globalprotect-openconnect
      sysstat
      docker-compose
      virt-manager
      ponysay
    ];

  programs.nm-applet.enable = true;
  programs.ssh.askPassword = "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";
  programs.zsh.enable = true;
  programs.dconf.enable = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.adb.enable = true;

  services.openssh.enable = false;
  services.globalprotect.enable = true;
  services.cron =
    {
      enable = false;
      systemCronJobs = [
        "* * * * * root  . /etc/profile; sh cleanhome"
      ];
    };


  systemd.services.radio = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "start myRadio server";
    serviceConfig = {
      Type = "simple";
      User = "vhs";
      ExecStart = ''${pkgs.nodejs-16_x}/bin/node /home/vhs/.npm-global/bin/myradio'';
    };
  };

  services.logind.extraConfig = ''
    LidSwitchIgnoreInhibited=no
    KillUserProcesses=no
    HandleLidSwitch=suspend
    HandleLidSwitchDocked=ignore
    HandleLidSwitchExternalPower=ignore
    IdleActionSec=14400 
    IdleAction=ignore
  '';

  services.fwupd.enable = false;

  security.rtkit.enable = true;
  security.sudo.wheelNeedsPassword = false;

  security.polkit = {
    enable = true;
  };

  security.wrappers.node = {
    owner = "vhs";
    group = "wheel";
    source = "${pkgs.nodejs-16_x}/bin/node";
    capabilities = "cap_net_bind_service=+ep";
  };

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  system.stateVersion = "20.09"; #do not change
}


