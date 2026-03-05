{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.shell;
in {
  options.dotfiles.shell.packages = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [];
    description = "Extra shell-scoped packages to install regardless of desktop.";
  };

  config = lib.mkIf (cfg.packages != []) {
    packages = cfg.packages;
  };
}
