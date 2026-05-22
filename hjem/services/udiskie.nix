{
  config,
  lib,
  pkgs,
  nixosConfig ? {},
  ...
}: let
  cfg = config.dotfiles.services.udiskie;
  yamlFormat = pkgs.formats.yaml {};
  isDesktop = nixosConfig.dotfiles.desktop.enable or false;

  mergedSettings =
    lib.recursiveUpdate {
      program_options = {
        automount = cfg.automount;
        tray =
          if cfg.tray == "always"
          then true
          else if cfg.tray == "never"
          then false
          else "auto";
        notify = cfg.notify;
      };
    }
    cfg.settings;

  hasTray = isDesktop && cfg.tray != "never";
in {
  options.dotfiles.services.udiskie = {
    enable = lib.mkEnableOption "udiskie mount daemon";

    package = lib.mkPackageOption pkgs "udiskie" {};

    settings = lib.mkOption {
      type = yamlFormat.type;
      default = {};
      description = "udiskie configuration (YAML). Merged with automount/notify/tray.";
    };

    automount = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Automatically mount new devices.";
    };

    notify = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Show pop‑up notifications.";
    };

    tray = lib.mkOption {
      type = lib.types.enum ["always" "auto" "never"];
      default = "auto";
      description = "Tray icon behaviour (only effective on desktop).";
    };

    appIndicator = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use --appindicator flag (requires libappindicator, desktop only).";
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [cfg.package];

    xdg.config.files."udiskie/config.yml".source =
      yamlFormat.generate "udiskie-config.yml" mergedSettings;

    # Tray target – only on desktop when needed
    systemd.targets.tray = lib.mkIf hasTray {
      description = "Tray icons target";
      wantedBy = ["graphical-session.target"];
    };

    systemd.services.udiskie = {
      description = "udiskie mount daemon";
      wantedBy = ["graphical-session.target"];
      after = ["graphical-session.target"] ++ lib.optional hasTray "tray.target";
      requires = lib.optional hasTray "tray.target";
      partOf = ["graphical-session.target"];

      serviceConfig = {
        ExecStart = let
          args =
            [(lib.getExe' cfg.package "udiskie")]
            ++ lib.optional (isDesktop && cfg.appIndicator) "--appindicator";
        in
          toString args;
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
