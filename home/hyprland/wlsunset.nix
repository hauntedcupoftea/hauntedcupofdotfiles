{ ... }: {
  services.gammastep = {
    enable = true;
    provider = "geoclue2"; # Automatically finds your location for sunset/sunrise
    settings = {
      general = {
        fade = 1;
        temp-day = 6500;
        temp-night = 3800;
        transition-duration = 60;
      };
    };
  };
}
