{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    wofi
    waybar
    hyprpaper
  ];
}
