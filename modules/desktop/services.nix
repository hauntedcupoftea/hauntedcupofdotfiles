{
  pkgs,
  lib,
  ...
}: {
  systemd.user.services = {
    zmkbatx = {
      description = "ZMK Battery Status";
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target" "qs.service"];
      requires = ["qs.service"];
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.uwsm} app -- ${lib.getExe pkgs.zmkbatx}";
        Restart = "on-failure";
      };
    };
  };
}
