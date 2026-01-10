{
  config,
  pkgs,
  ...
}: {
  services.hyprpaper = {
    enable = true;
    package = pkgs.hyprpaper;
    settings = {
      ipc = true;
      splash = false;

      preload = [
        "${config.home.homeDirectory}/Wallpapers/"
      ];

      wallpaper = [
        {
          monitor = "DP-2";
          path = "${config.home.homeDirectory}/Wallpapers/";
          timeout = 3600; # 1 hour
        }
        {
          monitor = "eDP-1";
          path = "${config.home.homeDirectory}/Wallpapers/";
          timeout = 3600; # 1 hour
        }
      ];
    };
  };
  home.packages = [pkgs.hyprpaper];
}
