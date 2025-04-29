{
  inputs,
  config,
  user,
  lib,
  pkgs,
  ...
}:
let
  modifier = "Mod4";
  theme = import (../themes/. + "/${user.theme}.nix");
in
{
  home.packages = with pkgs; [
    #swaynotificationcenter
    #xdg-desktop-portal-wlr
    kanshi
    swaylock
    wl-clipboard
    shotman
    grim
    wofi
    font-awesome
  ];

  services.cliphist = {
    enable = true;
    extraOptions = [
      "-max-dedupe-search"
      "10"
      "-max-items"
      "100"
    ];
  };

  programs.zsh.shellAliases = {
    clip = "cliphist-rofi | wofi -show -dmenu| wl-copy";
  };

  home.file = {
    ".config/sway/config" = {
      enable = true;

      text = builtins.concatStringsSep "\n" [
        (builtins.readFile ../sway/config)
        ''

          output * background ~/.background-image fill

          bar {
            swaybar_command ${pkgs.waybar}/bin/waybar
          }


          for_window [window_type="dialog"] floating enable
          for_window [window_type="utility"] floating enable
          for_window [window_type="toolbar"] floating enable
          for_window [window_type="splash"] floating enable
          for_window [window_type="menu"] floating enable
          for_window [window_type="dropdown_menu"] floating enable
          for_window [window_type="popup_menu"] floating enable
          for_window [window_type="tooltip"] floating enable
          for_window [window_type="notification"] floating enable


          for_window [app_id=".*"] border pixel 2

          default_border pixel 2
          default_floating_border normal

          gaps inner 5
          gaps outer 5

          client.focused          ${theme.main} ${theme.main} ${theme.secondary} ${theme.secondary}
          client.focused_inactive ${theme.secondary} ${theme.secondary} ${theme.main} ${theme.secondary}
          client.unfocused        ${theme.secondary} ${theme.secondary} ${theme.main} ${theme.secondary}
          client.urgent           ${theme.secondary} ${theme.accent2} ${theme.accent2} ${theme.secondary}


          # startup applications
          exec ${pkgs.blueman}/bin/blueman-applet

        ''
      ];
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
        github = pkgs.writeScriptBin "exe" ''
          count=`curl -u username:${user.ghk} https://api.github.com/notifications | jq '. | length'`
          echo '{"text":'$count',"tooltip":"$tooltip","class":"$class"}'
        '';
      in

      {
        enable = true;
        text = # json
          ''
            {
                "layer": "top",
                "position": "top",
                "height": 35,
                "spacing": 10,
                "reload_style_on_change": true,
                "modules-left": ["sway/workspaces"],
                "modules-center": [],
                "modules-right": [
                    "custom/github",
                    "custom/tailscale",
                    "network",
                    "pulseaudio/slider",
                    "bluetooth",
                    "temperature",
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
                    "format": "{bandwidthDownBits} / {bandwidthUpBits} ",
                    "format-wifi": "{essid} ({signalStrength}%) ",
                    "format-disconnected": "",
                    "tooltip-format": "{ifname} via {gwaddr} 󰊗 \n {ipaddr}/{cidr} 󰊗 \n {bandwidthDownBytes} / {bandwidthUpBytes}",
                    "max-length": 50,
                    "interval": 10,
                    "on-click": "nm-connection-editor"
                },
                "bluetooth": {
                    "format-on": "󰂯 ",
                    "format-off": "BT-off",
                    "format-disabled": "󰂲",
                    "format-connected-battery": "{device_battery_percentage}% 󰂯",
                    "format-alt": "{device_alias} 󰂯",
                    "tooltip-format": "{controller_alias}\t{controller_address}\n\n{num_connections} connected",
                    "tooltip-format-connected": "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}",
                    "tooltip-format-enumerate-connected": "{device_alias}\n{device_address}",
                    "tooltip-format-enumerate-connected-battery": "{device_alias}\n{device_address}\n{device_battery_percentage}%",
                    "on-click-right": "blueman-manager"
                },
                "temperature": {
                    "hwmon-path": "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon2/temp1_input",
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
                    "format": "CPU {usage}%",
                    "interval": 5,
                    "tooltip": true
                },
                "memory": {
                    "format": "RAM {percentage}%"
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
                    "exec": "${weather}/bin/exe",
                    "return-type": "simple",
                    "restart-interval": 4,
                    "interval": 10,
                    "format": "{}"
                },
                "custom/github": {
                    "exec": "${github}/bin/exe",
                    "return-type": "json",
                    "restart-interval": 4,
                    "interval": 600,
                    "format": "  {}",
                    "on-click": "xdg-open https://github.com/notifications"
                }
            }

          '';

      };

    ".config/waybar/style-dark.css" =
      let
        background-module = "black";
        background = "rgba(0, 0, 0, 0.9)";
        foreground = "white";
        accent = theme.accent;
      in
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
                background-color: ${background};
                color: ${foreground};
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
            #tray,
            #custom-tailscale,
            #custom-github,
            #mode {
                padding: 0 10px;
                margin: 6px 3px; 
                color: ${background-module};
            }

            #window,
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

            #custom-tailscale {
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

            #tray {
                background-color: ${accent};
            }

            #custom-tailscale.green_text {
              background-color: green;
            }

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
