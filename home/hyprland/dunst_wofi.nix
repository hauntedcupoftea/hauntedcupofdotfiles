{...}: {
  # Dunst configuration
  services.dunst = {
    enable = true;
    settings = {
      font = "FiraCode Nerd Font 12";
      geometry = "300x50-10+10";
      transparency = 0;
      frame_width = 1;
      separator_height = 2;
      padding = 8;
      icon_size = 32;
      alignment = "left";
      horizontal_padding = 10;
      vertical_padding = 10;
      border_color = "#cba6f7";
      background = "#1e1e2e";
      foreground = "#cdd6f4";
    };
  };

  programs.wofi = {
    enable = true;
    settings = {
      show_icons = true;
      prompt = "Run:";
      font = "FiraCode Nerd Font 12";
      width = "50%";
      height = "50%";
      border = 2;
      border_color = "#cba6f7";
      background_color = "#1e1e2e";
      text_color = "#cdd6f4";
      selection_background_color = "#cba6f7";
      selection_text_color = "#1e1e2e";
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
