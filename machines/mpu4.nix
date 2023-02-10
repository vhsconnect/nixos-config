inputs: {
  system = "x86_64-linux";
  specialArgs = {
    inherit inputs;
    user = (import ../user.nix).mpu4;
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
        };
      }
    ];
}
