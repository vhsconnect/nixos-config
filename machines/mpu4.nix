inputs:
let
  user = (import ../user.nix).mpu4;
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
  modules =
    [
      ../configuration.nix
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useUserPackages = true;
        home-manager.users.vhs = import ../homemanager/home.nix;
        home-manager.extraSpecialArgs = {
          inherit inputs;
          user = (import ../user.nix).mpu4;
          _imports = [
            ../homemanager/packages.nix
            ../homemanage/guiPackages.nix
            ../homemanage/linuxPackages.nix
            ../homemanage/themePackages.nix
            ../homemanage/zsh.nix
            ../homemanage/mimeappsList.nix
            ../homemanage/vim/vim.nix
            ../homemanage/i3/i3blocks.home.nix
            ../homemanage/i3/i3.home.nix
            ../homemanage/modules/dunst.home.nix
            ../homemanage/modules/rofi.home.nix
            ../homemanage/modules/git.nix
            ../homemanage/modules/hexchat.nix
            ../homemanage/scripts/scripts.nix
            ../homemanage/scripts/scripts.nix
            ../homemanage/scripts/templates.nix
          ] ++ (if user.withgtk then [
            ../homemanager/modules/gtk3.nix
          ] else [ ]);
        };
      }
    ] ++ desktopEnvironments;
}
