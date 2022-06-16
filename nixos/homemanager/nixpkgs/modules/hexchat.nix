{ pkgs, ... }:
let user = (import ../../../../user.nix); in
{
  programs.hexchat =
    {
      enable = true;
      theme = pkgs.fetchzip {
        url = "https://dl.hexchat.net/themes/mIRC.hct#mIRC.zip";
        sha256 = "sha256-WCdgEr8PwKSZvBMs0fN7E2gOjNM0c2DscZGSKSmdID0=";
        stripRoot = false;
      };
      channels = {

        libera = {
          autojoin = [
            "#home-manager"
            "#linux"
            "#nixos"
          ];
          charset = "UTF-8 (Unicode)";
          commands = [
            "ECHO ._."
          ];
          loginMethod = "sasl";
          nickname = "vhs";
          nickname2 = "vhsconnect";
          options = {
            acceptInvalidSSLCertificates = false;
            autoconnect = true;
            bypassProxy = false;
            connectToSelectedServerOnly = true;
            useGlobalUserInformation = false;
            forceSSL = false;
          };
          password = user.liberaPass;
          servers = [
            "irc.libera.chat/+6697"
          ];
          userName = user.liberaUser;
        };
      };
    };
}
