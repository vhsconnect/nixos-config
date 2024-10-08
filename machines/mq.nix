inputs:
let
  user = (import ../user.nix).mq;
  system = "aarch64-darwin";
in
{
  system = system;
  specialArgs = {
    inherit inputs;
    inherit user;
    inherit system;
  };
  modules = [
    ../darwinConfiguration.nix
    ../modules/bbrf.nix
    (import ../systemConfiguration/bbrf.nix { enableNginx = false; })
    inputs.bbrf.nixosModules.${builtins.currentSystem}.bbrf
    inputs.home-manager.darwinModules.home-manager
    {
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "hmback";
      home-manager.users.vhs = import ../homemanager/darwinHome.nix;
      home-manager.extraSpecialArgs = {
        inherit system;
        inputs = inputs;
        user = user;

        _imports = [
          ../homemanager/homeFiles.nix
          ../homemanager/packages.nix
          ../homemanager/workPackages.nix
          ../homemanager/vim/vim.nix
          ../homemanager/zsh.nix
          ../homemanager/modules/git.nix
          ../homemanager/modules/tmux.nix
        ];
      };
    }
  ];
}
