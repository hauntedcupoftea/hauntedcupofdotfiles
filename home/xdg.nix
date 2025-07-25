{ pkgs, ... }: {
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      gnome-keyring
      xdg-desktop-portal-termfilechooser
    ];
    config.common.default = [ "hyprland" "gtk" ];
    config."org.freedesktop.impl.portal.FileChooser" = {
      default = [ "termfilechooser" "gtk" ];
    };
  };

  home.file.".config/xdg-desktop-portal-termfilechooser/config".text = ''
    [filechooser]
    cmd=${../custom-files/termfilechooser/yazi-wrapper.sh}
    env=TERMCMD=kitty
        EDITOR=hx
  '';

  home.sessionVariables = {
    GTK_USE_PORTAL = "1";
  };
}
