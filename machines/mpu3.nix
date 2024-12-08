inputs:
let
  user = (import ../user.nix).mpu3;
  otherHosts = import ../user.nix;
  desktopEnvironments =
    if user.usei3 then
      [
        ../desktop/i3.nix
        ../desktop/gnome.nix
      ]
    else
      [ ../desktop/gnome.nix ];
  system = "x86_64-linux";
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
    ../modules/bbrf.nix
    inputs.bbrf.nixosModules.x86_64-linux.bbrf
    inputs.home-manager.nixosModules.home-manager
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
        _imports =
          [
            ../homemanager/packages.nix
            ../homemanager/waylandPackages.nix
            ../homemanager/guiPackages.nix
            ../homemanager/linuxPackages.nix
            ../homemanager/themePackages.nix
            ../homemanager/zsh.nix
            ../homemanager/mimeappsList.nix
            ../homemanager/vim/vim.nix
            ../homemanager/i3/i3blocks.home.nix
            ../homemanager/i3/i3.home.nix
            ../homemanager/modules/dunst.home.nix
            ../homemanager/modules/rofi.home.nix
            ../homemanager/modules/git.nix
            ../homemanager/modules/hexchat.nix
            ../homemanager/modules/eww.nix
            ../homemanager/scripts/scripts.nix
            ../homemanager/scripts/templates.nix
            ../homemanager/modules/tmux.nix
            ../homemanager/modules/webapps.nix
            ../homemanager/homeFiles.nix
          ]
          ++ (if user.withgtk then [ ../homemanager/modules/gtk3.nix ] else [ ])
          ++ (if user.usei3 then [ ] else [ ../homemanager/sway.nix ]);
      };
    }
  ] ++ desktopEnvironments;
}
