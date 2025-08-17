{
  inputs,
  pkgs,
  ...
}: {
  # Enable Hyprland at the system level
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.default;
    withUWSM = true;
    xwayland.enable = true; # Kinda needed for electron apps sadly
  };

  # Ensure necessary packages are installed
  environment.systemPackages = with pkgs; [
    hyprland
    kitty
    waybar
    libnotify

    # Wi-Fi
    networkmanagerapplet
    impala

    # audio
    pwvucontrol
    sonusmix
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

  # These are actually tied to both Nvidia and Hyprland in part,
  # so PLEASE consult the Hyprland wiki before building this on non novideo systems
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
  xdg.portal.enable = true;
}
