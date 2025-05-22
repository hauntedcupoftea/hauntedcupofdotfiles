{ pkgs, config, ... }: {
  services.hyprpaper = {
    enable = true;
    package = pkgs.hyprpaper;
    settings = {
      ipc = "on";

      #!! you might need to change this, because i'm not pushing the wallpapers to github.
      preload = [
        "${config.home.homeDirectory}/Wallpapers/wallpaper-elden-ring.jpg"
        "${config.home.homeDirectory}/Wallpapers/wallpaper-fern.png"
        "${config.home.homeDirectory}/Wallpapers/wallpaper-malenia.jpg"
      ];

      #!! change this
      wallpaper = [
        "DP-2, ${config.home.homeDirectory}/Wallpapers/wallpaper-malenia.jpg"
        "eDP-1, ${config.home.homeDirectory}/Wallpapers/wallpaper-fern.png"
      ];
    };
  };
  home.packages = [ pkgs.hyprpaper ];
}
