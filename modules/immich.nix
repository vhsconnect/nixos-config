{
  lib,
  config,
  ...
}:
let
  cfg = config.immich;
in
{

  options.immich = with lib; {

    enable = mkEnableOption ''
      Enable Immich container
    '';

    group = mkOption {
      type = types.str;
      default = "ops";
      description = "Group run container and be group for immich user";
    };
    groupId = mkOption {
      type = types.number;
      default = 989;
      description = "GID for group - match this with host's group GID with write permissions to Immich Dir";
    };
    immichDir = mkOption {
      type = types.str;
      description = "Path for Immich directory on the host";
    };
    autoStart = mkOption {
      type = types.bool;
      default = false;
      description = "autoStart";
    };
    port = mkOption {
      type = types.number;
      default = 2283;
      description = "port: internal and external";
    };
  };

  config = lib.mkIf cfg.enable {

    containers.immich = {
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
        "/media" = {
          hostPath = cfg.immichDir;
          isReadOnly = false;
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
          users.groups.ops = {
            gid = cfg.groupId;
          };

          users.users.immich = {
            isSystemUser = true;
            group = cfg.group;
            uid = 959;
          };

          services.immich = {
            enable = true;
            settings = {
              storageTemplate = {
                enabled = false;
                hashVerificationEnabled = false;
                template = "{{y}}/{{y}}-{{MM}}-{{dd}}/{{filename}}";
              };
            };
            mediaLocation = "/media";
            openFirewall = true;
            user = "immich";
            group = cfg.group;
            host = "0.0.0.0";
            port = cfg.port;
            environment = {
              IMMICH_LOG_LEVEL = "verbose";
            };
          };

          system.stateVersion = "24.11";
        };
    };

  };
}
