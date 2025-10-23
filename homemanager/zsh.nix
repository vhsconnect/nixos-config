{ pkgs, user, ... }:
let
  binPath = "$HOME/bin";
  cargoPath = "$HOME/.cargo/bin";
  npmPath = "$HOME/.npm-global/bin";
  nixrunPackages = import ./nixrunPackages.nix;
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
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    history.size = 1000000;
    envExtra = ''
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
      QT_STYLE_OVERRIDE = "Adwaita-Dark";
      EDITOR = "nvim";
      PATH = "${binPath}:${cargoPath}:${npmPath}:$PATH";
      PROMPT = ''[%F{$(if [ "$IN_NIX_SHELL" = "impure" ] || [[ -n "$SSH_CONNECTION" ]]; then echo "1"; else echo "9"; fi)}%B$(if [[ -n "$SSH_CONNECTION" ]]; then echo "$SSH_CONNECTION" | cut -d' ' -f3; else echo "${user.promptI}"; fi)%b%f] %F{244}%1d%f '';
    };
    shellAliases = {
      cdconfig = "/home/common/SConfig/nixos-config/";
      speed = "speedtest-cli";
      grep = "grep -i";
      c-x11 = "xclip -selection clipboard";
      c = "wl-copy";
      cl = "clear";
      l = "exa -la";
      lsg = "exa -la | rg -i";
      v = "fd . --type=file --exclude '.git/*' | fzf | xargs nvim";
      vl = "git status --short | fzf | cut -c 4- | xargs nvim";
      vh = "git show --name-only --pretty=format: | fzf | xargs nvim";
      dugl = "du -hd0";
      dush = "du -h --max-depth=1 .";
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
      bluetext = ''magick $1 -fill "darkblue" -fuzz 50% -opaque black output.png'';
      nix-stray-roots = ''nix-store --gc --print-roots | egrep -v "^(/nix/var|/run/\w+-system|\{memory)"'';
      clear-auto-roots = "sudo rm -rf /nix/var/nix/gcroots/auto/*";

    } // nixrunPackages;
    zsh-abbr = {
      enable = true;
      abbreviations = {
        gs = "git status";
        gd = "git diff";
        gr = "git rebase";
        gp = "git pull";
        ffmpack = ''ffmpeg -i $1 -c:v libx265 -crf 28 -preset slow -vf "scale=-1:720,fps=24" -c:a aac -b:a 96k output.mkv'';
        ss = "setsid";
        gco = "git checkout";
        gcm = "git commit -m";
        kni = "kubectl --namespace invoicing";
        db = ''nvim -c "DBUI"'';
      };
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "colored-man-pages"
        "vi-mode"
        "timer"
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
