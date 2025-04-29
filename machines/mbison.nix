inputs:
let
  user = (import ../user.nix).mbison;
  otherHosts = import ../user.nix;
  desktopEnvironments = [
    ../desktop/i3.nix
  ];
  system = "x86_64-linux";
  bbrf = import ../systemConfiguration/bbrf.nix { enableNginx = false; };
  immich = import ../systemConfiguration/immich.nix;
  homemanagerGtkImports = if user.withgtk then [ ../homemanager/modules/gtk3.nix ] else [ ];
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
in
{
  specialArgs = {
    inherit inputs;
    inherit user;
    inherit otherHosts;
    inherit system;
  };
  modules = [
    ../configuration.nix
    ../modules/bbrf.nix
    ../modules/immich.nix
    ../modules/githubNotify.nix
    ../systemConfiguration/docker.nix
    # ../systemConfiguration/iphone.nix
    ../systemConfiguration/libVirt.nix
    ../systemConfiguration/printing.nix
    ../systemConfiguration/tailscale.nix
    ../systemConfiguration/nosleep.nix
    ../systemConfiguration/jellyfin.nix
    # ../systemConfiguration/fintech.nix

    bbrf
    immich
    (
      { ... }:
      {
        services.github-notify = {
          enable = true;
          user = "office";
        };
      }
    )
    inputs.bbrf.nixosModules.x86_64-linux.bbrf
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useUserPackages = true;
      home-manager.useGlobalPkgs = false;
      home-manager.backupFileExtension = "bkup";
      home-manager.users.vhs = import ../homemanager/home.nix;
      home-manager.users.office = import ../homemanager/work.nix;
      home-manager.extraSpecialArgs = {
        inherit inputs;
        inherit user;
        inherit system;
        _imports =
          [
            ../homemanager/packages.nix
            ../homemanager/guiPackages.nix
            ../homemanager/workPackages.nix
            ../homemanager/linuxPackages.nix
            ../homemanager/themePackages.nix
            ../homemanager/zsh.nix
            ../homemanager/mimeappsList.nix
            ../homemanager/vim/vim.nix
            ../homemanager/modules/dunst.home.nix
            ../homemanager/modules/rofi.home.nix
            ../homemanager/modules/xScreensaver.nix
            ../homemanager/modules/git.nix
            ../homemanager/modules/hexchat.nix
            ../homemanager/scripts/scripts.nix
            ../homemanager/scripts/templates.nix
            ../homemanager/modules/tmux.nix
            ../homemanager/modules/webapps.nix
            ../homemanager/easyeffects.nix
            ../homemanager/homeFiles.nix

          ]
          ++ homemanagerGtkImports
          ++ homemanagerDesktopImports;
      };
    }
  ] ++ desktopEnvironments;
}
