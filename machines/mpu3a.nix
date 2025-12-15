inputs:
let
  user = (import ../user.nix).mpu3a;
  otherHosts = import ../user.nix;

  desktopEnvironments =
    if user.usei3 then
      [
        ../desktop/i3.nix
        ../systemConfiguration/x11Desktop.nix
        # ../desktop/gnome.nix
      ]
    else
      [
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
          ../homemanager/mimeappsList.nix
          ../homemanager/vim/vim.nix
          ../homemanager/i3/i3blocks.home.nix
          ../homemanager/i3/i3.home.nix
          ../homemanager/modules/dunst.home.nix
          ../homemanager/modules/rofi.home.nix
          ../homemanager/modules/git.nix
          ../homemanager/scripts/scripts.nix
          ../homemanager/scripts/templates.nix
          ../homemanager/easyeffects.nix
          ../homemanager/modules/tmux.nix
          ../homemanager/homeFiles.nix
          ../homemanager/packages-small.nix
        ]
        ++ (if user.withgtk then [ ../homemanager/modules/gtk3.nix ] else [ ])
        ++ homemanagerDesktopImports;
      };
    }
  ]
  ++ desktopEnvironments;
}
