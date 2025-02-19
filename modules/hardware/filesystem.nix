{
  config,
  lib,
  pkgs,
  ...
}: {
  # Mount points for your Windows drives
  fileSystems = {
    "/mnt/games" = {
      device = "/dev/disk/by-uuid/01D807D412ACB800";
      fsType = "ntfs3";
      options = ["rw" "uid=1000" "gid=100" "dmask=022" "fmask=133"];
    };
    "/mnt/media" = {
      device = "/dev/disk/by-uuid/01DB740DE6A065F0";
      fsType = "ntfs3";
      options = ["rw" "uid=1000" "gid=100" "dmask=022" "fmask=133"];
    };
  };
}
