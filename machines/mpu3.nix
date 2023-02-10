inputs: {
  system = "x86_64-linux";
  specialArgs = {
    inherit inputs;
    user = (import ../user.nix).mpu3;
  };
  modules =
    [
      ../configuration.nix
      inputs.bbrf.nixosModules.${builtins.currentSystem}.bbrf
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "hmback";
        home-manager.users.vhs = import ../homemanager/home.nix;
        home-manager.extraSpecialArgs = {
          inputs = inputs;
          user = (import ../user.nix).mpu3;
        };
      }
    ];
}
