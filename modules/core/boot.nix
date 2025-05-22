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
      default = "saved"; # Default to last booted OS
      configurationLimit = 8;
    };

    kernelPackages = pkgs.linuxPackages_latest;

    loader.efi.canTouchEfiVariables = true;
    plymouth.enable = false; # temporarily while we find out why no boot.

    # Add NTFS support
    supportedFilesystems = ["ntfs"];
  };
}
