# embridge-module.nix
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.embridge;
  stateDir = "/var/lib/embridge";
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

      preStart = ''
        # Ensure state directory exists and is populated
        if [ ! -f ${stateDir}/emBridge ]; then
          ${pkgs.rsync}/bin/rsync -a ${cfg.package.passthru.unwrapped}/opt/eMudhra/emBridge-3.3.0.2/ ${stateDir}/
          chmod -R u+w ${stateDir}
        fi
      '';

      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/embridge";
        StateDirectory = "embridge";
        Restart = "always";
        RestartSec = 10;

        PrivateTmp = true;
        NoNewPrivileges = false;
      };
    };

    services.pcscd.enable = true;
  };
}
