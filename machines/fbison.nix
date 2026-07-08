inputs:
let
  user = (import ../user.nix).fbison;
  otherHosts = import ../user.nix;
  packagesDev = import ../homemanager/packages-dev.nix;
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
        # ../systemConfiguration/niriDesktop.nix
      ];
  system = "x86_64-linux";
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
    inputs.disko.nixosModules.disko

    ../modules/immich.nix
    immich

    ../configuration.nix
    ../modules/dlProcess.nix
    ../modules/githubNotify.nix
    # ../modules/icecast.nix
    ../systemConfiguration/docker.nix
    ../systemConfiguration/ollama.nix
    # ../systemConfiguration/icecastConfiguration.nix
    ../systemConfiguration/libVirt.nix
    # ../systemConfiguration/printing.nix
    ../systemConfiguration/syncthing/syncthing.nix
    ../systemConfiguration/jellyfin.nix
    # ../systemConfiguration/iphone.nix

    (
      { pkgs, ... }:
      {

        imports = [

          (../. + "/hardware/${user.host}" + "/hardware-configuration.nix")
        ];

        system.stateVersion = "26.05";

        services.github-notify = {

          enable = true;
          user = "office";
        };
        services.dl-process = {
          enable = true;
          user = "vhs";
          file = "~/dlp-files";
          errorFile = "~/dlp-error-files";
          outputDir = "~/Sync2";
        };
        services.xscreensaver = {
          enable = false;
        };

        # gaming
        environment.systemPackages = with pkgs; [
          lutris
          winetricks
          protonup-qt
        ];

      }
    )
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
        _imports = [
          ../homemanager/packages.nix
          ../homemanager/guiPackages.nix
          ../homemanager/linuxPackages.nix
          ../homemanager/themePackages.nix
          ../homemanager/zsh.nix
          ../homemanager/mimeappsList.nix
          ../homemanager/vim/vim.nix
          ../homemanager/modules/dunst.home.nix
          ../homemanager/modules/rofi.home.nix
          ../homemanager/modules/git.nix
          ../homemanager/scripts/scripts.nix
          ../homemanager/scripts/templates.nix
          ../homemanager/modules/tmux.nix
          ../homemanager/easyeffects.nix
          ../homemanager/eq.nix
          ../homemanager/homeFiles.nix
          (
            { pkgs, ... }:
            {

              home.file = {
                ".background-image" = {
                  enable = true;
                  source = ../nixos.png;
                };
              };

              home.packages = (packagesDev pkgs).ps;
            }
          )

        ]
        ++ homemanagerGtkImports
        ++ homemanagerDesktopImports;
      };
    }
  ]
  ++ desktopEnvironments;
}
