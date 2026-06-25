{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.desktop;
  isPlasmaEnabled = cfg.enable && (builtins.elem "plasma" cfg.environment);
in {
  config = lib.mkIf isPlasmaEnabled {
    services.desktopManager.plasma6.enable = true;
  };
}
