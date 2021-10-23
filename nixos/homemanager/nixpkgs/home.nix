{ pkgs, lib, config, ... }:
let
  user = (import ./user.nix);
in
{
  nixpkgs.config = {
    allowUnfree = true;
  };

  imports = [
    ./packages.nix
    ./zsh.nix
    ./i3.home.nix
    ./dunst.home.nix
    ./rofi.home.nix
    ./i3blocks.home.nix
    ./rofi-rafi.home.nix
    ./vim.nix
  ];


  ######## programs ########
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    aliases = {
      amend = "commit --amend -m";
      fixup = "!f(){ git reset --soft HEAD~\${1} && git commit --amend -C HEAD; };f";
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
    };
    extraConfig = {
      core = {
        editor = "nvim";
        pager = "diff-so-fancy | less --tabs=4 -RFX";
      };
      init.defaultBranch = "master";
    };
    ignores = [
      "*.direnv"
    ];
    userEmail = user.email;
    userName = user.handle;
  };


  programs.bat.enable = true;
  programs.tmux.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    changeDirWidgetCommand = "fd --type d";
    changeDirWidgetOptions = [
      "--preview 'tree -C {} | head -200'"
    ];
  };

  programs.chromium.enable = true;
  programs.direnv.enable = true;

  ######## home ########
  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "xfce4-terminal";
    SUDO_ASKPASS = "lxqt-openssh-askpass";
  };

  home.username = "vhs";
  home.homeDirectory = "/home/vhs";


  ######## fonts ########
  fonts.fontconfig.enable = true;

  ######## services ########
  services.gnome-keyring.enable = true;
  services.gpg-agent.enable = true;

  services.xscreensaver = {
    enable = true;
    settings = {
      timeout = "30";
    };
  };


  #IMPORTANT
  home.stateVersion = "21.03";

}
