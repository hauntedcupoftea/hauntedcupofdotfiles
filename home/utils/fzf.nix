{ ... }: {
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };
  catppuccin.fzf.enable = true;
}
