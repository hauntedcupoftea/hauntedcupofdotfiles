{
  config,
  lib,
  osConfig,
  ...
}: let
  cfg = config.dotfiles.desktop.obs;
in {
  options.dotfiles.desktop.obs.enable =
    lib.mkEnableOption "OBS Studio screen recorder";

  config = lib.mkIf (osConfig.dotfiles.desktop.enable && cfg.enable) {
    rum.programs.obs-studio.enable = true;
  };
}
