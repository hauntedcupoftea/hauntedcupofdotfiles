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

  config = lib.mkIf cfg.enable {
    packages = [
      awww
      pkgs.matugen # material you color generation
      pkgs.wallust # base16 color generation
    ];
  };
}
