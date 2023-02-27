{ config, pkgs, lib, options, user, inputs, ... }:
{
  imports = [
    (
      ./. +
      "/hardware/${user.host}" +
      "/hardware-configuration.nix"
    )
    # ./work.nix 
  ];
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixFlakes;
    nixPath =
      [
        "nixpkgs=${inputs.nixpkgs}"
        "nixos-config=${/home/vhs/SConfig/nixos-config/configuration.nix}"
      ];
    registry = {
      nixos = {
        flake = inputs.nixpkgs;
      };
      nixpkgs = {
        flake = inputs.nixpkgs;
      };
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
    };
    #cache environments for nix-direnv
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
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

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.hostName = user.host;
  networking.useDHCP = false;
  networking.extraHosts =
    if user.isWorkComputer then ''
      ${builtins.readFile /home/vhs/Public/extraHosts}
    '' else "";

  sound.enable = true;

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 30;
    desktopManager = {
      xterm.enable = false;
      wallpaper = { mode = "max"; combineScreens = false; };
    };
    displayManager = {
      defaultSession = "none+i3";
    };
  };

  #icewm
  services.xserver.windowManager.icewm.enable = true;

  #printing
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.openFirewall = true;
  services.avahi.nssmdns = true;
  services.printing.drivers = [ pkgs.cnijfilter2 ];

  #gnome
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.layout = "us";
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
      neovim
      xfce.xfce4-terminal
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
      enable = true;
      systemCronJobs = [
        "* * * * * root  . /etc/profile; sh cleanhome"
      ];
    };

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
    DefaultDeviceTimeoutSec=10s
    TimeoutSec=10s
  '';
  systemd.watchdog.runtimeTime = "20s";

  # systemd.additionalUpstreamSystemUnits = [ "debug-shell.service" ];

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

  services.bbrf = {
    enable = true;
    user = "vhs";
    port = 8335;
    faderValue = 40;
  };

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  system.stateVersion = "20.09"; #do not change
}


