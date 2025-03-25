{
  config,
  lib,
  pkgs,
  ...
}: {
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Common GNOME utilities
  environment.systemPackages = with pkgs; [
    gnome-tweaks
  ];

  # Enable printing
  services.printing.enable = true;
}
