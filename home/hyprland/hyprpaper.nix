{
  config,
  inputs,
  system,
  ...
}: {
  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${system}.default;
    settings = {
      ipc = true;
      splash = false;

      #!! you might need to change this, because i'm not pushing the wallpapers to github.
      preload = [
        "${config.home.homeDirectory}/Wallpapers/"
      ];

      wallpaper = [
        {
          monitor = "DP-2";
          path = "${config.home.homeDirectory}/Wallpapers/";
          timeout = 3600;
        }
        {
          monitor = "eDP-1";
          path = "${config.home.homeDirectory}/Wallpapers/";
          timeout = 3600;
        }
      ];
    };
  };
  home.packages = [inputs.hyprpaper.packages.${system}.default];
}
