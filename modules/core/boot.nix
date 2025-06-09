{ pkgs
, ...
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

    kernelPackages = pkgs.linuxPackages_6_14; # temporarily until openrazer is fixed

    loader.efi.canTouchEfiVariables = true;
    plymouth.enable = true;

    # Add NTFS support
    supportedFilesystems = [ "ntfs" ];
  };
}
