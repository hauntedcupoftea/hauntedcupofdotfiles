{
  config,
  pkgs,
  ...
}: {
  programs.fish.enable = true;
  environment.systemPackages = [
    # ... other packages
    pkgs.kitty # required for the default Hyprland config
  ];
}
