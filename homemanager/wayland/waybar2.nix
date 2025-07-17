{
  user,
  pkgs,
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
      unset,
    }:
    {
      enable = true;
      text = # css
        ''
          window#waybar {
              ${if unset then "all:unset;" else "background-color: ${background};"}
              font-family: "${user.secondaryFont}", Helvetica, Arial, sans-serif;
          }

          #workspaces {
              margin: 0 2px;
          }

          #workspaces button {
              background-color: transparent;
              color: ${foreground};
              border-radius: 0;
              
          }

          #workspaces button.focused {
              background-color: ${accent};
              color: ${background};
              border-radius: 0;
          }

          #workspaces button.urgent {
              background-color: OrangeRed;
              border-radius: 0;
          }

          #mode {
              background-color: #64727D;
          }

          #clock,
          #custom-weather,
          #battery,
          #bluetooth,
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
              margin: 5px 3px; 
              color: ${background-module};
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
                  background-color: ${accent};
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
              color : rgba(0, 0, 0, 0.9);
          }

          #temperature.critical {
              background-color: #eb4d4b;
              color : rgba(0, 0, 0, 0.9);
          }


          #custom-tailscale.green_text {
            background-color: green;
          }

        '';

    };
in
{

  home.file = {
    ".config/waybar/style.css" = waybarStyles {
      background-module = "rgba(0, 0, 0, 0.2)";
      background = "rgba(0, 0, 0, 0.9)";
      foreground = "white";
      accent = theme.accent;
      unset = true;
    };

    ".config/waybar/style-dark.css" = waybarStyles {
      background-module = "transparent";
      background = "rgba(0, 0, 0, 0.97)";
      foreground = "white";
      accent = theme.accent;
      unset = true;
    };

    ".config/waybar/style-light.css" = waybarStyles {
      background-module = "oldlace";
      background = "white";
      foreground = "rgba(0, 0, 0, 0.9)";
      accent = theme.accent;
      unset = false;
    };

    ".config/waybar/config.jsonc" =
      let
        tailscale-check = pkgs.writeScriptBin "tailscale-check" (
          builtins.readFile ./scripts/tailscale-check
        );
        tailscale-toggle =
          pkgs.writeScriptBin "tailscale-toggle"

            (
              builtins.concatStringsSep "\n" [
                ''
                  #! /usr/bin/env fish
                  set ASKPASS "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass"
                ''
                (builtins.readFile ./scripts/tailscale-toggle)
              ]
            );
        weather = pkgs.writeScriptBin "exe" (builtins.readFile ./scripts/weather);
        github =
          pkgs.writeScriptBin "exe" # bash
            ''
              count=`curl -u username:${user.ghk} https://api.github.com/notifications | jq '. | length'`
              echo '{"text":'$count',"tooltip":"$tooltip","class":"$class"}'
            '';
        disks =
          pkgs.writeScriptBin "exe" # fish
            ''
              #! /usr/bin/env fish

              set targets (df -BG --output=target $argv | tail -n +2 | string trim)
              set percentages (df -BG --output=pcent $argv | tail -n +2 | string trim)
              set availables (df -BG --output=avail $argv | tail -n +2 | string trim)

              set text

              for i in (seq (count $targets))
                  set -l target (basename $targets[$i])
                  set -a text "$target $percentages[$i]"
              end

              set tooltip

              for i in (seq (count $targets))
                  set -l target (basename $targets[$i])
                  set tooltip "$tooltip$target $percentages[$i] $availables[$i] left\n"
              end

              set class none

              for avail in $availables
                  set raw (echo $avail | awk '{gsub("G","",$1); print $1}')
                  if test $raw -lt 70
                      set class accent-on
                  end
              end

              set text (string join ' | ' $text)

              echo "{\"text\":\"$text\",\"tooltip\":\"$tooltip\", \"class\": \"$class\"}" 
            '';
      in

      {
        enable = true;
        text = # json
          ''
            [
              {
                  "modules-left": ["sway/workspaces"],
                  "position": "bottom",
                  "output": "DP-2",
              },
              {
                  "layer": "top",
                  "position": "bottom",
                  "output": "!DP-2",
                  "height": 35,
                  "spacing": 10,
                  "reload_style_on_change": true,
                  "modules-center": [],
                  "modules-left": ["sway/workspaces"],
                  "modules-right": [
                      "custom/github",
                      "custom/tailscale",
                      "network",
                      "temperature",
                      "custom/disks",
                      "cpu",
                      "memory",
                      "battery",
                      "custom/weather",
                      "clock",
                      "tray"
                  ],
                  "custom/notification": {
                      "tooltip": false,
                      "format": "",
                      "on-click": "swaync-client -t -sw",
                      "escape": true
                  },
                  "clock": {
                      "format": "{:%I:%M} ",
                      "format-alt": "{:%A, %B %d, %Y (%R)}",
                      "interval": 15,
                      "tooltip-format": "<tt>{calendar}</tt>",
                      "actions": {
                          "on-click-right": "shift_down",
                          "on-click": "shift_up"
                      }
                  },
                  "pulseaudio/slider": {
                      "format": ""
                  },
                  "network": {
                      "format": "{ifname} ",
                      "format-wifi": "({ifname} {signalStrength}%) ",
                      "format-disconnected": "disconnected",
                      "tooltip-format": "{ifname} via {gwaddr} 󰊗 \n {ipaddr}/{cidr} 󰊗 \n {bandwidthDownBytes} / {bandwidthUpBytes}",
                      "max-length": 100,
                      "interval": 10,
                      "on-click": "nm-connection-editor"
                  },
                  "temperature": {
                      "hwmon-path": "${user.hwmonPath}",
                      "format": "{temperatureC}°C "
                  },
                  "battery": {
                      "interval": 1,
                      "states": {
                          "good": 95,
                          "warning": 30,
                          "critical": 20
                      },
                      "format": "{icon} {capacity}%",
                      "format-charging": "󰂄 {capacity}%",
                      "format-plugged": "󰂄  {capacity}%",
                      "format-alt": "{icon} {time}",
                      "format-icons": ["󰁻", "󰁼", "󰁾", "󰂀", "󰂂", "󰁹"]
                  },
                  "cpu": {
                      "format": "C {usage}%",
                      "interval": 5,
                      "tooltip": true
                  },
                  "memory": {
                      "format": "R {percentage}%"
                  },
                  "tray": {
                      "icon-size": 18,
                      "spacing": 10
                  },
                  "custom/tailscale": {
                      "exec": "${tailscale-check}/bin/tailscale-check",
                      "return-type": "json",
                      "restart-interval": 4,
                      "interval": 10,
                      "format": "  {}",
                      "on-click": "${tailscale-toggle}/bin/tailscale-toggle",
                  },
                  "custom/weather": {
                      "exec": "${weather}/bin/exe ${user.location}",
                      "return-type": "simple",
                      "restart-interval": 4,
                      "interval": 10,
                      "format": "{}",
                      "on-click": "xdg-open https://www.google.com/search?q=weather"
                  },
                  "custom/github": {
                      "exec": "${github}/bin/exe",
                      "return-type": "json",
                      "restart-interval": 4,
                      "interval": 600,
                      "format": "  {}",
                      "on-click": "xdg-open https://github.com/notifications"
                  },
                  "custom/disks": {
                      "exec": "${disks}/bin/exe ${builtins.concatStringsSep " " user.disks}",
                      "return-type": "json",
                      "restart-interval": 4,
                      "interval": 60,
                      "format": "  {}",
                      "tooltip": true
                  }
                }
              ]

          '';
      };
  };

  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
      target = "sway-session.target";
    };
  };

}
