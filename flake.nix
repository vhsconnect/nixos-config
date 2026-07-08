{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    disko.url = "github:nix-community/disko";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    #sentinelone.url = "git+file:../sentinelone-nix";
    darwinNixpkgs.url = "github:nixos/nixpkgs/nixpkgs-26.05-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "darwinNixpkgs";
    editor.url = "github:vhsconnect/nvim";
    basmati.url = "github:vhsconnect/basmati";
    bbrf.url = "github:vhsconnect/bbrf-radio";

    alacritty_themes = {
      url = "github:alacritty/alacritty-theme";
      flake = false;
    };

    pi_themes = {
      url = "github:hasit/pi-community-themes";
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
      inherit (inputs.nixpkgs) legacyPackages;
      inherit (builtins) map foldl';
    in
    {

      darwinConfigurations = {
        mq = inputs.darwin.lib.darwinSystem (import ./machines/mq.nix inputs);
      };

      nixosConfigurations = {
        mpu3 = inputs.nixpkgs.lib.nixosSystem (import ./machines/mpu3.nix inputs);

        mpu3a = inputs.nixpkgs.lib.nixosSystem (import ./machines/mpu3a.nix inputs);

        mpu3b = inputs.nixpkgs.lib.nixosSystem (import ./machines/mpu3b.nix inputs);

        mbt = inputs.nixpkgs.lib.nixosSystem (import ./machines/mbt.nix inputs);

        mpu4 = inputs.nixpkgs.lib.nixosSystem (import ./machines/mpu4.nix inputs);

        mbison = inputs.nixpkgs.lib.nixosSystem (import ./machines/mbison.nix inputs);

        fbison = inputs.nixpkgs.lib.nixosSystem (import ./machines/fbison.nix inputs);

        mbebe = inputs.nixpkgs.lib.nixosSystem (import ./machines/mbebe.nix inputs);

        latest = inputs.nixpkgs.lib.nixosSystem (import ./machines/iso.nix inputs);

        generic = inputs.nixpkgs.lib.nixosSystem (import ./machines/generic.nix inputs);
      };

      devShells =
        let
          mapSystems = x: map x systems;
          mergeAttributeSets = foldl' (a: b: a // b) { };
        in
        mergeAttributeSets (
          mapSystems (x: {
            ${x}.default =
              with legacyPackages.${x};
              mkShell {
                buildInputs = [
                  git-crypt
                  nixpkgs-fmt
                ];
              };
          })
        );
    };
}
