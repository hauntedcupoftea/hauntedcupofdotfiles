{
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

  # some packages needed

  # the service doesn't work i kneel to home manager
}
