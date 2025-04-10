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
    # xwayland.enable = true;
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
    playerctl
  ];

  # these are actually tied to both nvidia and hyprland in part,
  # so PLEASE consult the hyprland wiki before building this on non novideo systems
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };

  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
    };
  };

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
