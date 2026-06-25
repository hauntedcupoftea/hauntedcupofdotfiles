{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.dotfiles.desktop;
  isHyprlandEnabled = cfg.enable && (builtins.elem "hyprland" cfg.environment);
  isNvidia = builtins.elem "nvidia" config.services.xserver.videoDrivers;
in {
  imports = [inputs.hyprland.nixosModules.default];

  config = lib.mkIf isHyprlandEnabled {
    programs.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      withUWSM = true;
      xwayland.enable = true;
    };

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
      playerctl
      hyprpicker
      libqalculate
      # clipboard
      clipse
      wl-clipboard
      # xdg-focused stuff
      xdg-utils
      xdg-user-dirs
      shared-mime-info
      glib
      gtk3
      gtk4
    ];

    # novideo setup
    environment.sessionVariables =
      lib.mkIf (builtins.elem "nvidia" config.services.xserver.videoDrivers) {
        NIXOS_OZONE_WL = "1";
      }
      // lib.optionalAttrs isNvidia {
        LIBVA_DRIVER_NAME = "nvidia";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        NVD_BACKEND = "direct";
      };

    programs.uwsm = {
      enable = true;
    };

    # XDG Portal configuration
    xdg.portal.enable = true;
  };
}
