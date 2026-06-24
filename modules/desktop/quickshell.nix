{
  lib,
  pkgs,
  inputs,
  ...
}: let
  qs = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
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
}
