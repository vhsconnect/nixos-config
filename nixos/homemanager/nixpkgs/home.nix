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
    ./mimeappsList.nix
  ] ++ (if user.withgtk then [ ./gtk3.nix ] else [ ]);


  ######## programs ########
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    delta = {
      enable = true;
      options = { side-by-side = true; };
    };
    aliases = {
      amend = "commit --amend -m";
      fixup = "!f(){ git reset --soft HEAD~\${1} && git commit --amend -C HEAD; };f";
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
    };
    extraConfig = {
      core = {
        editor = "nvim";
        # pager = "diff-so-fancy | less --tabs=4 -RFX";
      };
      color.diff-highlight.newNormal = "68 bold";
      color.diff-highlight.newHighlight = "27 bold";
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
    defaultCommand = "find .";
    changeDirWidgetCommand = "fd --type d --hidden";
    changeDirWidgetOptions = [
      "--preview 'tree -C {} | head -200'"
    ];
  };

  programs.chromium.enable = true;
  programs.direnv.enable = true;

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
