{ pkgs
, ...
}: {
  programs.fish = {
    enable = true;
    useBabelfish = true;
    generateCompletions = false;
  };
  environment.systemPackages = [
    pkgs.kitty # required for the default Hyprland config
  ];
}
