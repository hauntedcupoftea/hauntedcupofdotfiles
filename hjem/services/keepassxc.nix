{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.services.keepassxc;
  iniFormat = pkgs.formats.ini {};
  mergedSettings =
    lib.recursiveUpdate {
      General.ConfigVersion = 2;
      SSHAgent.Enabled = cfg.sshAgent;
      FdoSecrets.Enabled = cfg.fdoSecrets;
      Browser.Enabled = cfg.browserIntegration.enable;
      GUI = {
        ShowTrayIcon = true;
        MinimizeToTray = true;
        MinimizeOnClose = true;
        MinimizeOnStartup = true;
        TrayIconAppearance = "colorful";
      };
      Security = {
        LockDatabaseIdle = true;
        LockDatabaseIdleSeconds = 600;
        LockDatabaseOnSuspend = true;
      };
    }
    cfg.settings;

  nativeMessagingManifest = "${cfg.package}/lib/mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json";
in {
  options.dotfiles.services.keepassxc = {
    enable = lib.mkEnableOption "KeePassXC password manager";
    package = lib.mkPackageOption pkgs "keepassxc" {};

    settings = lib.mkOption {
      type = iniFormat.type;
      default = {};
      description = "keepassxc.ini overrides, merged with the fixed toggles below.";
    };

    sshAgent = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable KeePassXC's built-in SSH agent.";
    };

    fdoSecrets = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable FreeDesktop.org Secret Service integration.";
    };

    browserIntegration = {
      enable = lib.mkEnableOption "browser extension integration" // {default = true;};
      zen = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Also link the native messaging manifest into Zen's profile path.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [cfg.package];

    xdg.config.files."keepassxc/keepassxc.ini".source =
      iniFormat.generate "keepassxc.ini" mergedSettings;

    files = lib.mkIf cfg.browserIntegration.enable (
      {
        ".mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json".source =
          nativeMessagingManifest;
      }
      // lib.optionalAttrs cfg.browserIntegration.zen {
        ".config/zen/native-messaging-hosts/org.keepassxc.keepassxc_browser.json".source =
          nativeMessagingManifest;
      }
    );

    systemd.services.keepassxc = {
      description = "KeePassXC autostart";
      wantedBy = ["graphical-session.target"];
      after = ["quickshell.service"];
      partOf = ["graphical-session.target"];
      serviceConfig = {
        ExecStart = lib.getExe' cfg.package "keepassxc";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
