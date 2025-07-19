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
        "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
      };
    };
  };

  # Configure termfilechooser
  home.file.".config/xdg-desktop-portal-termfilechooser/config".text = ''
    [Default]
    cmd=kitty yazi --chooser-file=%f
    file=%f
    directory=%d
  '';
}
