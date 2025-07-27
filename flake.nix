{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sentinelone.url = "git+file:../sentinelone-nix";

    darwinNixpkgs.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "darwinNixpkgs";
    bbrf.url = "github:vhsconnect/bbrf-radio/";
    #bbrf.url = "git+file:../../../vhs/Repos/bbrf-radio";
    editor.url = "github:vhsconnect/nvim";
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
      inherit (inputs.nixpkgs) legacyPackages;
      inherit (builtins) map foldl';
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

        m91 = inputs.nixpkgs.lib.nixosSystem (import ./machines/m91.nix inputs);

        mprez = inputs.nixpkgs.lib.nixosSystem (import ./machines/mprez.nix inputs);

        mbebe = inputs.nixpkgs.lib.nixosSystem (import ./machines/mbebe.nix inputs);

        latest = inputs.nixpkgs.lib.nixosSystem (import ./machines/iso.nix inputs);
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
