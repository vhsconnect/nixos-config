{
  pkgs,
  lib,
  user,
  config,
  ...
}:
let
  inherit (import ./fonts.nix { }) fonts generateFontTemplate;
  firstAttrName = z: lib.head (lib.attrNames z);
  firstAttrValue = z: lib.head (lib.attrValues z);
  theme = import (./themes/. + "/${user.theme}.nix");
  inherit (user) secondaryFont;

in
{

  xdg.configFile =
    let
      mapper = map (y: {
        name = "alacritty/fonts/${firstAttrName y}.toml";
        value = {
          text = generateFontTemplate (firstAttrValue y);
        };
      });
      allacrittyFontTemplates = lib.pipe fonts [
        mapper
        lib.listToAttrs
      ];
    in
    allacrittyFontTemplates
    // {
      "alacritty/themes".source = pkgs.fetchFromGitHub {
        owner = "alacritty";
        repo = "alacritty-theme";
        rev = "94e1dc0b9511969a426208fbba24bd7448493785";
        sha256 = "bPup3AKFGVuUC8CzVhWJPKphHdx0GAc62GxWsUWQ7Xk=";
      };
    };

  home.file = {
    ".ignore" = {
      enable = true;
      text = ''
        node_modules
        yarn.lock
        flake.lock
        package-lock.json
        Cargo.lock
        .envrc
        result
      '';
    };
  };

  home.file = {
    "Public/templates/_ls-colors" = {
      enable = true;

      text = ''
        #! /usr/bin/env fish

        # COLORS
        set BLACK 30
        set RED 31
        set GREEN 32
        set YELLOW 33
        set BLUE 34
        set MAGENTA 35
        set CYAN 36
        set WHITE 37
        set BRIGHT_BLACK 90
        set BRIGHT_RED 91
        set BRIGHT_GREEN 92
        set BRIGHT_YELLOW 93
        set BRIGHT_BLUE 94
        set BRIGHT_MAGENTA 95
        set BRIGHT_CYAN 96
        set BRIGHT_WHITE 97


        # ELEMENTS
        set DIRECTORY di
        set SYMBOLIC_LINK ln
        set SOCKET so
        set PIPE pi
        set EXECUTABLE ex
        set BLOCK_DEVICE bd
        set CHARACTER_DEVICE cd
        set SETUID su
        set SETGID sg
        set STICKY_WRITABLE tw
        set OTHER_WRITABLE ow
        set DATE da
        set USER_READ_PERMISSION ur
        set USER_WRITE_PERMISSION uw
        set USER_EXECUTE_PERMISSION ux
        set GROUP_READ_PERMISSION gr
        set GROUP_WRITE_PERMISSION gw
        set GROUP_EXECUTE_PERMISSION gx
        set OTHERS_READ_PERMISSION tr
        set OTHERS_WRITE_PERMISSION tw
        set OTHERS_EXECUTE_PERMISSION tx
        set FILE_SIZE sn
        set FILE_OWNER un
        set GROUP_NAME ga
        set INODE_NUMBER in
        set HARD_LINK_COUNT hd
        set LINK_TARGET_PATH lp
        set CONTROL_CHARACTERS cc
        set BLOCK_SIZE bO
        set GIT_MODIFIED gm
        set GIT_DELETED gd
        set GIT_RENAMED gv
        set GIT_TYPE_CHANGE gt
        set PUNCTUATION xx


        set color_array

        # File Types
        set -a color_array "$DIRECTORY=$BRIGHT_MAGENTA"
        set -a color_array "$SYMBOLIC_LINK=$BRIGHT_BLUE"
        set -a color_array "$SOCKET=$BRIGHT_RED"
        set -a color_array "$PIPE=$BRIGHT_RED"
        set -a color_array "$EXECUTABLE=$BRIGHT_RED"
        set -a color_array "$BLOCK_DEVICE=$BRIGHT_RED"
        set -a color_array "$CHARACTER_DEVICE=$BRIGHT_RED"
        set -a color_array "$SETUID=$BRIGHT_RED"
        set -a color_array "$SETGID=$BRIGHT_RED"
        set -a color_array "$STICKY_WRITABLE=$BRIGHT_RED"
        set -a color_array "$OTHER_WRITABLE=$BRIGHT_RED"
        set -a color_array "$DATE=$WHITE"

        # User and Group Permissions
        set -a color_array "$USER_READ_PERMISSION=$BRIGHT_GREEN"
        set -a color_array "$USER_WRITE_PERMISSION=$BRIGHT_YELLOW"
        set -a color_array "$USER_EXECUTE_PERMISSION=$BRIGHT_RED"
        set -a color_array "$GROUP_READ_PERMISSION=$BRIGHT_GREEN"
        set -a color_array "$GROUP_WRITE_PERMISSION=$BRIGHT_YELLOW"
        set -a color_array "$GROUP_EXECUTE_PERMISSION=$BRIGHT_RED"
        set -a color_array "$OTHERS_READ_PERMISSION=$BRIGHT_GREEN"
        set -a color_array "$OTHERS_WRITE_PERMISSION=$BRIGHT_YELLOW"
        set -a color_array "$OTHERS_EXECUTE_PERMISSION=$BRIGHT_RED"

        # Additional Elements
        set -a color_array "$FILE_SIZE=$CYAN"
        set -a color_array "$FILE_OWNER=$GREEN"
        set -a color_array "$GROUP_NAME=$MAGENTA"
        set -a color_array "$INODE_NUMBER=$BRIGHT_BLACK"
        set -a color_array "$HARD_LINK_COUNT=$CYAN"
        set -a color_array "$LINK_TARGET_PATH=$RED"
        set -a color_array "$CONTROL_CHARACTERS=$RED"
        set -a color_array "$BLOCK_SIZE=$CYAN"
        set -a color_array "$GIT_MODIFIED=$RED"
        set -a color_array "$GIT_DELETED=$RED"
        set -a color_array "$GIT_RENAMED=$YELLOW"
        set -a color_array "$GIT_TYPE_CHANGE=$YELLOW"
        set -a color_array "$PUNCTUATION=$BRIGHT_BLACK"

        echo (string join ":" $color_array)

      '';

    };

  };

  home.file = {
    "_sshagent-load" = {
      enable = true;
      text = ''
        SSH_ENV="$HOME/.ssh/environment"
        function start_agent {
             echo "Initialising new SSH agent..."
             ssh-agent > $SSH_ENV
             echo succeeded
             chmod 600 $SSH_ENV
             . $SSH_ENV > /dev/null
             ssh-add;
        }

        if [ -f $SSH_ENV ]; then
             . $SSH_ENV > /dev/null
             ps -ef | grep $SSH_AGENT_PID | grep ssh-agent$ > /dev/null || {
                 start_agent

             }
        else
             start_agent;
        fi

      '';
    };
  };

}
