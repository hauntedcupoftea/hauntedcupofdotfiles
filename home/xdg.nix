{ pkgs, ... }: {
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      gnome-keyring
      xdg-desktop-portal-termfilechooser
    ];
    config = {
      common = {
        default = [ "gtk" ];
      };
      preferred = {
        default = [ "hyprland" ];
      };
    };
  };
}
