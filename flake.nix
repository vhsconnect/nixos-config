{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs: {
    nixosConfigurations = {

      mpu3 = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; host = "mpu3"; };
        modules =
          [
            ./configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.users.vhs = import ./homemanager/home.nix;
            }
          ];
      };

      mpu4 = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; host = "mpu4"; };
        modules =
          [
            ./configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.users.vhs = import ./homemanager/home.nix;
            }
          ];
      };

    };
  };
}
