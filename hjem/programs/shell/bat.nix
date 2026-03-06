{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.shell.bat;
in {
  options.dotfiles.shell.bat.enable =
    lib.mkEnableOption "bat (cat with syntax highlighting)";

  config = lib.mkIf cfg.enable {
    # TODO: theming
    packages = [pkgs.bat];
  };
}
