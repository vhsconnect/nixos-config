{ ... }:
let
  port = 3350;
in
{
  services.gitDaemon = {
    enable = true;
    basePath = "/home/common/git";
    exportAll = true;
    options = "--enable=receive-pack";
    inherit port;
  };

  networking.firewall = {
    allowedTCPPorts = [
      port
    ];
  };

}
