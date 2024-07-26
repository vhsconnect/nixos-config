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

  xdg.configFile = {
    "alacritty/themes".source = pkgs.fetchFromGitHub {
      owner = "alacritty";
      repo = "alacritty-theme";
      rev = "94e1dc0b9511969a426208fbba24bd7448493785";
      sha256 = "bPup3AKFGVuUC8CzVhWJPKphHdx0GAc62GxWsUWQ7Xk=";
    };
  };
}
