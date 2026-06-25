{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.desktop;
  qs = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
  isHyprlandEnabled = cfg.enable && (builtins.elem "hyprland" cfg.environment);
in {
  config = lib.mkIf isHyprlandEnabled {
    # prerequisites
    environment.systemPackages = with pkgs.kdePackages; [
      qs
      qtdeclarative
      qt5compat
      qtstyleplugin-kvantum
      qtsvg
    ];

    # qt itself
    qt.enable = true;
  };
}
