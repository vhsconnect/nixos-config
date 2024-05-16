{ ... }: {

  home.file = {
    ".ignore" = {
      enable = true;
      text = ''
        node_modules
        yarn.lock
        flake.lock
        package-lock.json
        cargo.toml

      '';
    };
  };
}

