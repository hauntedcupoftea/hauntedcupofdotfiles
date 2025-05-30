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
  };
}
