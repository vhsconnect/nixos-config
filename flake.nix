{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-2111.url = "github:NixOS/nixpkgs/nixos-21.11";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwinNixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "darwinNixpkgs";
    bbrf.url = "github:vhsconnect/bbrf-radio/bc15fba303a551c398942092055ca487bbb1d5d6";
    editor.url = "github:vhsconnect/nvim";
    editor.inputs.nixpkgs.follows = "nixpkgs";
    basmati.url = "github:vhsconnect/basmati";
    alacritty_themes = {
      url = "github:alacritty/alacritty-theme";
      flake = false;
    };
  };
  outputs =
    inputs:
    let
      systems = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
      ];
      legacyPackages = inputs.nixpkgs.legacyPackages;
      fold = builtins.foldl';
      map = builtins.map;
    in
    {

      darwinConfigurations = {
        mq = inputs.darwin.lib.darwinSystem (import ./machines/mq.nix inputs);
      };

      nixosConfigurations = {
        mpu3 = inputs.nixpkgs.lib.nixosSystem (import ./machines/mpu3.nix inputs);

        mpu4 = inputs.nixpkgs.lib.nixosSystem (import ./machines/mpu4.nix inputs);

        tv1 = inputs.nixpkgs.lib.nixosSystem (import ./machines/tv1.nix inputs);

        munin = inputs.nixpkgs.lib.nixosSystem (import ./machines/munin.nix inputs);

        mbison = inputs.nixpkgs.lib.nixosSystem (import ./machines/mbison.nix inputs);

        mprez = inputs.nixpkgs.lib.nixosSystem (import ./machines/mprez.nix inputs);
      };

      devShells =
        let
          mapSystems = x: map x systems;
          mergeAttributeSets = fold (a: b: a // b) { };
        in
        mergeAttributeSets (
          mapSystems (x: {
            ${x}.default = with legacyPackages.${x}; mkShell { buildInputs = [ git-crypt ]; };
          })
        );
    };
}
