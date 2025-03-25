{pkgs, ...}: {
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "catppuccin-mocha";
    package = pkgs.kdePackages.sddm;
  };

  environment.systemPackages = [
    (
      pkgs.catppuccin-sddm.override {
        flavor = "mocha";
        font = "FiraCode Nerd Font";
        fontSize = "16";
        # background = "${./wallpaper.png}";
        # loginBackground = true;
      }
    )
  ];
}
