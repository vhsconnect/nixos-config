{ config
, pkgs
, user
, otherHosts
, inputs
, ...
}: {
  imports = [
    (
      ./.
      + "/hardware/${user.host}"
      + "/hardware-configuration.nix"
    )
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  nix = {
    package = pkgs.nixFlakes;
    nixPath = [
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
    if user.efiBoot
    then {
      efi = { canTouchEfiVariables = true; };
      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
      };
    }
    else {
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
    if user.isWorkComputer
    then ''
      ${builtins.readFile /home/vhs/Public/extraHosts}
    ''
    else "";

  sound.enable = true;

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 30;
    exportConfiguration = true;
    desktopManager = {
      xterm.enable = false;
      wallpaper = {
        mode = "max";
        combineScreens = false;
      };
    };
    layout = "us";
    xkbVariant = "altgr-intl";
    libinput.enable = true;
    libinput.mouse.accelSpeed = "1.5";
    # nvidia driver in hardware file
    videoDrivers =
      if user.nvidia || user.amd
      then [ "" ]
      else [ "intel" ];
    deviceSection = ''
      Option "TearFree" "true"
    '';
  };

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.windowManager.icewm.enable = true;

  services.picom = {
    enable =
      if user.usei3
      then true
      else false;
    vSync = true;
    inactiveOpacity = 0.86;
    fade = true;
    fadeDelta = 8;
    fadeSteps = [ 0.028 0.03 ];
  };

  programs.nm-applet.enable =
    if user.usei3
    then true
    else false;
  programs.sway.enable =
    if user.usei3
    then false
    else true;

  #printing
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.openFirewall = true;
  services.avahi.nssmdns = true;
  services.printing.drivers = [ pkgs.cnijfilter2 ];

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
      extraGroups = [ "wheel" "docker" "adbusers" "libvirtd" "qemu-libvirtd" "syncthing" ];
    };
    extraGroups.vboxusers.members = [ "vhs" ];
  };

  networking.firewall.allowedTCPPorts = [ 9000 3000 8080 ];
  networking.firewall.checkReversePath = false;

  environment.pathsToLink = [ "/share/zsh" ];
  environment.systemPackages = with pkgs; [
    (python3.withPackages (p: [
      p.pynvim
      p.virtualenv
    ]))
    zsh
    wget
    curl
    vim
    firefox
    lm_sensors
    vlc
    gnupg
    htop
    jq
    docker
    virt-manager
    pavucontrol
    nmap
    neovim
    xfce.xfce4-terminal
    xclip
    blueman
    xscreensaver
    x11_ssh_askpass
    nodejs-18_x
    globalprotect-openconnect
    sysstat
    docker-compose
    wireguard-tools
  ];

  programs.ssh.askPassword = "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";
  programs.zsh.enable = true;
  programs.dconf.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.adb.enable = true;

  services.openssh.enable = false;
  services.globalprotect.enable = false;

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
    DefaultDeviceTimeoutSec=10s
    TimeoutSec=10s
  '';
  systemd.watchdog.runtimeTime = "20s";

  # systemd.additionalUpstreamSystemUnits = [ "debug-shell.service" ];

  # services.logind.extraConfig = ''
  #   # LidSwitchIgnoreInhibited=no
  #   # KillUserProcesses=no
  #   # HandleLidSwitch=suspend
  #   # HandleLidSwitchDocked=ignore
  #   # HandleLidSwitchExternalPower=ignore
  #   # IdleActionSec=14400
  #   # IdleAction=ignore
  # '';

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    dataDir = "/home/vhs/Sync";
    guiAddress = "localhost:3331";
    user = "vhs";
    devices = {
      mpu3 = {
        id = "L43ZWPA-U4E7MHP-SCW7QBM-OMARWJI-SJH4O2Y-JCAXGZR-TGOH6NS-JGUXFAZ";
        addresses = [
          "tcp://${otherHosts.mpu3.ip}:22000"
        ];
      };
      mbison = {
        id = "4SVW3SW-J6KKKYN-FOAQFOQ-7K2XKRT-OODPP5T-KKWO5ZL-QXSP4GP-P4M4LAW";
        addresses = [
          "tcp://${otherHosts.mbison.ip}:22000"
        ];
      };
    };
    folders = {
      "/home/vhs/Sync" = {
        id = "sync";
        devices = [ "mbison" "mpu3" ];
      };
    };
  };

  services.fwupd.enable = false;

  #scheduling process used by pulseaudio
  security.rtkit.enable = true;

  security.sudo.wheelNeedsPassword = false;

  security.polkit = {
    enable = true;
  };

  security.wrappers.node = {
    owner = "vhs";
    group = "wheel";
    source = "${pkgs.nodejs-18_x}/bin/node";
    #capabilities = "cap_net_bind_service=+ep";
  };

  services.bbrf = {
    enable = true;
    user = "vhs";
    port = 3335;
    faderValue = 30;
  };

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  system.stateVersion = "20.09"; #do not change
}
