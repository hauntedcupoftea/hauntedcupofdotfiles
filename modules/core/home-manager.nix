{
  config,
  lib,
  pkgs,
  ...
}: {
  # Add home-manager to system packages
  environment.systemPackages = with pkgs; [
    home-manager
  ];
}
