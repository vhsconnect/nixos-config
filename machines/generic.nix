inputs:
let
  user = (import ../user.nix).generic;
  otherHosts = import ../user.nix;
  packagesSmall = import ../homemanager/packages-small.nix;

  desktopEnvironments =
    if user.usei3 then
      [
        ../desktop/i3.nix
        ../systemConfiguration/x11Desktop.nix
        # ../desktop/gnome.nix
      ]
    else
      [
        # ../systemConfiguration/niriDesktop.nix
        ../systemConfiguration/waylandDesktop.nix
      ];
  system = "x86_64-linux";
  homemanagerDesktopImports =
    if user.usei3 then
      [
        ../homemanager/i3/i3.home.nix
        ../homemanager/i3/i3blocks.home.nix
      ]
    else
      [
        ../homemanager/wayland/wayland.nix
      ];
  bbrf = import ../systemConfiguration/bbrf.nix { enableNginx = false; };
in

{
  inherit system;
  specialArgs = {
    inherit system;
    inherit inputs;
    inherit user;
    inherit otherHosts;
  };
  modules = [
    ../configuration.nix
    ../systemConfiguration/docker.nix
    ../systemConfiguration/syncthing/syncthing.nix
    ../modules/bbrf.nix
    inputs.bbrf.nixosModules.x86_64-linux.bbrf
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.disko
    bbrf
    (
      { pkgs, ... }:
      {
        # hard set as will be built with a different user
        imports = [
          (../. + "/hardware/generic" + "/hardware-configuration.nix")
          (../. + "/hardware/generic" + "/disko.nix")
        ];

        system.stateVersion = "26.05";
        users.users.vhs.initialPassword = "password";

      }
    )
    {
      home-manager.useUserPackages = true;
      home-manager.useGlobalPkgs = false;
      home-manager.backupFileExtension = "hmback";
      home-manager.users.vhs = import ../homemanager/home.nix;
      home-manager.extraSpecialArgs = {
        inherit inputs;
        inherit user;
        inherit system;
        _imports = [
          ../homemanager/zsh.nix
          ../homemanager/vim/vim.nix
          ../homemanager/i3/i3blocks.home.nix
          ../homemanager/i3/i3.home.nix
          ../homemanager/modules/dunst.home.nix
          ../homemanager/modules/rofi.home.nix
          ../homemanager/scripts/scripts.nix
          ../homemanager/scripts/templates.nix
          ../homemanager/modules/tmux.nix
          ../homemanager/eq.nix
          ../homemanager/homeFiles.nix
          (
            { pkgs, ... }:
            {
              home.packages = [
              ]
              ++ (packagesSmall pkgs).tiny;

              home.file = {
                ".background-image" = {
                  enable = true;
                  source = ../nixos.jpg;
                };
              };

            }
          )
        ]
        ++ (if user.withgtk then [ ../homemanager/modules/gtk3.nix ] else [ ])
        ++ homemanagerDesktopImports;
      };
    }
  ]
  ++ desktopEnvironments;
}
