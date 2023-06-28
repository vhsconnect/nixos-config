{ user, ... }:
{
  xdg.configFile = {
    "eww/eww.yuck".text = ''
      (defwindow quick-menu
        :stacking "fg"
        :windowtype "normal"
        :wm-ignore true
        :reserve (struts :distance "40px" :side "top")
        :windowtype "desktop"
        :geometry (geometry :x "0%"
                            :y "20px"
                            :width "100%"
                            :height "100px"
                            :anchor "center left")
        (button-box))

      (defpoll time :interval "5s"
        :initial `date +'{"hour":"%H","min":"%M"}'`
        `date +'{"hour":"%H","min":"%M"}'`
        )

      (defwidget button-box []
        (box :orientation "horizontal" :halign "center" :class "button-box"
            (button :class "black-text" :onclick "nm-connection-editor & eww close quick-menu" "wifi")
            (button :class "black-text" :onclick "blueman-manager & eww close quick-menu" "bluetooth")
            (button :class "black-text" :onclick "robl & eww close quick-menu" "rofi bluetooth")
            (button :class "black-text" :onclick "bluetoothctl power off & eww close quick-menu" "kill bluetooth")
            (label   :text "''${time.hour}:''${time.min}")
            )
        )
    '';
    "eww/eww.scss".text = ''
      $surface-darkgrey: #20252b;
      $surface-fg: #949494;
      $surface-lightgrey: #3d464e;
      $surface-grey: #2b3238;
      $surface-red: #f87070;

      * {
        all: unset;
      }

      button {
        padding: 0.4em;
        border-radius: 0.1em;
        background-color: black;
        color: smoke;

        &:hover {
          transition: 200ms linear background-color, border-radius;
          background-color: rgba($surface-darkgrey, 0.1);
        }

      }

    '';
  };

}
