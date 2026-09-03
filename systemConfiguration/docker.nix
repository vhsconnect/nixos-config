{ ... }:
{
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    "default-ulimits" = {
      nofile = {
        Name = "nofile";
        Soft = 65535;
        Hard = 65535;
      };
    };
  };
}
