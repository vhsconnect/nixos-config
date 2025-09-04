{ user, ... }:
{
  imports = [
    (./. + "/${user.host}.nix")
  ];
}
