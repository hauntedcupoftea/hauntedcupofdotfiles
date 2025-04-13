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
        font-family: "DejaVu Sans", "Font Awesome 5 Free";
        margin: 0px;
        border: 1px solid rgba(0, 0, 0, 0.9);
        background-color: rgba(29, 31, 33, 0.95);
        border-radius: 10px;
      }

      #input {
        margin: 5px;
        border: none;
        color: #f8f8f2;
        background-color: rgba(55, 59, 65, 0.95);
      }

      #inner-box {
        margin: 5px;
        border: none;
        background-color: transparent;
      }

      #outer-box {
        margin: 5px;
        border: none;
        background-color: transparent;
      }

      #scroll {
        margin: 0px;
        border: none;
      }

      #text {
        margin: 5px;
        border: none;
        color: #c5c8c6;
      }

      #entry {
        border: none;
      }

      #entry:focus {
        border: none;
      }

      #entry:selected {
        background-color: rgba(55, 59, 65, 0.95);
        border-radius: 5px;
        border: none;
      }
    '';
  };
}
