{
  lib,
  pkgs,
  ...
}: let
  lockscreenConfig = pkgs.writeText "hyprland.lua" ''
    hl.monitor({
      output = "",
      mode = "preferred",
      position = "auto",
      scale = "auto",
    })

    hl.config({
      misc = {
        force_default_wallpaper = 1,
        disable_hyprland_logo = true,
      },
    })

    hl.on("hyprland.start", function()
      hl.exec_cmd("${lib.getExe pkgs.qtgreet} && hyprshutdown")
    end)
  '';
in {
  services.greetd = {
    enable = true;
    greeterManagesPlymouth = true;
    settings = {
      default_session = {
        command = "${pkgs.hyprland}/bin/start-hyprland -- --config ${lockscreenConfig}";
      };
    };
  };

  security.pam.services.greetd = {
    gaze = {
      enable = true;
      control = "sufficient";
      simultaneous = false;
    };

    text = ''
      auth      substack      login
      account   include       login
      password  substack      login
      session   include       login
    '';
  };
}
