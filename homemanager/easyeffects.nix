{
  pkgs,
  ...
}:
{

  services.easyeffects = {
    enable = true;
    extraPresets = {
      # easyeffects -a : outputs an empty profile for some reason
      # when this profile is active
      balanced = {
        "output" = {
          "blocklist" = [ ];
          "equalizer#0" = {
            "balance" = 0.1;
            "bypass" = false;
            "input-gain" = 0.1;
            "left" = {
              "band0" = {
                "frequency" = 22.4;
                "gain" = 0.0;
                "mode" = "RLC (BT)";
                "mute" = false;
                "q" = 4.36;
                "slope" = "x1";
                "solo" = false;
                "type" = "Bell";
                "width" = 4.0;
              };
            };
            "mode" = "IIR";
            "num-bands" = 32;
            "output-gain" = 0.0;
            "pitch-left" = 0.0;
            "pitch-right" = 0.0;
            "right" = {
              "band0" = {
                "frequency" = 22.4;
                "gain" = 0.0;
                "mode" = "RLC (BT)";
                "mute" = false;
                "q" = 4.36;
                "slope" = "x1";
                "solo" = false;
                "type" = "Bell";
                "width" = 4.0;
              };
            };
            "split-channels" = false;
          };

          "plugins_order" = [
            "equalizer#0"
          ];
        };

      };
      lowpass = {

        "output" = {
          "blocklist" = [ ];
          "filter#0" = {
            "balance" = 0.0;
            "bypass" = false;
            "equal-mode" = "IIR";
            "frequency" = 300.0;
            "gain" = 0.0;
            "input-gain" = 0.0;
            "mode" = "LRX (MT)";
            "output-gain" = 0.0;
            "quality" = 0.0;
            "slope" = "x1";
            "type" = "Low-pass";
            "width" = 4.0;
          };
          "plugins_order" = [
            "filter#0"
          ];
        };
      };
    };
  };

  home.packages =

    let
      lowpass = pkgs.writeScriptBin "lowpass" ''

        if ! pgrep -f easyeffects > /dev/null; then
          nohup ${pkgs.easyeffects}/bin/easyeffects --gapplication-service >/dev/null 2>&1 &
          sleep 1 # give it a moment to register on DBus
        fi

        CURRENT=$(easyeffects -a | awk 'NR==1{print $3}')

        case "$CURRENT" in
        "lowpass")
          ${pkgs.easyeffects}/bin/easyeffects -l balanced 
          ;;
        "balanced")
          ${pkgs.easyeffects}/bin/easyeffects -l lowpass
          ;;
        *) # work around
          ${pkgs.easyeffects}/bin/easyeffects -l lowpass
          ;;
        esac

      '';
    in
    [
      lowpass
    ];

}
