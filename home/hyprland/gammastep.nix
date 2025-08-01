{ lib, config, ... }: {
  services.gammastep = {
    enable = false; # temporarily turning this off
    tray = false;
    provider = "geoclue2"; # Automatically finds your location for sunset/sunrise
    settings = {
      general = {
        fade = 1;
        temp-day = lib.mkForce 6500;
        temp-night = lib.mkDefault 3800;
      };
    };
  };

  home.file = {
    "${config.xdg.configHome}/gammastep/hooks" = {
      source = ../../custom-files/gammastep/hooks;
      recursive = true;
    };
  };
}
