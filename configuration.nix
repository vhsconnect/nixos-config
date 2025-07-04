{
  pkgs,
  user,
  otherHosts,
  inputs,
  ...
}:
with builtins;
with pkgs;
{
  imports = [

    (./. + "/hardware/${user.host}" + "/hardware-configuration.nix")
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  nix = {
    package = pkgs.nixVersions.stable;
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
      "nixos-config=${/home/common/SConfig/nixos-config/configuration.nix}"
    ];
    registry = {
      nixpkgs = {
        flake = inputs.nixpkgs;
      };
      master = {
        flake = inputs.nixpkgs-master;
      };
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      extra-trusted-substituters = [
        "https://nix-community.cachix.org"
        # "https://cache.iog.io"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      ];
    };
    #cache environments for nix-direnv
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
      access-tokens = github.com=${user.ghk}
    '';
  };

  boot.loader =
    if user.efiBoot then
      {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot${user.bootMountpoint}";
        };
        grub = {
          enable = true;
          devices = [ "nodev" ];
          efiSupport = true;
          useOSProber = true;
        };
      }
    else
      {
        grub = {
          enable = true;
          device = user.mbrDevice;
        };
      };

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  networking = {
    hostName = user.host;
    useDHCP = false;
    networkmanager.enable = true;

    extraHosts =
      if user.isWorkComputer then
        let
          readIfExists = x: if pathExists x then readFile x else "";

          joinFiles = x: concatStringsSep "\n" (map readIfExists x);
        in
        ''
          ${joinFiles [
            /home/vhs/Public/extraHosts
            /home/office/Public/extraHosts
          ]}
        ''
      else
        "";

    firewall = {
      allowedTCPPorts = [
        9000
        3000
        3307
        8080
        3600
      ];
      checkReversePath = false;
    };

  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.libinput = {
    enable = true;
    mouse.accelSpeed = "1.5";
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
    xkb.layout = "us";
    xkb.variant = "altgr-intl";
    videoDrivers = user.gpu;
    deviceSection = ''
      Option "TearFree" "true"
    '';
  };

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.windowManager.icewm.enable = true;

  services.picom = {
    enable = if user.usei3 then true else false;
    vSync = true;
    inactiveOpacity = 0.96;
    fade = true;
    fadeDelta = 8;
    fadeSteps = [
      2.8e-2
      3.0e-2
    ];
  };

  programs.i3lock.enable = if user.usei3 then true else false;

  programs.nm-applet.enable = true;

  programs.niri.enable = false;
  programs.sway.enable = if user.usei3 then false else true;

  hardware.graphics.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
    Policy = {
      AutoEnable = true;
    };
  };

  services.blueman.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = false;
    wireplumber.enable = true;

  };

  users = {
    users.vhs = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [
        "wheel"
        "docker"
        "adbusers"
        "libvirtd"
        "qemu-libvirtd"
        "syncthing"
        "networkmanager"
        "ops"
      ];
    };
    users.office = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [
        "wheel"
        "docker"
        "networkmanager"
        "syncthing"
        "ops"
      ];
    };

    groups.ops.members = [
      "vhs"
      "office"
    ];
    groups.ops.gid = user.opsGID;
    extraGroups.vboxusers.members = [ "vhs" ];
  };

  environment.pathsToLink = [ "/share/zsh" ];
  environment.systemPackages = with pkgs; [
    (python3.withPackages (p: [
      p.pynvim
      p.virtualenv
    ]))
    zsh
    wget
    curl
    firefox
    lm_sensors
    vlc
    gnupg
    htop
    pavucontrol
    nmap
    neovim
    xterm
    xclip
    xorg.xmodmap
    x11_ssh_askpass
    blueman
    nodejs_22
    sysstat
    docker
    docker-compose
    wireguard-tools
    git-crypt
    inputs.basmati.packages.${pkgs.system}.default
  ];

  programs.ssh.askPassword = "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";
  programs.ssh.startAgent = true;
  programs.ssh.extraConfig = "AddKeysToAgent = yes";

  programs.zsh.enable = true;
  programs.fish.enable = false;

  programs.dconf.enable = true;
  programs.gnupg.agent = {
    enable = true;
  };
  programs.adb.enable = true;

  services.openssh.enable = user.enableSSH;

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
    DefaultDeviceTimeoutSec=10s
    TimeoutSec=10s
  '';
  systemd.watchdog.runtimeTime = "20s";

  # systemd.additionalUpstreamSystemUnits = [ "debug-shell.service" ];

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    dataDir = "/home/vhs/Sync";
    configDir = "/home/vhs/.syncthing";
    guiAddress = "localhost:3331";
    user = "vhs";
    group = "ops";
    settings = {
      gui = {
        user = "admin";
        password = user.syncthingGuiPass;
      };

      devices = {
        pinser = {
          id = "V5HK7HA-H564OBH-6SE77S3-RY4AFMR-F3ENF3E-6UV7HSL-CPZ5I6C-SD3HXAQ";
        };
        mpu3 = {
          id = "5XO7ZS3-U7ZD452-Z7U5QI7-K2STPKM-QL7WZBU-GHBHBQR-HR6L57P-32N2VQX";
        };
        mpu4 = {
          id = "MXC4OD2-VXLPIH6-3FGQRL7-AW2YTLZ-FAYEACI-IGXSX5M-DWAUKRH-KSZVFA3";
        };
        mbison = {
          id = "3MOHUU5-GYFZ3WD-O6VI3ZX-RWSBMFP-ZTMKNQ6-5VTXMT3-FVZ377Y-SOPNTQV";
        };
        mbebe = {
          id = "WBPCZ3R-A32TI6D-OR4XP34-2OFBY2J-O2GGES3-Q36MKQ6-E7TBA22-37SPUQW";
        };
      };
      folders = {
        "/home/vhs/Sync" = {
          id = "sync";
          devices = [
            "mbison"
            "mpu3"
            "mpu4"
            "mbebe"
          ];
        };
        "/home/vhs/Sync2" = {
          id = "sync2";
          devices = [
            "mbison"
            "pinser"
          ];
        };
        "/home/common/Folder" = {
          id = "folder";
          devices = [
            "mbison"
            "mpu3"
            "mpu4"
            "mbebe"
          ];
        };
      };
    };
  };

  programs.steam = {
    enable = false;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  services.fwupd.enable = false;

  #scheduling process used by pulseaudio
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  security.sudo.wheelNeedsPassword = false;

  security.polkit = {
    enable = true;
  };

  system.stateVersion = "20.09";
}
