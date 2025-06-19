{ ... }: {
  # Mako configuration
  services.mako = {
    enable = true;
    settings = {
      actions = true;
      font = "FiraCode Nerd Font 12";
      width = 500;
      max-height = 300;
      anchor = "bottom-right";
      margin = "10,30,50";
      padding = 10;
      border-size = 1;
      # background-color = "#37474fE6";
      # text-color = "#eceff1";
      text-alignment = "left";
      max-visible = 20;
      default-timeout = 10000;

      "urgency=low" = {
        border-color = "#44B9B1E6";
        default-timeout = 5000;
      };

      "urgency=normal" = {
        border-color = "#eceff1E6";
      };

      "urgency=critical" = {
        border-color = "#f44336E6";
        font = "FiraCode Nerd Font Bold 12";
        default-timeout = 0;
      };

      actionable = {
        border-color = "#2196f3E6";
      };
    };
  };
}
