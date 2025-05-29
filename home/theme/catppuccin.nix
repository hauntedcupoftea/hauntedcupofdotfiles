{ ...
}: {
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "blue";
    dunst.enable = true;
    btop.enable = true;
    cursors = {
      enable = true;
      accent = "dark";
    };
    gitui.enable = true;
    gtk = {
      enable = true;
      icon.enable = true;
      tweaks = [ "black" ];
    };
    hyprland.enable = true;
  };
}
