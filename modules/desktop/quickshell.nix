{
  lib,
  pkgs,
  inputs,
  config,
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

  # service
  systemd.user.services = {
    qs = {
      enable = config.programs.hyprland.enable;
      description = "QuickShell Service";
      wantedBy = ["hyprland-session.target"];
      partOf = ["hyprland-session.target"];
      after = ["hyprland-session.target"];
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.uwsm} app -- qs -p /home/tea/hauntedcupofdotfiles/custom-files/quickshell";
        Restart = "on-failure";
        Environment = [
          "QT_SCALE_FACTOR=1"
          "QT_AUTO_SCREEN_SCALE_FACTOR=0"
        ];
      };
    };
  };
}
