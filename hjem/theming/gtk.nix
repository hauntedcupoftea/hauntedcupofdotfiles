{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.dotfiles.theming;
  colloidGtk = pkgs.colloid-gtk-theme;
  colloidIcons = pkgs.colloid-icon-theme;
in {
  config = lib.mkIf cfg.enable {
    packages = [
      colloidGtk
      colloidIcons
      pkgs.kdePackages.qtstyleplugin-kvantum
      pkgs.qt6Packages.qt6ct
      pkgs.libsForQt5.qt5ct
    ];

    environment.sessionVariables = {
      QT_STYLE_OVERRIDE = "kvantum";
    };

    files.".config/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=Colloid-Dark
      gtk-icon-theme-name=Colloid-dark
      gtk-font-name=FiraCode Nerd Font 11
      gtk-cursor-theme-name=Bibata-Modern-Classic
      gtk-cursor-theme-size=28
      gtk-application-prefer-dark-theme=1
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle=hintslight
      gtk-xft-rgba=rgb
    '';

    files.".config/gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=Colloid-Dark
      gtk-icon-theme-name=Colloid-dark
      gtk-font-name=FiraCode Nerd Font 11
      gtk-cursor-theme-name=Bibata-Modern-Classic
      gtk-cursor-theme-size=28
      gtk-application-prefer-dark-theme=1
    '';

    files.".config/gtk-3.0/gtk.css".text = ''
      @import 'colors.css';
    '';

    files.".config/gtk-4.0/gtk.css".text = ''
      @import 'colors.css';
    '';

    files.".config/Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=wallust
    '';

    files.".config/Kvantum/wallust/wallust.svg".source = ./static/Colloid.svg;
  };
}
