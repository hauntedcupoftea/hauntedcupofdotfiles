{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.desktop;
  isGnomeEnabled = cfg.enable && (builtins.elem "gnome" cfg.environment);
in {
  config = lib.mkIf isGnomeEnabled {
    # Enable the GNOME Desktop Environment.
    services.xserver.desktopManager.gnome.enable = true;

    # Common GNOME utilities
    environment.systemPackages = with pkgs; [
      gnome-tweaks
    ];

    # Enable printing
    services.printing.enable = true;
  };
}
