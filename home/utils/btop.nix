{ pkgs, ... }: {
  programs.btop = {
    enable = true;
    package = pkgs.btop;
  };
  # catppuccin.btop.enable = true;
}
