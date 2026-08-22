{
  config,
  lib,
  osConfig,
  ...
}: let
  cfg = config.dotfiles.desktop;
in {
  options.dotfiles.desktop.packages = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [];
    description = "Extra desktop-scoped packages. Silently omitted if dotfiles.desktop.enable is false.";
  };

  config = lib.mkIf (osConfig.dotfiles.desktop.enable && cfg.packages != []) {
    packages = cfg.packages;
  };
}
