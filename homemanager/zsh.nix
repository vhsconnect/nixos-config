{ pkgs, user, ... }:
let
  binPath = "$HOME/bin";
  cargoPath = "$HOME/.cargo/bin";
  npmPath = "$HOME/.npm-global/bin";
in
{

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd . --hidden";
    changeDirWidgetCommand = "fd --type d --hidden --no-ignore";
    historyWidgetOptions = [ ];
    changeDirWidgetOptions = [
      "--preview 'tree -C {} | head -500'"
      "--border"
    ];
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    history.size = 1000000;
    envExtra = ''
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
      autoload -Uz compinit
      compinit
      setopt autocd
      #vim-mode
      bindkey -v
      autoload edit-command-line
      zle -N edit-command-line
      bindkey -M vicmd 'v' edit-command-line
      source ~/.zstuff
    '';
    localVariables = {
      TMPDIR = "$HOME/Public/tmp";
      TEMP = "$HOME/Public/tmp";
      TMP = "$HOME/Public/tmp";
      SUDO_ASKPASS = "lxqt-openssh-askpass";
      VI_MODE_SET_CURSOR = "true";
      MODE_INDICATOR = "%F{yellow}+%f";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      #Override for qt 6
      QT_STYLE_OVERRIDE = "adawaita-dark";
      EDITOR = "nvim";
      PATH = "${binPath}:${cargoPath}:${npmPath}:$PATH";
      PROMPT = ''[%F{$(if [ "$IN_NIX_SHELL" = "impure" ] || [[ -n "$SSH_CONNECTION" ]]; then echo "4"; else echo "9"; fi)}${user.promptI}%f] %F{244}%1d%f '';
    };
    shellAliases = {
      cdconfig = "cd /home/common/SConfig/nixos-config/";
      nixosdir = "cd /etc/nixos";
      managerdir = "cd ~/.config/nixpkgs";
      grep = "grep -i";
      c = "xclip -selection clipboard";
      cl = "clear";
      l = "exa -la";
      lg = "exa -la | rg -i";
      v = "fd . --type=file --exclude '.git/*' | fzf | xargs nvim";
      vl = "git status --short | fzf | cut -c 4- | xargs nvim";
      vh = "git show --name-only --pretty=format: | fzf | xargs nvim";
      si = "du -hd0";
      sic = "du -h --max-depth=1 .";
      sz = "source ~/.zstuff";
      lock = "xscreensaver-command -lock";
      emoji = "rofi -show emoji -modi emoji";
      allbound = "netstat -tulpn";
      tree = "tree -C";
      deli = "tr $1 '\n'";
      img = "gthumb";
      pdf = "evince";
      tar-archive = "tar -czvf";
      tar-unarchive = "tar -xzvf";
      nd = "nix develop -c zsh";
      nixp = "nix-shell -p";
      xargs2 = "xargs -I {} bash -c \"$1\"";
    };
    plugins = [
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
