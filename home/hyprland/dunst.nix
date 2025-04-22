{...}: {
  # Dunst configuration
  services.dunst = {
    enable = true;
    settings = {
      global = {
        offset = "30x50";
        height = "(0, 300)";
        width = "(0, 500)";
        origin = "bottom-right";
        transparency = 10;
        font = "FiraCode Nerd Font 12";
        frame_width = 1;
        separator_height = 2;
        padding = 8;
        icon_size = 32;
        alignment = "left";
        horizontal_padding = 10;
        vertical_padding = 10;
      };

      urgency_normal = {
        background = "#37474f";
        foreground = "#eceff1";
        timeout = 10;
      };
    };
  };
}
