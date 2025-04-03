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

  programs.wofi = {
    enable = true;
    settings = {
      show_icons = true;
      prompt = "Run:";
      font = "FiraCode Nerd Font 16";
      width = "50%";
      height = "50%";
      border = 2;
    };
    style = ''
          window {
          background-color: #1e1e2e;
          border: 2px solid #cba6f7;
          border-radius: 8px;
          padding: 10px;
      }

      entry {
          background-color: #1e1e2e;
          color: #cdd6f4;
      }

      entry:selected {
          background-color: #cba6f7;
          color: #1e1e2e;
      }

      list {
          background-color: #1e1e2e;
          color: #cdd6f4;
      }

      list:selected {
          background-color: #cba6f7;
          color: #1e1e2e;
      }
    '';
  };
}
