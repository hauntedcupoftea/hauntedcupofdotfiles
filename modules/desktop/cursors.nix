{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.programs.hyprland.enable {
    environment.sessionVariables = {
      HYPRCURSOR_THEME = "Bibata-modern";
      HYPRCURSOR_SIZE = 24;
      XCURSOR_THEME = "Bibata-Modern-Classic";
      XCURSOR_SIZE = 24;
      XCURSOR_PATH = ["${pkgs.bibata-cursors}/share/icons"];
    };

    environment.systemPackages = [pkgs.hyprcursor];

    programs.dconf.profiles.user.databases = [
      {
        lockAll = true;
        settings = {
          "org/gnome/desktop/interface" = {
            cursor-theme = "Bibata-Original-Classic";
            cursor-size = 24;
          };
        };
      }
    ];
  };
}
