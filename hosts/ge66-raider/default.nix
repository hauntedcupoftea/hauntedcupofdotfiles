{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Hardware configuration
    ./hardware-configuration.nix

    # Core modules
    ../../modules/core

    # Hardware modules
    ../../modules/hardware

    # Desktop environment
    ../../modules/desktop

    # User configuration
    ../../users
  ];

  # Host-specific overrides can go here
  networking.hostName = "Anand-GE66-Raider";

  # This value determines the NixOS release
  system.stateVersion = "24.11";
}
