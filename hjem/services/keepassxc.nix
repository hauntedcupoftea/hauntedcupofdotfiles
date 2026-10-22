{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.services.keepassxc;
  nativeMessagingManifest = "${cfg.package}/lib/mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json";
in {
  options.dotfiles.services.keepassxc = {
    enable = lib.mkEnableOption "KeePassXC password manager";
    package = lib.mkPackageOption pkgs "keepassxc" {};
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
      after = ["quickshell.service" "graphical-session.target"];
      partOf = ["graphical-session.target"];
      serviceConfig = {
        ExecStart = lib.getExe' cfg.package "keepassxc";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
