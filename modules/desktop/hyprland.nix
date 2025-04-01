{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  # Enable Hyprland at the system level
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.default;
    withUWSM = true;
    xwayland.enable = true;
  };

  # Ensure necessary packages are installed
  environment.systemPackages = with pkgs; [
    hyprland
    kitty
    waybar
    wofi
    dunst
    libnotify
    networkmanagerapplet
    pavucontrol
    wl-clipboard
    clipse
  ];

  # XDG Portal configuration
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config = {
      common.default = ["gtk"];
      hyprland.default = [
        "gtk"
        "hyprland"
      ];
    };
  };
}
