{ pkgs, ... }:
{

  home.file = {
    ".ignore" = {
      enable = true;
      text = ''
        node_modules
        yarn.lock
        flake.lock
        package-lock.json
        Cargo.lock
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

  xdg.configFile = {
    "alacritty/themes".source = pkgs.fetchFromGitHub {
      owner = "alacritty";
      repo = "alacritty-theme";
      rev = "94e1dc0b9511969a426208fbba24bd7448493785";
      sha256 = "bPup3AKFGVuUC8CzVhWJPKphHdx0GAc62GxWsUWQ7Xk=";
    };
  };
}
