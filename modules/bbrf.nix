{
  lib,
  config,
  system,
  pkgs,
  ...
}:
let
  cfg = config.services.bbrf-radio;
  isLinux = !((system == "x86_64-darwin") || (system == "aarch64-darwin"));

  # CLI controlling the always-on radio via mpv's IPC socket (fish).
  radioCli = pkgs.writeScriptBin "radio" (
    builtins.concatStringsSep "\n" [
      ''
        #! ${pkgs.fish}/bin/fish
        set -q SOCKET; or set SOCKET "$XDG_RUNTIME_DIR/radio.sock"
        set PORT "${toString cfg.port}"
        set DEFAULT_STATION "${cfg.radioBroadcast}"
        set CURL "${pkgs.curl}/bin/curl"
        set JQ "${pkgs.jq}/bin/jq"
        set SOCAT "${pkgs.socat}/bin/socat"
        set SORT "${pkgs.coreutils}/bin/sort"
      ''
      (builtins.readFile ./radio-cli.fish)
    ]
  );
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

    radioBroadcast = mkOption {
      type = types.str;
      description = "Always on radio";
    };

    user = mkOption {
      type = types.str;
      default = "vhs";
      description = "User account under which bbrf and the always-on radio run";
    };

    port = mkOption {
      type = types.int;
      default = 8898;
      description = "Port the bbrf service listens on";
    };

  };

  config = lib.mkMerge [
    (lib.optionalAttrs (isLinux) {
      networking.firewall.allowedTCPPorts =
        let
          ports = if cfg.withNginxProxy then [ 80 ] else [ ];
        in
        ports;
      services.nginx = {
        enable = cfg.withNginxProxy;
        virtualHosts = {
          localhost = {
            forceSSL = false;
            enableACME = false;
            locations."/" = {
              proxyPass = "http://localhost:${toString cfg.port}";
            };
          };
        };
      };
    })
    {
      services.bbrf = {
        enable = true;
        user = cfg.user;
        port = cfg.port;
        faderValue = 25;
        serveStaticSite = true;
        staticSiteServedOn = 8040;

      };
      networking.firewall.allowedTCPPorts = [ 8040 ];
    }
    (lib.optionalAttrs (isLinux) {
      users.users.${cfg.user}.linger = lib.mkDefault true;

      systemd.user.services.radio = {
        description = "bbrf always-on radio (muted mpv, IPC-controlled)";
        wantedBy = [ "default.target" ];
        wants = [ "pipewire.service" ];
        after = [ "pipewire.service" ];

        startLimitIntervalSec = 0; # restart forever, really "always on"

        serviceConfig = {
          Type = "simple";
          Restart = "always";
          RestartSec = "5s";
        };

        script = ''
          until RADIO_URL=$(${pkgs.curl}/bin/curl -s http://localhost:${toString cfg.port}/favorites | ${pkgs.jq}/bin/jq -e -r --arg NAME "${cfg.radioBroadcast}" '.[] | select(.name == $NAME) | .url'); do
            echo "Waiting for bbrf endpoint..."
            ${pkgs.coreutils}/bin/sleep 2
          done

          exec ${pkgs.mpv}/bin/mpv \
            --no-video \
            --ao=pulse \
            --mute=yes \
            --cache-secs=10 \
            --audio-client-name=bbrf-radio \
            --msg-level=all=error \
            --input-ipc-server="$XDG_RUNTIME_DIR/radio.sock" \
            "$RADIO_URL"
        '';
      };

      environment.systemPackages = [ radioCli ];
    })
  ];
}
