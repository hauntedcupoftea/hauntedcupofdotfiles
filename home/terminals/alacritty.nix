{ ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 12;
      };
      window = {
        opacity = 0.8;
        blue = true;
      };
      cursor.blinking = "On";
    };
  };
}
