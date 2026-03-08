{
  lib,
  pkgs,
  config,
  ...
}: {
  services.greetd = {
    enable = true;
    greeterManagesPlymouth = true;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.tuigreet} --time --cmd start-hyprland --sessions /run/current-system/sw/share/wayland-sessions";
      };
    };
  };

  boot.kernelParams =
    map (m: "video=${m.name}:${m.resolution}@${toString m.refreshRate}")
    config.dotfiles.desktop.monitors;
}
