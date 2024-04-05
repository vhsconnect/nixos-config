{ config
, pkgs
, user
, otherHosts
, inputs
, ...
}:
{
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
      "nixos-config=${/home/common/SConfig/nixos-config/configuration.nix}"
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
    then
      let
        joinFiles = x:
          builtins.concatStringsSep "\n" (map builtins.readFile x);
      in
      ''
            ${joinFiles [
        /home/vhs/Public/extraHosts
        /home/office/Public/extraHosts
            ]}
      ''
    else "";




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

  sound.enable = false;

  services.blueman.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  users = {
    users.vhs = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "docker" "adbusers" "libvirtd" "qemu-libvirtd" "syncthing" ];
    };
    users.office = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "docker" "adbusers" ];
    };
    groups.ops.members = [ "vhs" "office" ];
    extraGroups.vboxusers.members = [ "vhs" ];
  };


  networking.firewall.allowedTCPPorts =
    [ 9000 3000 8080 ]
    ++
    (if user.bbrf then [ 80 ] else [ ]);

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
    x11_ssh_askpass
    nodejs-18_x
    sysstat
    docker-compose
    wireguard-tools
    git-crypt
  ];

  programs.virt-manager.enable = true;

  programs.ssh.askPassword = "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";
  programs.ssh.startAgent = true;
  programs.ssh.extraConfig = "AddKeysToAgent = yes";

  programs.zsh.enable = true;
  programs.dconf.enable = true;
  programs.gnupg.agent = {
    enable = true;
  };
  programs.adb.enable = true;

  services.openssh.enable = user.enableSSH;
  services.globalprotect.enable = false;

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
    configDir = "/home/vhs/.config/syncthing";
    guiAddress = "localhost:3331";
    user = "vhs";
    settings = {
      devices = {
        mpu3 = {
          id = "PJDMPH6-X54CFSG-FFD4AXU-WULBFHJ-KJTGW3Q-DU7GRRV-LTHXKVD-ZGV3TQK";
          addresses = [
            "tcp://${otherHosts.mpu3.ip}:22000"
          ];
        };
        mpu4 = {
          id = "HGCCQ7Y-APY3WFT-6HHX37C-7NV3ZMR-2EQ2HNW-4IEG3KS-UZHF5KW-KFAEIAU";
          addresses = [
            "tcp://${otherHosts.mpu4.ip}:22000"
          ];
        };
        mbison = {
          id = "O3BZUDC-PZCKNWW-VPF53TP-6VXBUBQ-NKNIE6S-3OFE6VK-AZME2JV-WYG7ZQF";
          addresses = [
            "tcp://${otherHosts.mbison.ip}:22000"
          ];
        };
      };
      folders = {
        "/home/vhs/Sync" = {
          id = "sync";
          devices = [ "mbison" "mpu3" "mpu4" ];
        };
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

  services.bbrf = {
    enable = user.bbrf;
    user = "vhs";
    port = 8898;
    faderValue = 25;
    itemsPerPage = 4500;
  };

  services.nginx = {
    enable = user.bbrf;
    virtualHosts = {
      localhost = {
        forceSSL = false;
        enableACME = false;
        locations."/" = { proxyPass = "http://localhost:8898"; };
      };
    };
  };


  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  system.stateVersion = "20.09"; #do not change
}
