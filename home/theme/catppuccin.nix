{ ...
}: {
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "blue";
    bat.enable = true;
    btop.enable = true;
    cursors = {
      enable = true;
      accent = "dark";
    };
    dunst.enable = true;
    fish.enable = true;
    gtk = {
      enable = true;
      icon = {
        enable = false;
      };
      flavor = "mocha";
      accent = "blue";
      size = "standard";
      tweaks = [ "normal" ];
    };
    gitui = {
      enable = true;
      flavor = "mocha";
    };
    hyprland.enable = true;
    hyprlock.enable = true;
  };
}
