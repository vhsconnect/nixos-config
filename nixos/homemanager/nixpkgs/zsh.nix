{ pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true; 
    localVariables = {
      TMPDIR = "/home/vhs/Public/tmp";
      SUDO_ASKPASS = "lxqt-openssh-askpass";
      BAT_THEME = "Monokai Extended";
      VI_MODE_SET_CURSOR = "true";
      MODE_INDICATOR = "%F{yellow}+%f";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      QT_STYLE_OVERRIDE = "";
      EDITOR = "nvim";
      PATH = "$HOME/bin:$HOME/.npm-global/bin:$PATH";
      PROMPT = ''[%F{$(if [ "$IN_NIX_SHELL" = "impure" ]; then echo "91"; else echo "9"; fi )}λ%f] %F{15}%1d%f '';

    };
    shellAliases = {
      #listpkg='nix-env -qa --installed "*"'
      nixconfig = "sudo nvim /etc/nixos/configuration.nix";
      cdconfig = "~/Repos/nixos-config/nixos/homemanager/nixpkgs";
      nixosdir = "cd /etc/nixos";
      managerdir = "cd ~/.config/nixpkgs";
      c = "xclip -selection clipboard";
      l = "exa -la";
      nixu = "nix-env --uninstall";
      nixupdate = "nix-channel --update nixos";
      restartpolybar = "systemctl --user restart polybar.service";
      hm = "home-manager";
      hms = "home-manager -b backup switch";
      nixp = "nix-shell -p";
      pdf = "evince";
      lock = "xscreensaver-command -lock";
      emoji = "rofi -show emoji -modi emoji";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ 
      "z"
      "git"
      "colored-man-pages"
      "vi-mode" 
      ];
    };
    plugins = [{
      name = "zsh-nix-shell";
      file = "nix-shell.plugin.zsh";
      src = pkgs.fetchFromGitHub {
        owner = "chisui";
        repo = "zsh-nix-shell";
        rev = "v0.4.0";
        sha256 = "037wz9fqmx0ngcwl9az55fgkipb745rymznxnssr3rx9irb6apzg";
      };
    }];
  };
}
