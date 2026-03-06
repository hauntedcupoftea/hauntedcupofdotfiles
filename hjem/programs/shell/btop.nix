{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.shell.btop;
in {
  options.dotfiles.shell.btop.enable =
    lib.mkEnableOption "btop system resource monitor";

  config = lib.mkIf cfg.enable {
    # TODO: theming
    packages = [pkgs.btop];
  };
}
