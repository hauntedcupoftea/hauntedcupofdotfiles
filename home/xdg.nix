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

  home.file = {
    ".config/xdg-desktop-portal-termfilechooser/config" = {
      text = ''
        [filechooser]
        cmd=yazi-wrapper.fish
        env=TERMCMD=kitty
            EDITOR=hx
      '';
    };
    ".config/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh" = {
      executable = true;
      source = ../custom-files/termfilechooser/yazi-wrapper.sh;
    };
  };

  home.sessionVariables = {
    GTK_USE_PORTAL = "1";
  };
}
