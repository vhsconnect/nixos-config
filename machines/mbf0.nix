inputs:
let
  user = (import ../user.nix).mbf0;
in
{
  system = "aarch64-darwin";
  specialArgs = {
    inherit inputs;
    inherit user;
  };
  modules = [
    ../darwinConfiguration.nix

    inputs.home-manager.darwinModules.home-manager
    {
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "hmback";
      home-manager.users.vhs = import ../homemanager/darwinHome.nix;
      home-manager.extraSpecialArgs = {
        inputs = inputs;
        user = user;
        _imports = [
          ../homemanager/packages.nix
          ../homemanager/vim/vim.nix
          ../homemanager/zsh.nix
          ../homemanager/modules/git.nix
          ../homemanager/modules/tmux.nix
        ];
      };
    }
  ];
}
