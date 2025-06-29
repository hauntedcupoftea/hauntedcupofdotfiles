{ pkgs
, ...
}: {
  programs.fish.enable = true;
  environment.systemPackages = [
    pkgs.alacritty # required for the default Hyprland config
  ];
}
