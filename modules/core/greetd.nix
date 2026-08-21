{
  lib,
  pkgs,
  config,
  ...
}: let
  lockscreenConfig = ''
    monitor = ,preferred, auto, auto
    env=XDG_CURRENT_DESKTOP,Hyprland
    exec-once = ${lib.getExe pkgs.quickshell} && hyprctl dispatch exit

    misc {
      force_default_wallpaper = 1
      disable_hyprland_logo = true
    }
  '';
in {
  services.greetd = {
    enable = true;
    greeterManagesPlymouth = true;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.tuigreet} --time --cmd start-hyprland --sessions /run/current-system/sw/share/wayland-sessions";
        # command = "${pkgs.hyprland}/bin/start-hyprland -- --config ${lockscreenConfig}";
      };
    };
  };

  security.pam.services.greetd = {
    gaze = {
      enable = true;
      control = "sufficient";
      simultaneous = true;
    };

    text = ''
      auth      substack      login
      account   include       login
      password  substack      login
      session   include       login
    '';
  };

  boot.kernelParams =
    map (m: "video=${m.name}:${m.resolution}@${toString m.refreshRate}")
    config.dotfiles.desktop.monitors;
}
