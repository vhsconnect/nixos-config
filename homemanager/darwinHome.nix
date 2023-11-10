{ pkgs
, lib
, config
, user
, inputs
, _imports
, ...
}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = import ./overlays.nix inputs;
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
      "--color=bg+:#3B4252,bg:#2E3440,spinner:#81A1C1,hl:#616E88,fg:#D8DEE9,header:#616E88,info:#81A1C1,pointer:#81A1C1,marker:#81A1C1,fg+:#D8DEE9,prompt:#81A1C1,hl+:#81A1C1"
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
  };

  home.username = "valentin";
  home.homeDirectory = "/Users/valentin";

  ######## fonts ########
  fonts.fontconfig.enable = true;

  #IMPORTANT
  home.stateVersion = "21.03";
}
