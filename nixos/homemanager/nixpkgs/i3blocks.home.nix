{ pkgs, lib, ... }:
let
  theme = (import ./themes/current.nix).theme;
  pathI3Blocks = "~/Repos/nixos-config/nixos/homemanager/nixpkgs/i3blocks";
in
{
  xdg.configFile."i3blocks/config".text = ''
    command=$SCRIPT_DIR/$BLOCK_NAME
    separator_block_width=30
    markup=none

    [battery]
    command=${pathI3Blocks}/battery2
    label= 
    interval=30
    color=${theme.secondary}


    [bandwidth]
    command=${pathI3Blocks}/bandwidth3
    markup=pango
    label=
    interval=persist
    color=${theme.secondary}


    [weather]
    label=
    command=${pathI3Blocks}/weather
    interval=1800
    color=${theme.secondary}


    [calendar]
    label=
    command=${pathI3Blocks}/calendar
    interval=59
    color=${theme.secondary}
  '';

}
