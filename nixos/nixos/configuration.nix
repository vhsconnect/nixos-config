{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
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
      wallpaper = { combineScreens = true; };
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
    # xautolock = {
    #   enable = true;
    #   enableNotifier = true;
    #   notifier = ''${pkgs.libnotify}/bin/notify-send "Locking .-. "'';
    # };
  };
  services.xserver.desktopManager.gnome3.enable = true;
  services.xserver.layout = "us";
  services.printing.enable = true;
  sound.enable = true;
  hardware.opengl.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.config = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };
  services.blueman.enable = true;
  services.xserver.libinput.enable = true;
  services.xserver.videoDrivers = ["intel"];
  services.xserver.deviceSection = ''
    Option "TearFree" "true"
  '';
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
    inactiveOpacity = 0.85;
  };

  users.users.vhs = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs;
  let 
    myPy3Packages = python-packages: with python-packages; [
      pandas
      pynvim
      virtualenv
    ];
    python3Plus = python3.withPackages myPy3Packages;
  in [
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
    nmap
    networkmanager
    pavucontrol
    xfce.terminal
    pavucontrol
    scrot
    xclip
    xscreensaver
    blueman
    x11_ssh_askpass
    nodejs
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

  # programs.xss-lock.enable = true;


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


  services.cron =
    {
      enable = true;
      systemCronJobs = [
        "* * * * * vhs  . /etc/profile; sh /home/vhs/bin/cronscripts/copy-nix-config"
        "* * * * * vhs echo Hello World > /home/vhs/cronout"
      ];
    };

  security.wrappers.node = {
    source = "${pkgs.nodejs}/bin/node";
    capabilities = "cap_net_bind_service=+ep";
  };
}

