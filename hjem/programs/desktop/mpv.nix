{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.dotfiles.desktop.mpv;
in {
  options.dotfiles.desktop.mpv.enable =
    lib.mkEnableOption "mpv media player";

  config = lib.mkIf (osConfig.dotfiles.desktop.enable && cfg.enable) {
    rum.programs.mpv = {
      enable = true;
      scripts = with pkgs.mpvScripts; [mpris mpv-discord mpv-notify-send];
      profiles.gpu-hq = {};
      config.profile = "gpu-hq";
    };
  };
}
