{ inputs
, _imports
, pkgs
, system
, user
, ...
}:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [ "electron-22.3.27" ];
    };
    overlays = import ./overlays.nix inputs system;
  };
  imports = _imports;

  ######## programs ########
  programs.home-manager.enable = true;
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd . --hidden";
    changeDirWidgetCommand = "fd --type d --hidden --no-ignore";
    changeDirWidgetOptions = [
      "--preview 'tree -C {} | head -500'"
      "--border"
    ];
  };
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = false;
  programs.autojump = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.broot = {
    enable = true;
    settings.modal = true;
    enableZshIntegration = true;
  };
  programs.htop = {
    enable = true;
    settings = {
      left_meters = [
        "LeftCPUs2"
        "Memory"
        "Swap"
      ];
      left_right = [
        "RightCPUs2"
        "Tasks"
        "LoadAverage"
        "Uptime"
      ];
      setshowProgramPath = false;
      treeView = true;
    };
  };
  programs.lazygit.enable = true;

  ######## home ########
  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "xfce4-terminal";
    SUDO_ASKPASS = "lxqt-openssh-askpass";
    TMPDIR = "/home/vhs/Public/tmp";
  };

  home.username = "vhs";
  home.homeDirectory = "/home/vhs";

  ######## fonts ########
  fonts.fontconfig.enable = true;

  ######## services ########
  services.gnome-keyring.enable = true;
  services.gpg-agent.enable = true;

  ######### X11 ############
  services.gammastep = {
    enable = user.nightMode;
    dawnTime = "6:00-7:45";
    duskTime = "18:00-19:05";
    longitude = "59.3";
    latitude = "18.0";
    temperature.day = 4800;
    tray = true;
  };

  #IMPORTANT
  home.stateVersion = "21.03";
}
