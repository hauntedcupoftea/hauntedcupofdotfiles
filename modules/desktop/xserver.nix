{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.desktop;

  needsXServer =
    cfg.enable
    && (
      builtins.elem "plasma" cfg.environments
      || builtins.elem "gnome" cfg.environments
      || builtins.elem "hyprland" cfg.environments
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
