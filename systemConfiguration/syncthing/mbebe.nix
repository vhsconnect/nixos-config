{ user, ... }:
{

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    dataDir = "/home/vhs/Sync";
    configDir = "/home/vhs/.syncthing";
    guiAddress = "localhost:3331";
    user = "vhs";
    group = "ops";
    settings = {
      gui = {
        user = "admin";
        password = user.syncthingGuiPass;
      };

      devices = {
        pinser = {
          id = "V5HK7HA-H564OBH-6SE77S3-RY4AFMR-F3ENF3E-6UV7HSL-CPZ5I6C-SD3HXAQ";
        };
        mpu3 = {
          id = "5XO7ZS3-U7ZD452-Z7U5QI7-K2STPKM-QL7WZBU-GHBHBQR-HR6L57P-32N2VQX";
        };
        mpu4 = {
          id = "MXC4OD2-VXLPIH6-3FGQRL7-AW2YTLZ-FAYEACI-IGXSX5M-DWAUKRH-KSZVFA3";
        };
        mbison = {
          id = "3MOHUU5-GYFZ3WD-O6VI3ZX-RWSBMFP-ZTMKNQ6-5VTXMT3-FVZ377Y-SOPNTQV";
        };
        mbebe = {
          id = "WBPCZ3R-A32TI6D-OR4XP34-2OFBY2J-O2GGES3-Q36MKQ6-E7TBA22-37SPUQW";
        };
      };
      folders = {
        "/home/vhs/Sync" = {
          id = "sync";
          devices = [
            "mbison"
            "mpu3"
            "mpu4"
            "mbebe"
          ];
        };
        "/home/vhs/Sync2" = {
          id = "sync2";
          devices = [
            "mbison"
            "pinser"
          ];
        };
        "/home/common/Folder" = {
          id = "folder";
          devices = [
            "mbison"
            "mpu3"
            "mpu4"
            "mbebe"
          ];
        };
        "/home/common/Shared" = {
          id = "shared-1";
          type = "sendonly"; # !
          devices = [
            "mbison"
            "mpu4"
            "mbebe"
          ];
        };
      };
    };
  };
}
