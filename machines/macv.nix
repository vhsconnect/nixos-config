inputs: {
  system = "aarch64-darwin";
  specialArgs = {
    inherit inputs;
    user = (import ../user.nix).macv;
  };
  modules =
    [
      ../darwinConfiguration.nix
      inputs.home-manager.darwinModules.home-manager
      {
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "hmback";
        home-manager.users.valentin = import ../homemanager/darwinHome.nix;
        home-manager.extraSpecialArgs = {
          inputs = inputs;
          user = (import ../user.nix).macv;
        };
      }
    ];
}
