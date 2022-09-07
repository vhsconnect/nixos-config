{
  inputs = {
    nixpkgs-2111.url = "github:NixOS/nixpkgs/nixos-21.11";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #home-manager.inputs.nixpkgs.follows = "darwinNixpkgs";

    darwinNixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.05-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "darwinNixpkgs";
  };
  outputs = inputs: {

    darwinConfigurations = {
      macv = inputs.darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit inputs;
          user = (import ./user.nix).macv;
        };
        modules =
          [
            ./darwinConfiguration.nix
            inputs.home-manager.darwinModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hmback";
              home-manager.users.valentin = import ./homemanager/darwinHome.nix;
              home-manager.extraSpecialArgs = {
                inputs = inputs;
                user = (import ./user.nix).macv;
              };
            }
          ];
      };
    };

    nixosConfigurations = {
      mpu3 = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          user = (import ./user.nix).mpu3;
        };
        modules =
          [
            ./configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hmback";
              home-manager.users.vhs = import ./homemanager/home.nix;
              home-manager.extraSpecialArgs = {
                inputs = inputs;
                user = (import ./user.nix).mpu3;
              };
            }
          ];
      };

      mpu4 = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          user = (import ./user.nix).mpu4;
        };
        modules =
          [
            ./configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.users.vhs = import ./homemanager/home.nix;
              home-manager.extraSpecialArgs =
                { user = (import ./user.nix).mpu4; };
            }
          ];
      };

    };
  };
}
