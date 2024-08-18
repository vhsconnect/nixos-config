{ ... }:
{

  #  networking.firewall.allowedTCPPorts = [ 80 ];

  # services.nginx = {
  #   enable = true;
  #   virtualHosts = {
  #     localhost = {
  #       forceSSL = false;
  #       enableACME = false;
  #       locations."/" = {
  #         proxyPass = "http://localhost:8898";
  #       };
  #     };
  #   };
  # };

  services.bbrf = {
    enable = true;
    user = "vhs";
    port = 8898;
    faderValue = 25;
  };
}
