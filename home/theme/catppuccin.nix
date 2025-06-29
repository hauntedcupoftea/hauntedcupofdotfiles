{ ...
}: {
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "blue";

    # APPLICATION SETTINGS
    alacritty.enable = true;
    bat.enable = true;
    btop.enable = true;
    cursors = {
      enable = true;
      accent = "dark";
    };
    mako.enable = true;
    fish.enable = true;
    fzf.enable = true;
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
    yazi.enable = true;
  };
}
