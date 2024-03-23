{ pkgs, inputs, ... }:
{
  home.packages = with pkgs;
    [
      slack
      azure-cli
    ];
}
