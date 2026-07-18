{...}: {
  # Mount points for my Windows drives using the ntfs3 kernel driver
  fileSystems = {
    "/shared" = {
      device = "/dev/disk/by-uuid/68A6142CA613F970";
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
