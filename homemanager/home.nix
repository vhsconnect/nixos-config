{ pkgs, lib, config, ... }:
let
  user = (import ../user.nix);
in
{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = import ./overlays.nix;
  };
  imports = [
    ./packages.nix
    ./zsh.nix
    ./mimeappsList.nix
    ./vim/vim.nix
    ./modules/i3.home.nix
    ./modules/dunst.home.nix
    ./modules/rofi.home.nix
    ./modules/i3blocks.home.nix
    ./modules/git.nix
    # ./modules/hexchat.nix
    ./scripts/scripts.nix
  ] ++ (if user.withgtk then [ ./modules/gtk3.nix ] else [ ]);


  ######## programs ########
  programs.home-manager.enable = true;
  programs.tmux.enable = true;
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd .";
    changeDirWidgetCommand = "fd --type d --hidden";
    changeDirWidgetOptions = [
      "--preview 'tree -C {} | head -200'"
    ];
  };
  programs.direnv.enable = false;
  programs.direnv.nix-direnv.enable = false;
  programs.autojump =
    {
      enable = true;
      enableZshIntegration = true;
    };
  programs.broot =
    {
      enable = true;
      modal = true;
      enableZshIntegration = true;
    };


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
  services.gammastep =
    {
      enable = true;
      dawnTime = "6:00-7:45";
      duskTime = "18:00-19:05";
      longitude = "59.3";
      latitude = "18.0";
      temperature.day = 4800;
      tray = true;
    };
  services.xscreensaver = {
    enable = true;
    settings = {
      timeout = "30";
    };
  };

  #IMPORTANT
  home.stateVersion = "21.03";

}
