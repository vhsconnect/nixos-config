inputs:
let
  user = (import ../user.nix).mbebe;
  otherHosts = import ../user.nix;
  desktopEnvironments = [
    ../desktop/i3.nix
    ../desktop/gnome.nix
  ];
  system = "x86_64-linux";
  #  bbrf = import ../systemConfiguration/bbrf.nix { enableNginx = false; };
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
    #../modules/bbrf.nix
    ../modules/githubNotify.nix
    ../systemConfiguration/docker.nix
    # ../systemConfiguration/printing.nix
    #../systemConfiguration/libVirt.nix
    ../systemConfiguration/tailscale.nix
    #../systemConfiguration/nosleep.nix
    ../systemConfiguration/sentinelone.nix
    # ../systemConfiguration/fintech.nix
    # bbrf
    (
      { ... }:
      {
        services.github-notify = {
          enable = true;
          user = "vhs";
        };
      }
    )

    inputs.bbrf.nixosModules.x86_64-linux.bbrf
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useUserPackages = true;
      home-manager.useGlobalPkgs = false;
      home-manager.backupFileExtension = "backup";
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
            ../homemanager/i3/i3blocks.home.nix
            ../homemanager/i3/i3.home.nix
            ../homemanager/modules/dunst.home.nix
            ../homemanager/modules/rofi.home.nix
            ../homemanager/atuin.nix
            ../homemanager/modules/git.nix
            ../homemanager/modules/xScreensaver.nix
            ../homemanager/scripts/scripts.nix
            ../homemanager/scripts/templates.nix
            ../homemanager/easyeffects.nix
            ../homemanager/modules/tmux.nix
            ../homemanager/homeFiles.nix
          ]
          ++ (if user.withgtk then [ ../homemanager/modules/gtk3.nix ] else [ ])
          ++ homemanagerDesktopImports;
      };
    }
  ] ++ desktopEnvironments;
}
