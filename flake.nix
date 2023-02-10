{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-2111.url = "github:NixOS/nixpkgs/nixos-21.11";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwinNixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.11-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "darwinNixpkgs";
    bbrf.url = "github:vhsconnect/bbrf-radio/master";
    bbrf.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs: {

    darwinConfigurations = {
      macv = inputs.darwin.lib.darwinSystem
        (import ./machines/macv.nix inputs);
    };

    nixosConfigurations = {
      mpu3 = inputs.nixpkgs.lib.nixosSystem
        (import ./machines/mpu3.nix inputs);


      mpu4 = inputs.nixpkgs.lib.nixosSystem
        (import ./machines/mpu4.nix inputs);

    };
  };
}
