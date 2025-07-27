inputs:
let
  user = (import ../user.nix).mpu4;
  otherHosts = import ../user.nix;
  desktopEnvironments = if (import ../user.nix).mpu4.usei3 then [ ../desktop/i3.nix ] else [ ];
  system = "x86_64-linux";
  bbrf = import ../systemConfiguration/bbrf.nix { enableNginx = true; };
in
{
  inherit system;
  specialArgs = {
    inherit inputs;
    inherit system;
    inherit user;
    inherit otherHosts;
  };
  modules = [
    ../configuration.nix
    ../modules/bbrf.nix
    bbrf
    (
      { ... }:
      {
        services.resolved.enable = true;
      }
    )
    inputs.bbrf.nixosModules.${builtins.currentSystem}.bbrf
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useUserPackages = true;
      home-manager.users.vhs = import ../homemanager/home.nix;
      home-manager.extraSpecialArgs = {
        inherit inputs;
        inherit user;
        inherit system;
        _imports =
          [
            ../homemanager/zsh.nix
            ../homemanager/mimeappsList.nix
            ../homemanager/vim/vim.nix
            ../homemanager/modules/dunst.home.nix
            ../homemanager/modules/rofi.home.nix
            ../homemanager/modules/git.nix
            ../homemanager/scripts/scripts.nix
            ../homemanager/scripts/templates.nix
            (
              { pkgs, ... }:
              {
                home.packages = with pkgs; [
                  #themePackages
                  xfce.xfce4-icon-theme
                  #guiPackages
                  alacritty
                  arandr
                  #linuxPackages
                  xwallpaper
                  acpi
                  networkmanagerapplet
                  #packages
                  coreutils
                  nixpkgs-fmt
                  silver-searcher
                  fd
                  eza
                  nerd-fonts.fira-code
                ];
              }
            )
          ]
          ++ (
            if user.usei3 then
              [
                ../homemanager/i3/i3blocks.home.nix
                ../homemanager/i3/i3.home.nix
              ]
            else
              [ ../homemanager/sway.nix ]
          );
      };
    }
  ] ++ desktopEnvironments;
}
