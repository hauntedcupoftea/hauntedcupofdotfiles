{ pkgs, ... }: {
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk gnome-keyring ];
    config = {
      common = {
        default = [ "gtk" ];
      };
      preferred = {
        default = [ "hyprland" "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };
  };
}
