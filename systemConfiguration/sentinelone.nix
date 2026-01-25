{
  inputs,
  ...
}:
{
  imports = [
    inputs.sentinelone.nixosModules.sentinelone
  ];

  services.sentinelone.enable = true;

}
