{ pkgs
, ...
}: {
  programs.fish = {
    enable = true;
    useBabelfish = true;
  };
  environment.systemPackages = [
    pkgs.kitty # required for the default Hyprland config
  ];
}
