{
  config,
  lib,
  pkgs,
  nixosConfig ? {},
  ...
}: let
  cfg = config.dotfiles.environments.hyprland.quickshell;
  hasDesktop = nixosConfig.dotfiles.desktop.enable or false;
in {
  options.dotfiles.environments.hyprland.quickshell = {
    enable = lib.mkEnableOption "QuickShell panel / lockscreen service";
    package = lib.mkPackageOption pkgs "quickshell" {};
    uwsmPackage = lib.mkPackageOption pkgs "uwsm" {};
    projectPath = lib.mkOption {
      type = lib.types.path;
      description = "Path to the quickshell project directory (contains main.qml or entry point)";
      example = "/home/tea/hauntedcupofdotfiles/custom-files/quickshell";
    };
    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Extra arguments passed to quickshell (e.g., [\"ipc\" \"call\" \"lockscreen\" \"lock\"])";
    };
    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        QT_SCALE_FACTOR = "1";
        QT_AUTO_SCREEN_SCALE_FACTOR = "0";
      };
      description = "Environment variables for the service";
    };
    systemdTarget = lib.mkOption {
      type = lib.types.str;
      default = "graphical-session.target";
      description = "Systemd target to bind to";
    };
  };

  config = lib.mkIf (cfg.enable && hasDesktop) {
    packages = [cfg.package cfg.uwsmPackage];

    systemd.services.quickshell = {
      description = "QuickShell UI service";
      wantedBy = [cfg.systemdTarget];
      partOf = [cfg.systemdTarget];
      after = [cfg.systemdTarget];

      serviceConfig = {
        ExecStart = ''
          ${lib.getExe cfg.uwsmPackage} app -- \
            ${lib.getExe cfg.package} -p ${cfg.projectPath} ${lib.escapeShellArgs cfg.extraArgs}
        '';
        Restart = "on-failure";
        RestartSec = 5;
      };
      environment = cfg.environment;
      enableDefaultPath = false; # keep minimal PATH
    };
  };
}
