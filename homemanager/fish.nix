{ pkgs, ... }:
let
  binPath = "$HOME/bin";
  cargoPath = "$HOME/.cargo/bin";
  npmPath = "$HOME/.npm-global/bin";
in
{

  programs.fzf = {
    enable = true;
    enableFishIntegration = false;
    defaultCommand = "fd . --hidden";
    changeDirWidgetCommand = "fd --type d --hidden --no-ignore";
    changeDirWidgetOptions = [
      "--preview 'tree -C {} | head -500'"
      "--border"
    ];
  };

  programs.fish = {
    enable = true;
    generateCompletions = true;
    plugins = [
      {
        name = "fzf.fish";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "8920367cf85eee5218cc25a11e209d46e2591e7a";
          sha256 = "sha256-T8KYLA/r/gOKvAivKRoeqIwE2pINlxFQtZJHpOy9GMM=";
        };
      }
      {
        name = "fzf";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "fzf";
          rev = "479fa67d7439b23095e01b64987ae79a91a4e283";
          sha256 = "sha256-28QW/WTLckR4lEfHv6dSotwkAKpNJFCShxmKFGQQ1Ew=";
        };
      }
    ];

    shellInit = ''

      fish_add_path /home/common/SConfig/nvim/result/bin  ${binPath} ${cargoPath} ${npmPath}
      set -g fish_greeting 

      abbr --add ".." "cd ../"
      abbr --add "..." "cd ../../"
      abbr --add "...." "cd ../../../"
      abbr --add "....." "cd ../../../../"
      abbr --add "......" "cd ../../../../../"


      set -gx TMPDIR "$HOME/Public/tmp"
      set -gx TEMP "$HOME/Public/tmp"
      set -gx TMP "$HOME/Public/tmp"
      set -gx SUDO_ASKPASS "lxqt-openssh-askpass"
      set -gx VI_MODE_SET_CURSOR "true"
      set -gx MODE_INDICATOR "%F{yellow}+%f"
      set -gx QT_QPA_PLATFORMTHEME "qt5ct"
      set -gx QT_STYLE_OVERRIDE "adawaita-dark"
      set -gx EDITOR "nvim"
      set -gx BAT_THEME ansi
      set -Ux VIM_THEME gruvbox

      source ~/.fstuff

    '';
    interactiveShellInit = ''

      function fish_user_key_bindings
        fish_default_key_bindings -M insert
        fish_vi_key_bindings --no-erase insert
        bind --preset -M command \cp up-or-search
        bind -s --preset -M visual -m default y 'fish_clipboard_copy; commandline -f end-selection repaint-mode'
        bind --preset --erase \ep
        bind --preset -M visual --erase \ep
        bind --preset -M insert --erase \ep
      end

      set fish_cursor_default block
      set fish_cursor_insert line
      set fish_cursor_replace_one underscore
      set fish_cursor_visual block
      set -g fish_vi_force_cursor 1

      bind yy fish_clipboard_copy
      bind Y fish_clipboard_copy
      bind p fish_clipboard_paste

      set __done_notification_command 'terminal-notifier -title \\\$title -message \\\$message'

    '';

    shellAbbrs = {
      l = "exa -la";
      lsg = "exa -la | rg -i";
      vl = "git status --short | fzf | cut -c 4- | xargs nvim";
      vh = "git show --name-only --pretty=format: | fzf | xargs nvim";
      si = "du -hd0";
      sic = "du -h --max-depth=1 .";
      allbound = "netstat -tulpn";
      nixr = "nix run nixpkgs#";
      nixp = "nix-shell -p";
      nixd = "nix develop -c zsh";
      less = "less -r";
      cl = "clear";
    };

    shellAliases = {
      cdconfig = "cd /home/common/SConfig/nixos-config/";
      c = "xclip -selection clipboard";
      v = "fd . --type=file --exclude '.git/*' | fzf | xargs nvim";
      lock = "xscreensaver-command -lock";
      emoji = "rofi -show emoji -modi emoji";
      tree = "tree -C";
      deli = "tr $1 '\n'";
      img = "gthumb";
      pdf = "evince";
      tar-archive = "tar -czvf";
      tar-unarchive = "tar -xzvf";
      xargs2 = "xargs -I {} bash -c \"$1\"";
    };

  };
}
