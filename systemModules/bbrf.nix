{ enableNginx }:
{ ... }:
{
  services.bbrf-radio = {
    enable = true;
    withNginxProxy = enableNginx;
  };
}
