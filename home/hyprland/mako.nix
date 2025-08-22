{...}: {
  # Mako configuration
  services.mako = {
    enable = false; # turn this on if want mako
    settings = {
      actions = true;
      history = true;
      # font = "FiraCode Nerd Font 12";
      width = 500;
      height = 300;
      anchor = "bottom-right";
      outer-margin = "0,30,50,0";
      margin = "2, 10";
      padding = 12;
      border-size = 1;
      text-alignment = "left";
      max-visible = 20;
      default-timeout = 10000;
      max-history = 20;
      border-radius = 8;

      "urgency=low" = {
        #   border-color = "#44B9B1E6";
        default-timeout = 5000;
      };

      "urgency=normal" = {
        # border-color = "#eceff1E6";
      };

      "urgency=critical" = {
        #   border-color = "#f44336E6";
        # font = "FiraCode Nerd Font Bold 12";
        default-timeout = 0;
      };

      # actionable = {
      #   border-color = "#2196f3E6";
      # };
    };
  };
  # catppuccin.mako.enable = true;
}
