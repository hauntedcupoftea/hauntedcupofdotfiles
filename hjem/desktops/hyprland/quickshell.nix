{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  qsCfg = config.rum.desktops.hyprland.quickshell;
  qs = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  config = lib.mkIf (config.rum.desktops.hyprland.enable && qsCfg.configPath != null) {
    packages = with pkgs.kdePackages; [
      qs
      qtdeclarative
      qt5compat
      qtstyleplugin-kvantum
      qtsvg
    ];

    files.".config/systemd/user/qs.service".text = ''
      [Unit]
      Description=QuickShell Service

      [Service]
      ExecStart=${lib.getExe pkgs.uwsm} app -- ${lib.getExe qs} -p ${qsCfg.configPath}
      Restart=on-failure
      Environment=QT_SCALE_FACTOR=1
      Environment=QT_AUTO_SCREEN_SCALE_FACTOR=0

      [Install]
      WantedBy=graphical-session.target
    '';

    files.".config/systemd/user/zmkbatx.service".text = ''
      [Unit]
      Description=ZMK Battery Status
      After=qs.service
      Requires=qs.service

      [Service]
      ExecStart=${lib.getExe pkgs.uwsm} app -- ${lib.getExe pkgs.zmkbatx}
      Restart=on-failure

      [Install]
      WantedBy=graphical-session.target
    '';
  };
}
