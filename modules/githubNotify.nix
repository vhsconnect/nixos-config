{
  lib,
  config,
  pkgs,
  user,
  ...
}:
let
  cfg = config.services.github-notify;
in
{

  options.services.github-notify = with lib; {

    enable = mkEnableOption ''
      Enable bbrf
    '';
    user = mkOption {
      type = types.str;
      default = null;
      description = "Run as this user";
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.timers."github-notify-timer" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "1min";
        OnUnitActiveSec = "5min";
        Unit = "github-notify.service";
      };
    };

    systemd.services."github-notify" = {

      script = ''
        #! /usr/bin/env bash

        set -euo pipefail

        DATA=$(${pkgs.curl}/bin/curl -L \
          -H "Accept: application/vnd.github+json" \
          -H "Authorization: Bearer ${user.ghk}" \
          -H "X-GitHub-Api-Version: 2022-11-28" \
          https://api.github.com/notifications)

        ${pkgs.jq}/bin/jq '[.[] | select(.repository.owner.login == "budbee" or .repository.owner.login == "instabox") | select(.subject.title | contains("chore(deps") | not )]' <<< "$DATA" > ~/Public/github/notifications.json

        echo success

      '';
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
      };
    };
  };
}
