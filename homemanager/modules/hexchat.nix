{ pkgs, user, ... }:
{
  programs.hexchat =
    {
      enable = true;
      channels = {
        libera = {
          autojoin = [
            "#home-manager"
            "#linux"
            "#nixos"
            "#javascript"
            "#haskell"
            "#clojure"
            "#rust"
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
