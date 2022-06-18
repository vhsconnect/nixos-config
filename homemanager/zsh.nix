{ pkgs, lib, ... }:
let configPath = "/home/vhs/SConfig/nixos-config"; in
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    envExtra = ''
      export BAT_THEME=ansi
    '';
    localVariables = {
      TMPDIR = "/home/vhs/Public/tmp";
      TEMP = "/home/vhs/Public/tmp";
      TMP = "/home/vhs/Public/tmp";
      SUDO_ASKPASS = "lxqt-openssh-askpass";
      VI_MODE_SET_CURSOR = "true";
      MODE_INDICATOR = "%F{yellow}+%f";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      QT_STYLE_OVERRIDE = "";
      EDITOR = "nvim";
      PATH = "$HOME/bin:$HOME/.npm-global/bin:$PATH";
      PROMPT = ''[%F{$(if [ "$IN_NIX_SHELL" = "impure" ]; then echo "4"; elif [ -d .git ] && [ -ne $(git diff --quiet)]; then echo "3"; else echo "9"; fi)}λ%f] %F{15}%1d%f '';
    };
    shellAliases = {
      nixosconfig = "nvim /Repos/nixos-config/nixos/nixos/configuration.nix";
      cdconfig = "~/Repos/nixos-config/nixos/homemanager/nixpkgs";
      nixosdir = "cd /etc/nixos";
      managerdir = "cd ~/.config/nixpkgs";
      grep = "grep -i";
      c = "xclip -selection clipboard";
      l = "exa -la";
      v = "vi `fzf`";
      si = "du -hd0";
      nixu = "nix-env --uninstall";
      nixupdate = "nix-channel --update nixos";
      restartpolybar = "systemctl --user restart polybar.service";
      hm = "home-manager";
      hms = "echo \"use rebuild\"";
      rebuild = "nixos-rebuild switch --flake ${configPath} -I nixos-config=. --impure";
      nixp = "nix-shell -p";
      pdf = "evince";
      lock = "xscreensaver-command -lock";
      emoji = "rofi -show emoji -modi emoji";
      allbound = "netstat -tulpn";
      quickref = "vi ~/Dropbox/quickref";
      tree = "tree -C";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "z"
        "colored-man-pages"
        "vi-mode"
      ];
    };
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.4.0";
          sha256 = "037wz9fqmx0ngcwl9az55fgkipb745rymznxnssr3rx9irb6apzg";
        };
      }
      {
        name = "fz";
        file = "fz.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "changyuheng";
          repo = "fz";
          rev = "2a4c1bc73664bb938bfcc7c99f473d0065f9dbfd";
          sha256 = "0fg2a28cp3a4smcq61vngzdvjwq8np35ayq2ix1db34c18s222a4";
        };
      }
      {
        name = "zsh-autopair";
        file = "zsh-autopair.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "hlissner";
          repo = "zsh-autopair";
          rev = "9d003fc02dbaa6db06e6b12e8c271398478e0b5d";
          sha256 = "0s4xj7yv75lpbcwl4s8rgsaa72b41vy6nhhc5ndl7lirb9nl61l7";

        };
      }
      {
        name = "fzf-tab";
        file = "fzf-tab.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "103330fdbeba07416d5f90b391eee680cd20d2d6";
          sha256 = "0n1fvs03bl0sc99k78k3lfv7czzcb63j7llmrzlyjcxrgv78cvzq";
        };
      }
    ];
  };
}
