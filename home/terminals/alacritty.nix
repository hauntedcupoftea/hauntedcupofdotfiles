{ pkgs, ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        footer_bar = { foreground = "None"; background = "None"; };
      };
      cursor.style = {
        shape = "Block";
        blinking = "On";
      };
      font = {
        normal = { family = "Fira Code Nerd Font"; style = "Regular"; };
        size = 12;
      };
      window = {
        padding = { x = 1; y = 2; };
        opacity = 0.95;
        blur = true;
      };
      terminal.shell = "${pkgs.fish}/bin/fish";
    };
  };

  home.sessionVariables = {
    TERM = "alacritty";
  };
}
