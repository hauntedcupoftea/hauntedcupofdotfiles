{ ... }: {
  # SEE modules/desktop/quickshell.nix for qs config
  qt = {
    enable = true;
    # catppuccin says we need this
    style.name = "kvantum";
    platformTheme.name = "kvantum";
  };
}
