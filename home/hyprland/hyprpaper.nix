{pkgs, ...}: {
  services.hyprpaper = {
    enable = true;
    package = pkgs.hyprpaper;
  };
  home.packages = [pkgs.hyprpaper];
}
