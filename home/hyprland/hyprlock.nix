{ pkgs, ... }: {
  programs.hyprlock = {
    enable = true;
    package = pkgs.hyprlock;
  };
  # catppuccin.hyprlock.enable = true;
}
