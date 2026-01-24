{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.hyprland.nixosModules.default];

  # Enable Hyprland at the system level
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs {
      patches = [../../custom-files/patches/hypr-glaze-patch.txt];
    };
    withUWSM = true;
    xwayland.enable = true; # Kinda needed for electron apps sadly
  };

  # Ensure necessary packages are installed
  environment.systemPackages = with pkgs; [
    hyprland
    kitty
    libnotify

    # Wi-Fi
    networkmanagerapplet
    impala

    # audio
    pwvucontrol
    alsa-utils

    wl-clipboard
    clipse
    playerctl
    hyprpicker
    libqalculate

    # xdg-focused stuff
    xdg-utils
    shared-mime-info
    glib
    gtk3
    gtk4
  ];

  # novideo setup
  environment.sessionVariables = lib.mkIf (builtins.elem "nvidia" config.services.xserver.videoDrivers) {
    NIXOS_OZONE_WL = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };

  programs.uwsm = {
    enable = true;
    # waylandCompositors = {
    #   hyprland = {
    #     prettyName = "Hyprland";
    #     comment = "Hyprland compositor managed by UWSM";
    #     binPath = "/run/current-system/sw/bin/Hyprland";
    #   };
    # };
  };

  # XDG Portal configuration
  xdg.portal.enable = true;
}
