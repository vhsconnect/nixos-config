{ pkgs, lib, config, ... }:
let
  user = (import ./user.nix);
  neovim-nightly-overlay = (import (builtins.fetchTarball {
    url = https://github.com/vhsconnect/neovim-nightly-overlay/archive/master.tar.gz;
  }));
in
{
  nixpkgs = {
    config = { allowUnfree = true; };
    overlays = [ neovim-nightly-overlay ];
  };
  imports = [
    ./packages.nix
    ./zsh.nix
    ./i3.home.nix
    ./dunst.home.nix
    ./rofi.home.nix
    ./i3blocks.home.nix
    ./vim.nix
    ./git.nix
    ./hexchat.nix
    ./mimeappsList.nix
    ./scripts/scripts.nix
  ] ++ (if user.withgtk then [ ./gtk3.nix ] else [ ]);


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
  services.blueman-applet.enable = true;

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
