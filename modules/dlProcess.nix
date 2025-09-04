{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.services.dl-process;
  script = ''
    # fish
       #! /usr/bin/env fish

       function exitEarly
         echo "Exiting early ..."
         exit 1
       end

       test (${pkgs.wireguard-tools}/bin/wg show interfaces | wc -l) -gt 0; or exitEarly

       set File (realpath ${cfg.file})
       set ErrorFile (realpath ${cfg.errorFile})

       set SubDir (date '+%m_%d')
       set OutputFolder (realpath ${cfg.outputDir}/$SubDir)

       mkdir -p $OutputFolder

       echo $File  >> $ErrorFile
       echo $ErrorFile >> $ErrorFile
       echo $OutputFolder >> $ErrorFile

      # cat "$File" | xargs -I {} ${pkgs.fish}/bin/fish -c '${pkgs.yt-dlp}/bin/yt-dlp -x "$argv[1]" -P "$argv[2]" 2>>"$argv[3]"; or echo "$argv[1]" >> "$argv[3]"' '{}' $OutputFolder $ErrorFile

       cat "$File" | xargs -I {} ${pkgs.fish}/bin/fish -c '${pkgs.nix}/bin/nix run github:nixos/nixpkgs#yt-dlp -- -x "$argv[1]" -P "$argv[2]" 2>>"$argv[3]"; or echo "$argv[1]" >> "$argv[3]"' '{}' $OutputFolder $ErrorFile

       echo "" >$File

  '';
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
    errorFile = mkOption {
      type = types.str;
      default = null;
      description = "Path to file to log to";
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
          ${pkgs.fish}/bin/fish ${binScript}/bin/_dl-process
        '';

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
        };
      };
  };
}
