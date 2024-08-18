{ pkgs, ... }:
{

  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.openFirewall = true;
  services.avahi.nssmdns4 = true;
  services.printing.drivers = [ pkgs.cnijfilter2 ];
}
