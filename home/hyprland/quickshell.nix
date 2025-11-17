{
  pkgs,
  lib,
  ...
}: {
  systemd.user.services = {
    qs = {
      Unit = {
        Description = "QuickShell Service";
      };

      Service = {
        ExecStart = "${lib.getExe pkgs.uwsm} app -- qs -p /home/tea/hauntedcupofdotfiles/custom-files/quickshell/";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = ["default.target"];
      };
    };

    zmkbatx = {
      Unit = {
        Description = "ZMK Battery Status";
        After = ["qs.service"];
        Requires = ["qs.service"];
      };
      Service = {
        ExecStart = "${lib.getExe pkgs.uwsm} app -- zmkbatx";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
