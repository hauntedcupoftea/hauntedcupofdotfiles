{
  inputs,
  pkgs,
  ...
}: let
  grubTheme = inputs.nixos-grub-themes.packages.${pkgs.stdenv.hostPlatform.system}.nixos;
in {
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
      theme = grubTheme; # TODO: probably consolidate theming into one module (split horizontally)
    };

    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = ["nvme"];

    loader.efi.canTouchEfiVariables = true;
    plymouth.enable = true;

    # Add NTFS support
    supportedFilesystems = ["ntfs"];
  };
}
