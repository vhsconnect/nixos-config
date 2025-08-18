{ lib
, config
, system
, ...
}:
let
  cfg = config.services.bbrf-radio;
  isDarwin = (system == "x86_64-darwin") || (system == "aarch64-darwin");
  isLinux = !(isDarwin);
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
    (lib.optionalAttrs (isLinux) {
      networking.firewall.allowedTCPPorts = let ports = if cfg.withNginxProxy then [ 80 ] else [ ]; in ports;
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
