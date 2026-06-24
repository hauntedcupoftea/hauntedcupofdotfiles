{...}: {
  # Mount points for my Windows drives using the ntfs3 kernel driver
  fileSystems = {
    "/shared" = {
      device = "/dev/disk/by-uuid/01DB740DE6A065F0";
      fsType = "ntfs3";
      options = [
        "rw"
        "uid=1000"
        "gid=100"
        "umask=007"
        "nofail"
      ];
    };
  };
}
