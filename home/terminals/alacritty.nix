{ ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = { family = "Fira Code Nerd Font"; style = "Regular"; };
        size = 12;
      };
      window = {
        padding = { x = 1; y = 2; };
        opacity = 0.95;
        blur = true;
      };
      cursor.style = {
        shape = "Block";
        blinking = "On";
      };
    };
  };

  home.sessionVariables = {
    TERM = "alacritty";
  };
}
