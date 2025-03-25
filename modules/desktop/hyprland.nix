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
  ];

  # XDG Portal configuration
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
    ];
    config = {
      common.default = ["gtk"];
      hyprland.default = [
        "gtk"
        "hyprland"
      ];
    };
  };
}
