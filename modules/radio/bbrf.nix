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
        set PY "${pkgs.python3.interpreter}"
        set FLOCK "${pkgs.util-linux}/bin/flock"
        set LN "${pkgs.coreutils}/bin/ln"
        set MV "${pkgs.coreutils}/bin/mv"
        set SLEEP "${pkgs.coreutils}/bin/sleep"
      ''
      (builtins.readFile ./radio-cli.fish)
    ]
  );

  # One of the two always-on mpv decks. $XDG_RUNTIME_DIR/radio.sock symlinks to
  # the live one; the other idles until radio-cli crossfades onto it.
  radioDeck = deck: {
    description = "bbrf always-on radio, deck ${deck} (mpv, IPC-controlled)";
    wantedBy = [ "default.target" ];
    wants = [ "pipewire.service" ];
    after = [ "pipewire.service" ];

    startLimitIntervalSec = 0; # restart forever, really "always on"

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = "5s";
      MemoryMax = "400M";
      MemorySwapMax = 0;
      CPUQuota = "50%";
      TimeoutStopSec = "5s";
    };

    script = ''
      live="$XDG_RUNTIME_DIR/radio.sock"
      state="$XDG_RUNTIME_DIR/radio.station"

      until ${pkgs.systemd}/bin/systemctl is-active --quiet bbrf.service; do
        echo "Waiting for bbrf.service to become active..."
        ${pkgs.coreutils}/bin/sleep 2
      done

      ${lib.optionalString (deck == "a") ''
        [ -L "$live" ] || ${pkgs.coreutils}/bin/ln -sfn radio-a.sock "$live"
      ''}

      url=""
      if [ "$(${pkgs.coreutils}/bin/readlink "$live")" = "radio-${deck}.sock" ]; then
        until favorites=$(${pkgs.curl}/bin/curl -sf http://localhost:${toString cfg.port}/favorites); do
          echo "Waiting for bbrf endpoint..."
          ${pkgs.coreutils}/bin/sleep 2
        done

        resolve() {
          ${pkgs.jq}/bin/jq -e -r --arg NAME "$1" 'first(.[] | select(.name == $NAME) | .url)' <<< "$favorites"
        }

        name=$(${pkgs.coreutils}/bin/cat "$state" 2>/dev/null || true)
        if [ -z "$name" ] || ! url=$(resolve "$name"); then
          name="${cfg.radioBroadcast}"
          url=$(resolve "$name")
          echo "$name" > "$state"
        fi
      fi

      exec ${pkgs.mpv}/bin/mpv \
        --no-video \
        --ytdl=no \
        --ao=pipewire \
        --stream-lavf-o=reconnect=1,reconnect_streamed=1,reconnect_on_network_error=1,reconnect_delay_max=30 \
        --idle=yes \
        --volume=0 \
        --cache-secs=10 \
        --audio-client-name=bbrf-radio-${deck} \
        --msg-level=all=error \
        --script=${./radio-deck.lua} \
        --input-ipc-server="$XDG_RUNTIME_DIR/radio-${deck}.sock" \
        ''${url:+"$url"}
    '';
  };
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

      systemd.user.services = lib.listToAttrs (
        map (deck: lib.nameValuePair "radio-${deck}" (radioDeck deck)) [
          "a"
          "b"
        ]
      );

      environment.systemPackages = [ radioCli ];
    })
  ];
}
