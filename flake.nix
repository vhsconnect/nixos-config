{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixpkgs-2111.url = "github:NixOS/nixpkgs/nixos-21.11";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwinNixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "darwinNixpkgs";
    bbrf.url = "github:vhsconnect/bbrf-radio/master";
    bbrf.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs:
    let genAttrs = inputs.nixpkgs.lib.attrsets.genAttrs; in
    {
      formatter =
        (
          genAttrs
            [ "aarch64-linux" "x86_64-linux" "aarch64-linux" ]
            (x: inputs.nixpkgs.legacyPackages.${x}.nixpkgs-fmt)
        );

      darwinConfigurations = {
        macv = inputs.darwin.lib.darwinSystem
          (import ./machines/macv.nix inputs);
      };

      nixosConfigurations = {
        mpu3 = inputs.nixpkgs.lib.nixosSystem
          (import ./machines/mpu3.nix inputs);

        mpu4 = inputs.nixpkgs.lib.nixosSystem
          (import ./machines/mpu4.nix inputs);

        tv1 = inputs.nixpkgs.lib.nixosSystem
          (import ./machines/tv1.nix inputs);

        munin = inputs.nixpkgs.lib.nixosSystem
          (import ./machines/munin.nix inputs);

      };
    };
}
