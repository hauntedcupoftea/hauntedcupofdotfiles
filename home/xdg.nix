{pkgs, ...}: {
  xdg = {
    userDirs.enable = true;
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        gnome-keyring
        xdg-desktop-portal-termfilechooser
      ];
      config.common = {
        default = ["hyprland" "gtk"];
        "org.freedesktop.impl.portal.FileChooser" = ["termfilechooser" "gtk"];
      };
    };
    mimeApps = {
      enable = true;

      defaultApplications = {
        "text/html" = "zen-twilight.desktop";
        "x-scheme-handler/http" = "zen-twilight.desktop";
        "x-scheme-handler/https" = "zen-twilight.desktop";
        "x-scheme-handler/chrome" = "zen-twilight.desktop";
        "application/x-extension-htm" = "zen-twilight.desktop";
        "application/x-extension-html" = "zen-twilight.desktop";
        "application/x-extension-shtml" = "zen-twilight.desktop";
        "application/xhtml+xml" = "zen-twilight.desktop";
        "application/x-extension-xhtml" = "zen-twilight.desktop";
        "application/x-extension-xht" = "zen-twilight.desktop";
        "application/pdf" = "org.pwmt.zathura.desktop";
        "application/x-pdf" = "org.pwmt.zathura.desktop";
        "x-scheme-handler/discord" = "vesktop.desktop";
        "x-scheme-handler/ror2mm" = "r2modman.desktop";
      };

      associations.added = {
        "text/html" = ["zen-twilight.desktop" "firefox.desktop"];
        "x-scheme-handler/http" = ["zen-twilight.desktop" "firefox.desktop"];
        "x-scheme-handler/https" = ["zen-twilight.desktop" "firefox.desktop"];
        "x-scheme-handler/chrome" = ["zen-twilight.desktop" "firefox.desktop"];
        "application/x-extension-htm" = ["zen-twilight.desktop" "firefox.desktop"];
        "application/x-extension-html" = ["zen-twilight.desktop" "firefox.desktop"];
        "application/x-extension-shtml" = ["zen-twilight.desktop" "firefox.desktop"];
        "application/xhtml+xml" = ["zen-twilight.desktop" "firefox.desktop"];
        "application/x-extension-xhtml" = ["zen-twilight.desktop" "firefox.desktop"];
        "application/x-extension-xht" = ["zen-twilight.desktop" "firefox.desktop"];
        "application/pdf" = ["org.pwmt.zathura.desktop" "sioyek.desktop" "okularApplication_pdf.desktop" "firefox.desktop"];
        "application/x-pdf" = ["org.pwmt.zathura.desktop" "sioyek.desktop" "okularApplication_pdf.desktop" "firefox.desktop"];
      };
    };
  };

  home.file = {
    ".config/xdg-desktop-portal-termfilechooser/config" = {
      text = ''
        [filechooser]
        cmd=yazi-wrapper.fish
        env=EDITOR=hx
      '';
    };
    ".config/xdg-desktop-portal-termfilechooser/yazi-wrapper.fish" = {
      executable = true;
      source = ../custom-files/termfilechooser/yazi-wrapper.fish;
    };
  };

  home.sessionVariables = {
    GTK_USE_PORTAL = "1";
  };
}
