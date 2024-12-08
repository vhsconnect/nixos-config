{ pkgs, ... }:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "vhs";
  };
  environment.systemPackages = with pkgs; [

    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];
}
