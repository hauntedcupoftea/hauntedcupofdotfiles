{ pkgs, ... }: {
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      gnome-keyring
      xdg-desktop-portal-termfilechooser
    ];
    config.common = {
      default = [ "hyprland" "gtk" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" "gtk" ];
    };
  };

  xdg.configFile."/xdg-desktop-portal-termfilechooser/config".text = ''
    [filechooser]
    cmd=${../../custom-files/termfilechooser/yazi-wrapper.sh}
    env=TERMCMD=kitty
        EDITOR=hx
  '';

  environment.sessionVariables = {
    GTK_USE_PORTAL = "1";
  };
}
