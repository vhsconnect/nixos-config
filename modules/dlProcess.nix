{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.dl-process;
  script = (import ../homemanager/scripts/dlProcess.nix { inherit pkgs; }).script;
in
{

  options.services.dl-process = with lib; {

    enable = mkEnableOption ''
      process urls from a file
    '';
    user = mkOption {
      type = types.str;
      default = null;
      description = "Run as this user";
    };
    file = mkOption {
      type = types.str;
      default = null;
      description = "Path to file to process";
    };
    logFile = mkOption {
      type = types.str;
      default = null;
      description = "Path to append stdout";
    };
    errorFile = mkOption {
      type = types.str;
      default = null;
      description = "Path to file to error log to";
    };
    outputDir = mkOption {
      type = types.str;
      default = null;
      description = "Output directory";
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.timers."dl-process-timer" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "00:00";
        Persistent = false;
        Unit = "dl-process.service";
      };
    };

    systemd.services."dl-process" =
      let
        binScript = pkgs.writeScriptBin "_dl-process" script;
      in
      {

        script = ''
          ${pkgs.babashka}/bin/bb ${binScript}/bin/_dl-process --file ${cfg.file} --log-file ${cfg.logFile} --error-file ${cfg.errorFile} --output-dir ${cfg.outputDir}
        '';

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
        };
      };
  };
}
