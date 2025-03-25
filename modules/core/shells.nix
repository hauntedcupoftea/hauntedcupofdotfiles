{
  config,
  pkgs,
  ...
}: {
  programs.fish.enable = true;
  environment.systemPackages = [
    pkgs.kitty # required for the default Hyprland config
  ];
}
