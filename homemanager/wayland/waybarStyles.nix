{
  user,
  ...
}:

let
  theme = import (../themes/. + "/${user.theme}.nix");

  waybarStyles =
    {
      background,
      background-module,
      foreground,
      accent,
    }:
    {
      enable = true;
      text = # css
        ''
          * {
              border: none;
              border-radius: 0px;
              font-family: "${user.secondaryFont}", Helvetica, Arial, sans-serif;
              font-size: 13px;
              min-height: 0;
          }

          window#waybar {
              all:unset;
          }

          #workspaces button {
              background-color: transparent;
              color: ${foreground};
          }


          #workspaces button.focused {
              background-color: #64727D;
          }

          #workspaces button.urgent {
              background-color: #eb4d4b;
          }

          #mode {
              background-color: #64727D;
          }

          #clock,
          #custom-weather,
          #battery,
          #cpu,
          #memory,
          #temperature,
          #backlight,
          #network,
          #pulseaudio,
          #custom-tailscale,
          #custom-github,
          #custom-disks {
              padding: 0 10px;
              margin: 6px 3px; 
              color: ${background-module};
          }

          #workspaces {
              margin: 0 2px;
          }

          /* If workspaces is the leftmost module, omit left margin */
          .modules-left > widget:first-child > #workspaces {
              margin-left: 0;
          }

          /* If workspaces is the rightmost module, omit right margin */
          .modules-right > widget:last-child > #workspaces {
              margin-right: 0;
          }

          #pulseaudio-slider slider {
              min-height: 0px;
              min-width: 0px;
              opacity: 0;
              background-image: none;
              border: none;
              box-shadow: none;
          }
          #pulseaudio-slider trough {
              min-height: 10px;
              min-width: 80px;
              border-radius: 5px;
              background-color: ${background-module};
          }
          #pulseaudio-slider highlight {
              min-width: 10px;
              border-radius: 5px;
              background-color: ${accent};
          }


          #clock {
              background-color: ${background-module};
              color: ${foreground};
          }

          #battery {
              background-color: ${background-module};
              color: ${foreground};
          }

          #battery.charging {
              color: ${foreground};
              background-color: ${background-module};
          }

          @keyframes blink {
              to {
                  background-color: #ffffff;
                  color: #000000;
              }
          }

          #battery.critical:not(.charging) {
              background-color: ${accent};
              color: ${foreground}; 
              animation-name: blink;
              animation-duration: 0.5s;
              animation-timing-function: linear;
              animation-iteration-count: infinite;
              animation-direction: alternate;
          }

          label:focus {
              background-color: ${background-module};
          }

          #cpu {
              background-color: ${background-module};
              color: ${foreground};
          }

          #memory {
              background-color: ${background-module};
              color: ${foreground};
          }

          #custom-disks {
              background-color: ${background-module};
              color: ${foreground};
          }

          #custom-disks.accent-on {
              background-color: ${accent};
              color: ${foreground};
          }

          #custom-tailscale {
              background-color: ${background-module};
              color: ${foreground};
          }

          #custom-github {
              background-color: ${background-module};
              color: ${foreground};
          }

          #custom-weather {
              background-color: ${background-module};
              color: ${foreground};
          }

          #backlight {
              background-color: ${background-module};
              color: ${foreground};
          }

          #network {
              background-color: ${background-module};
              color: ${foreground};

          }

          #network.disconnected {
              background-color: ${accent};
              color: ${foreground};
          }

          #pulseaudio.muted {
              background-color: ${background-module};
              color: ${accent};
          }

          #temperature {
              background-color: #f0932b;
          }

          #temperature.critical {
              background-color: #eb4d4b;
          }


          #custom-tailscale.green_text {
            background-color: green;
          }

        '';

    };
in
{

  home.file = {
    ".config/waybar/style-dark.css" = waybarStyles {
      background-module = "black";
      background = "rgba(0, 0, 0, 0.9)";
      foreground = "white";
      accent = theme.accent;
    };

    ".config/waybar/style-light.css" = waybarStyles {
      background-module = "oldlace";
      background = "white";
      foreground = "rgba(0, 0, 0, 0.9)";
      accent = theme.accent;
    };
  };

}
