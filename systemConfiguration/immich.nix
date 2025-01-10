{ config, ... }:
{
  immich = {
    enable = true;
    group = "ops";
    groupId = config.users.groups.ops.gid;
    immichDir = "/home/vhs/Data/Immich";
    autoStart = true;
    port = 3600;

  };
}
