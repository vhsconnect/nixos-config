{ pkgs
, user
, ...
}: {
  programs.hexchat = {
    enable = true;
    overwriteConfigFiles = true;
    theme = pkgs.fetchzip {
      url = "https://dl.hexchat.net/themes/Monokai.hct#Monokai.zip";
      sha256 = "sha256-WCdgEr8PwKSZvBMs0fN7E2gOjNM0c2DscZGSKSmdID0=";
      stripRoot = false;
    };
    settings = {
      text_font = user.fullQualifiedFont;
    };
    channels = {
      libera = {
        autojoin = [
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
