{ user, ... }:
let
  port = 3338;
in
# update mbison -> mbison push (sync from gui) -> anki-sync-server updates <- ankidroid pull
{

  networking.firewall.allowedTCPPorts = [
    port
  ];

  services.anki-sync-server = {
    inherit port;
    enable = true;
    address = "0.0.0.0";
    openFirewall = true;
    users = [
      {
        username = "admin";
        password = user.syncthingGuiPass;
      }
    ];
  };

}
