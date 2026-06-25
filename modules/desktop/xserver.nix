{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.desktop;

  needsXServer =
    cfg.enable
    && (
      builtins.elem "plasma" cfg.environment
      || builtins.elem "gnome" cfg.environment
      || builtins.elem "hyprland" cfg.environment
    );
in {
  config = lib.mkIf needsXServer {
    # Enable the X11 windowing system.
    services.xserver = {
      enable = true;

      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };
}
