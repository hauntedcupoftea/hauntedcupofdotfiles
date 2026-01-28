{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.embridge;
in {
  options.services.embridge = {
    enable = mkEnableOption "eMudhra eMbridge service for crypto token access";

    package = mkOption {
      type = types.package;
      default = pkgs.embridge;
      description = "The eMbridge package to use";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.embridge = {
      description = "eMudhra eMbridge Service";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/embridge";
        WorkingDirectory = "${cfg.package}/opt/eMudhra/emBridge-3.3.0.2";
        Restart = "always";
        RestartSec = 10;

        # Security hardening
        PrivateTmp = true;
        NoNewPrivileges = false;
      };
    };

    services.pcscd.enable = true;
  };
}
