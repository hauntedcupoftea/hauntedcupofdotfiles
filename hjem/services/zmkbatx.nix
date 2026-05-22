{
  config,
  lib,
  pkgs,
  nixosConfig ? {},
  ...
}: let
  cfg = config.dotfiles.services.zmkbatx;
  hasDesktop = nixosConfig.dotfiles.desktop.enable or false;
in {
  options.dotfiles.services.zmkbatx = {
    enable = lib.mkEnableOption "ZMK battery status monitor (zmkbatx)";
    package = lib.mkPackageOption pkgs "zmkbatx" {};
    uwsmPackage = lib.mkPackageOption pkgs "uwsm" {};
  };

  config = lib.mkIf (cfg.enable && hasDesktop) {
    packages = [cfg.package cfg.uwsmPackage];

    systemd.services.zmkbatx = {
      description = "ZMK Battery Status";
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target" "quickshell.service"];
      requires = ["quickshell.service"];

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.uwsmPackage} app -- ${lib.getExe cfg.package}";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
