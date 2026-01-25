{
  pkgs,
  user,
  otherHosts,
  inputs,
  system,
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
      trusted-users = [
        "root"
        "vhs"
        "office"
      ];
      auto-optimise-store = true;
      extra-trusted-substituters = [
        "https://nix-community.cachix.org"
        "https://devenv.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
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

  services.displayManager.autoLogin.enable = user.autoLogin;
  services.displayManager.autoLogin.user = "vhs";

  services.displayManager.gdm.enable = !user.autoLogin;

  # fallback
  services.xserver.windowManager.icewm.enable = !user.autoLogin;

  programs.nm-applet.enable = true;

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

  services.udisks2 = {
    enable = true;
    mountOnMedia = true;
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
        "kvm"
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
        "kvm"
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

  # systemd.settings.Manager = ''
  #   DefaultTimeoutStopSec=10s
  #   DefaultDeviceTimeoutSec=10s
  #   TimeoutSec=10s
  # '';
  systemd.watchdog.runtimeTime = "20s";

  # systemd.additionalUpstreamSystemUnits = [ "debug-shell.service" ];

  programs.steam = {
    enable = false;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  services.fwupd.enable = false;

  #scheduling process used by pulseaudio
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;

  security.sudo.wheelNeedsPassword = false;

  security.polkit = {
    enable = true;
  };

  system.stateVersion = "20.09";
}
