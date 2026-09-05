{ enableNginx }:
{ ... }:
{
  services.bbrf-radio = {
    enable = true;
    withNginxProxy = enableNginx;
    radioBroadcast = "Concertzender Baroque";
  };
}
