{
  inputs,
  _imports,
  system,
  pkgs,
  ...
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
    TMPDIR = "/home/office/Public/tmp";
  };

  home.username = "office";
  home.homeDirectory = "/home/office";

  ######## fonts ########
  fonts.fontconfig.enable = true;

  ######## services ########
  services.gnome-keyring.enable = true;
  services.gpg-agent.enable = true;

  #IMPORTANT
  home.stateVersion = "20.09";
}
