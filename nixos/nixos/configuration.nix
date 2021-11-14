{ config, pkgs, options, ... }:
{

  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  nix.nixPath =
    [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=/home/vhs/Repos/nixos-config/nixos/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.hostName = "mpu3";
  networking.useDHCP = false;
  networking.extraHosts = ''
    ${builtins.readFile /home/vhs/Public/extraHosts}
  '';


  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      wallpaper = { mode = "fill"; combineScreens = false; };
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
    xautolock = {
      enable = true;
      time = 30;
      enableNotifier = true;
      notifier = ''${pkgs.libnotify}/bin/notify-send "Locking .-. "'';
      locker = ''${pkgs.xscreensaver}/bin/xscreensaver-command -lock'';
    };
  };

  #gnome
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;

  services.xserver.layout = "us";
  services.printing.enable = true;
  sound.enable = true;
  hardware.opengl.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
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
    backend = "glx";
    vSync = true;
    inactiveOpacity = 0.93;
    fade = true;
    fadeDelta = 10;
    fadeSteps = [ 0.04 0.04 ];

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
      extraGroups = [ "wheel" "docker" ];
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
      nmap
      pavucontrol
      xfce.terminal
      pavucontrol
      xclip
      xscreensaver
      blueman
      x11_ssh_askpass
      nodejs-16_x
      networkmanager-openconnect
      gnome.networkmanager-openconnect
      globalprotect-openconnect
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

  services.openssh.enable = true;
  services.xserver.autoRepeatDelay = 200;
  services.xserver.autoRepeatInterval = 25;


  services.globalprotect = {
    enable = true;
  };

  services.cron =
    {
      enable = true;
      systemCronJobs = [
        "* * * * * root  . /etc/profile; sh cleanhome"
      ];
    };


  security.rtkit.enable = true;

  security.polkit = {
    enable = true;
  };

  security.wrappers.node = {
    owner = "vhs";
    group = "wheel";
    source = "${pkgs.nodejs-16_x}/bin/node";
    capabilities = "cap_net_bind_service=+ep";
  };

  #cache environments for nix-direnv
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  system.stateVersion = "20.09"; #do not change
}

