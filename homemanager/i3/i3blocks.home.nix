{ config
, pkgs
, lib
, user
, ...
}:
let
  theme = import (../themes/. + "/${user.theme}.nix");
in
{
  xdg.configFile."i3blocks/config".text = ''
    command=$SCRIPT_DIR/$BLOCK_NAME
    separator_block_width=30
    markup=none

    [battery]
    command=i3b_battery 
    label= 
    interval=30
    color=${theme.secondary}

    [cpu_usage]
    label= 
    command=i3b_cpu
    interval=3
    color=${theme.secondary}

    [cpu_usage]
    label= 
    command=i3b_cpu_temp ${user.cpuDevice}
    interval=3
    color=${theme.secondary}

    [memory]
    label= 
    command=i3b_memory
    interval=2
    color=${theme.secondary}

    [disk]
    label= 
    instance=/
    command=i3b_disk
    interval=30
    color=${theme.secondary}

    [disk2]
    label= 
    instance=/
    command=i3b_disk2 ${user.dataPartitionPath}
    interval=30
    color=${theme.secondary}


    [bandwidth]
    command=i3b_bandwidth
    markup=pango
    label= 
    interval=persist
    color=${theme.secondary}

    [weather]
    label=
    command=i3b_weather
    interval=1800
    color=${theme.secondary}

    [calendar]
    label=
    command=i3b_calendar
    interval=59
    color=${theme.secondary}
  '';
}
