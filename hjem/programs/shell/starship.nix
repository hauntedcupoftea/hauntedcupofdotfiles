{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.shell.starship;
  fishOn = config.dotfiles.shell.fish.enable;
in {
  options.dotfiles.shell.starship.enable =
    lib.mkEnableOption "starship cross-shell prompt";

  config = lib.mkIf cfg.enable {
    rum.programs.starship = {
      enable = true;
      integrations.fish.enable = fishOn;
    };
  };
}
