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

  # some packages needed

  # the service doesn't work i kneel to home manager
  systemd.user.services.qs = {
    description = "QuickShell Service";
    wantedBy = ["graphical-session.target"];
    serviceConfig = {
      ExecStart = "${lib.getExe pkgs.uwsm} app -- ${lib.getExe pkgs.quickshell} -p /home/tea/hauntedcupofdotfiles/custom-files/quickshell";
      Restart = "on-failure";
    };
    # thanks, random botan fan
    enableDefaultPath = false;
    environment = {
      QT_SCALE_FACTOR = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "0";
    };
  };
}
