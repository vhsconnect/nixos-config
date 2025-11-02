{
  lib,
  config,
  user,
  ...
}:
let
  cfg = config.icecast;
in
{

  options.icecast = with lib; {

    enable = mkEnableOption ''
      Enable icecast container
    '';

    mediaDir = mkOption {
      type = types.str;
      description = "Path for liquidsoap directory on the host";
    };
    bitrate = mkOption {
      type = types.str;
      default = "128";
      description = "Path for liquidsoap directory on the host";
    };
    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "autoStart";
    };
    port = mkOption {
      type = types.number;
      default = 8000;
      description = "port: internal and external";
    };
    playlists = mkOption {
      type = types.listOf types.str;
      description = "List of playlist files";
    };
    password = mkOption {
      type = types.str;
      default = user.obfuscated;
      description = "Password for streams, admin";
    };
    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to open firewall in host for port specified";
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.services."container@icecast" = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };

    networking.firewall.allowedTCPPorts = if cfg.openFirewall then [ cfg.port ] else [ ];

    containers.icecast = {
      autoStart = cfg.autoStart;
      ephemeral = false;
      privateNetwork = false;
      forwardPorts = [
        {
          hostPort = cfg.port;
          containerPort = cfg.port;
        }
      ];
      bindMounts = {
        "/var/lib/liquidsoap" = {
          hostPath = cfg.mediaDir;
          isReadOnly = true;
        };
      };
      config =
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {

          nix = {

            package = pkgs.nixVersions.stable;
            extraOptions = ''
              experimental-features = nix-command flakes
            '';

          };

          services.icecast =

            {
              enable = true;
              hostname = "localhost";
              listen.port = cfg.port;

              admin = {
                user = "admin";
                password = cfg.password;
              };

              extraConf =
                let
                  mounts = (
                    lib.concatStringsSep "\n" (
                      lib.map (x: ''
                        <mount>
                          <mount-name>/${x}</mount-name>
                          <password>${cfg.password}</password>
                          <public>1</public> 
                          <bitrate>${cfg.bitrate}</bitrate>
                        </mount>
                      '') cfg.playlists
                    )

                  );

                in
                ''
                   <http-headers>
                       <header name="Access-Control-Allow-Origin" value="*" />
                       <header name="X-Robots-Tag" value="index, noarchive" />
                   </http-headers>
                  ${mounts}
                '';
            };

          services.liquidsoap.streams = lib.genAttrs (cfg.playlists) (x: ''
            output.icecast(%%mp3(bitrate=128),host=\"127.0.0.1\",port=${builtins.toString cfg.port},password=\"${cfg.password}\",mount=\"/${x}\",mksafe(playlist(reload=-1,mode=\"random\",\"/var/lib/liquidsoap/${x}.m3u\")))
          '');

          system.stateVersion = "25.05";
        };
    };

  };
}
