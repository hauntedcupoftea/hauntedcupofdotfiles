{
  config,
  lib,
  pkgs,
  ...
}: {
  boot = {
    # Enable GRUB
    loader.grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      enableCryptodisk = false;
      useOSProber = true; # Detect Windows
      default = "saved";
    };

    loader.efi.canTouchEfiVariables = true;

    # Add NTFS support
    supportedFilesystems = ["ntfs"];
  };
}
