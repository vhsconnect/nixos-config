{
  pkgs,
  ...
}:
let

  trips4 = pkgs.writeScriptBin "trips4" ''
    #! /usr/bin/env bash
    xrandr --auto --output HDMI2 --primary --mode 1920x1080 --same-as eDP1
    xrandr --auto --output DP1 --mode 2560x1440 --left-of eDP1
    xwallpaper --screen 0 --stretch ~/.background-image
    xwallpaper --screen 1 --stretch ~/.background-image
  '';
  trips5 = pkgs.writeScriptBin "trips5" ''
    #!/usr/bin/env bash
    xrandr \
    --output DisplayPort-0 --primary --mode 2560x1440 --pos 0x0 --rotate left \
    --output DisplayPort-1 --off \
    --output DisplayPort-2 --off \
    --output HDMI-A-0 --mode 1920x1080 --pos 1440x967 --rotate normal
    xwallpaper --output DisplayPort-0 --zoom ~/.background-image
    xwallpaper --output HDMI-A-0 --stretch ~/.background-image
  '';

  trips10 = pkgs.writeScriptBin "trips10" ''
    #! /usr/bin/env bash

     xrandr \
     --output eDP-1 --off \
     --output HDMI-1 --off \
     --output DP-1 --mode 3440x1440 --pos 1920x0 --rotate normal \
     --output DP-2 --off \
     --output DP-3 --off \
     --output DP-4 --off

     xwallpaper --screen 0 --zoom ~/.background-image

  '';
  trips11 = pkgs.writeScriptBin "trips11" ''
    #! /usr/bin/env bash

    xrandr eDP-1 --mode 1920x1200 --pos 0x0 --rotate normal 
    xwallpaper --screen 0 --zoom ~/.background-image
  '';
  trips-sway-1 = pkgs.writeScriptBin "trips-sway-1" ''
    #! /usr/bin/env bash
    # double dells

    swaymsg output DP-1 mode  2560x1440@59.951hz
    swaymsg output DP-1 pos 1571 623
    swaymsg output DP-1 transform normal
    swaymsg output DP-1 scale 1.0
    swaymsg output DP-1 scale_filter nearest
    swaymsg output DP-1 adaptive_sync off
    swaymsg output DP-1 dpms on
                  
    swaymsg output DP-2 mode 1600x900@60.0hz
    swaymsg output DP-2 pos 4131 623
    swaymsg output DP-2 transform 270
    swaymsg output DP-2 scale 1.0
    swaymsg output DP-2 scale_filter nearest
    swaymsg output DP-2 adaptive_sync off
    swaymsg output DP-2 dpms on
  '';

in
{
  home.packages = [
    trips4
    trips5
    trips10
    trips11
    trips-sway-1
  ];
}
