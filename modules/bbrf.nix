{ lib, config, ... }:
let
  cfg = config.services.bbrf-radio;
in
{

  options.services.bbrf-radio = with lib; {

    enable = mkEnableOption ''
      Enable bbrf
    '';

    withNginxProxy = mkOption {
      type = types.bool;
      default = false;
      description = "Proxy bbrf through an Nginx reverse proxy";
    };

  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.withNginxProxy) {
      networking.firewall.allowedTCPPorts = [ 80 ];
      services.nginx = {
        enable = cfg.withNginxProxy;
        virtualHosts = {
          localhost = {
            forceSSL = false;
            enableACME = false;
            locations."/" = {
              proxyPass = "http://localhost:8898";
            };
          };
        };
      };
    })
    {
      services.bbrf = {
        enable = true;
        user = "vhs";
        port = 8898;
        faderValue = 25;
      };
    }
  ];
}
