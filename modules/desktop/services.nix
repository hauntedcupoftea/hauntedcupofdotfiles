{
  pkgs,
  lib,
  ...
}: {
  systemd.user.services = {
    zmkbatx = {
      description = "ZMK Battery Status";
      wantedBy = ["hyprland-session.target"];
      partOf = ["hyprland-session.target"];
      after = ["hyprland-session.target" "qs.service"];
      requires = ["qs.service"];
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.uwsm} app -- ${lib.getExe pkgs.zmkbatx}";
        Restart = "on-failure";
      };
    };
  };
}
