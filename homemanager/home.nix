{ pkgs, lib, config, user, inputs, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = (import ./overlays.nix inputs);
  };
  imports = [
    ./packages.nix
    ./zsh.nix
    ./mimeappsList.nix
    ./vim/vim.nix
    ./i3/i3blocks.home.nix
    ./i3/i3.home.nix
    ./modules/dunst.home.nix
    ./modules/rofi.home.nix
    ./modules/git.nix
    ./modules/hexchat.nix
    ./scripts/scripts.nix
    ./scripts/scripts.nix
    ./scripts/templates.nix
  ]
  ++ (if user.withgtk then [ ./modules/gtk3.nix ] else [ ]);


  ######## programs ########
  programs.home-manager.enable = true;
  programs.tmux.enable = true;
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd . --hidden";
    changeDirWidgetCommand = "fd --type d --hidden --no-ignore";
    changeDirWidgetOptions = [
      "--preview 'tree -C {} | head -500'"
      "--border"
      "--color=bg+:#3B4252,bg:#2E3440,spinner:#81A1C1,hl:#616E88,fg:#D8DEE9,header:#616E88,info:#81A1C1,pointer:#81A1C1,marker:#81A1C1,fg+:#D8DEE9,prompt:#81A1C1,hl+:#81A1C1"
    ];
  };
  programs.direnv.enable = true;
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
  programs.htop = {
    enable = true;
    settings = {
      left_meters = [ "LeftCPUs2" "Memory" "Swap" ];
      left_right = [ "RightCPUs2" "Tasks" "LoadAverage" "Uptime" ];
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
