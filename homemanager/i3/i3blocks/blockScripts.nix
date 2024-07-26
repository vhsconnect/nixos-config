{ config, pkgs, ... }:
{
  config.xdg.configFile."i3blocks/battery2".text = builtins.readFile ./battery2;
  config.xdg.configFile."i3blocks/cpu".text = builtins.readFile ./cpu;
  config.xdg.configFile."i3blocks/cpu_temp".text = builtins.readFile ./coretempsensors;
  config.xdg.configFile."i3blocks/disk".text = builtins.readFile ./disk;
  config.xdg.configFile."i3blocks/disk2".text = builtins.readFile ./disk2;
  config.xdg.configFile."i3blocks/memory".text = builtins.readFile ./memory;
  config.xdg.configFile."i3blocks/bandwidth3".text = builtins.readFile ./bandwidth3;
  config.xdg.configFile."i3blocks/weather".text = builtins.readFile ./weather;
  config.xdg.configFile."i3blocks/calendar".text = builtins.readFile ./calendar;
  config.home.packages = [
    (pkgs.writeScriptBin "i3b_battery" config.xdg.configFile."i3blocks/battery2".text)
    (pkgs.writeScriptBin "i3b_cpu" config.xdg.configFile."i3blocks/cpu".text)
    (pkgs.writeScriptBin "i3b_cpu_temp" config.xdg.configFile."i3blocks/cpu_temp".text)
    (pkgs.writeScriptBin "i3b_disk" config.xdg.configFile."i3blocks/disk".text)
    (pkgs.writeScriptBin "i3b_disk2" config.xdg.configFile."i3blocks/disk2".text)
    (pkgs.writeScriptBin "i3b_memory" config.xdg.configFile."i3blocks/memory".text)
    (pkgs.writeScriptBin "i3b_bandwidth" config.xdg.configFile."i3blocks/bandwidth3".text)
    (pkgs.writeScriptBin "i3b_weather" config.xdg.configFile."i3blocks/weather".text)
    (pkgs.writeScriptBin "i3b_calendar" config.xdg.configFile."i3blocks/calendar".text)
  ];
}
