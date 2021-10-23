{ config, pkgs, options, ... }:
{

  imports = [
    ./hardware-configuration.nix
  ];

  nix.nixPath =
    [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

  networking.hostName = "mpu3";
  time.timeZone = "Europe/Paris";

  networking.useDHCP = false;
  networking.extraHosts = ''
    ${builtins.readFile /home/vhs/Public/extraHosts}
  '';

  i18n.defaultLocale = "en_US.UTF-8";

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
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.layout = "us";
  services.printing.enable = true;
  sound.enable = true;
  hardware.opengl.enable = true;
  hardware.pulseaudio.enable = true;
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

  users.users.vhs = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" ];
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


  services.logind.extraConfig = ''
    HandlePowerKey=suspend
    IdleAction=hybrid-sleep
    IdleActionSec=1m
  '';



  services.globalprotect = {
    enable = true;
  };

  services.cron =
    {
      enable = true;
      systemCronJobs = [
        "* * * * * vhs  . /etc/profile; sh /home/vhs/bin/cronscripts/copy-nix-config"
      ];
    };

  # programs.xss-lock.enable = true;




  virtualisation.docker.enable = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?


  systemd.timers.suspend-on-low-battery = {
    wantedBy = [ "multi-user.target" ];
    timerConfig = {
      OnUnitActiveSec = "120";
    };
  };

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
}

