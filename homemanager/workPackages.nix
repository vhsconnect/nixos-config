{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    colima
    docker
  ];
}
