inputs:
let
  user = (import ../user.nix).tv1;
  desktopEnvironments = [
    ../desktop/i3.nix
    ../desktop/gnome.nix
  ];
in
{
  system = "x86_64-linux";
  specialArgs = {
    inherit inputs;
    inherit user;
  };
  modules = [
    ../configuration.nix
    inputs.bbrf.nixosModules.${builtins.currentSystem}.bbrf
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "hmback";
      home-manager.users.vhs = import ../homemanager/home.nix;
      home-manager.extraSpecialArgs = {
        inherit inputs;
        inherit user;
        _imports = [
          ../homemanager/packages.nix
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
          ../homemanager/scripts/scripts.nix
          ../homemanager/scripts/scripts.nix
          ../homemanager/scripts/templates.nix
        ] ++ (if user.withgtk then [ ../homemanager/modules/gtk3.nix ] else [ ]);
      };
    }
  ] ++ desktopEnvironments;
}
