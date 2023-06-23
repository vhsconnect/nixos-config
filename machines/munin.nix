inputs:
let
  user = (import ../user.nix).munin;
in
{
  system = "aarch64-linux";
  specialArgs = {
    inherit inputs;
    inherit user;
  };
  modules =
    [
      ../piConfiguration.nix
      inputs.bbrf.nixosModules.${builtins.currentSystem}.bbrf
    ];
}
