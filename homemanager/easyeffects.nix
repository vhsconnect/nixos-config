{
  pkgs,
  ...
}:
{

  services.easyeffects = {
    enable = true;
  };

  home.packages =

    let
      lowpass = pkgs.writeScriptBin "lowpass" ''

        if ! pgrep -x easyeffects > /dev/null; then
          nohup ${pkgs.easyeffects}/bin/easyeffects --gapplication-service >/dev/null 2>&1 &
          sleep 1 # give it a moment to register on DBus
        fi

        CURRENT=$(easyeffects -a | awk 'NR==1{print $3}')

        case "$CURRENT" in
        "lowpass")
          ${pkgs.easyeffects}/bin/easyeffects -l normal
          ;;
        "normal")
          ${pkgs.easyeffects}/bin/easyeffects -l lowpass
          ;;
        esac

      '';
    in
    [
      lowpass
    ];

}
