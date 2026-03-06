{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: let
  awww = inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww;
  cfg = config.dotfiles.theming;
in {
  options.dotfiles.theming = {
    enable = lib.mkEnableOption "hauntedcupofdotfiles themeing (awww + matugen + wallust)";
  };

  # Wallpaper daemon and color generation tools.
  # Future: add matugen/wallust hooks here to auto-recolor on wallpaper change.
  config = lib.mkIf cfg.enable {
    packages = [
      awww
      pkgs.matugen # material you color generation
      pkgs.wallust # base16 color generation
    ];
  };
}
